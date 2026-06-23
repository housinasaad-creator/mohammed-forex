import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../core/localization/app_strings.dart';
import '../features/dashboard/models/asset_model.dart';
import '../features/dashboard/models/analysis_result.dart';
import '../features/dashboard/models/candle_model.dart';
import 'news_calendar_service.dart';

class _SessionInfo {
  final String name;    // 'London/NY', 'London', 'New York', 'Tokyo', 'Sydney', 'London Lunch'
  final String warning; // '' = no warning; non-empty = warning text
  final double quality; // 0.0-1.0 for accuracy weighting
  const _SessionInfo(this.name, this.warning, this.quality);
}

class AnalysisService {
  AnalysisService._();

  // ── Market hours ───────────────────────────────────────────────────────────

  static bool _isMarketClosed() {
    final now = DateTime.now().toUtc();
    final wd  = now.weekday;
    if (wd == DateTime.saturday) return true;
    if (wd == DateTime.sunday  && now.hour < 21)  return true;
    if (wd == DateTime.friday  && now.hour >= 22) return true;
    return false;
  }

  // ── Session detection ──────────────────────────────────────────────────────
  // Sessions never stop analysis — only add a warning to factors.

  static _SessionInfo _sessionInfo(AppStrings s) {
    final now = DateTime.now().toUtc();
    final h   = now.hour + now.minute / 60.0;

    // London/NY overlap 13:00-17:00 — best liquidity
    if (h >= 13.0 && h < 17.0) {
      return const _SessionInfo('London/NY', '', 1.0);
    }
    // London morning 08:00-12:00
    if (h >= 8.0 && h < 12.0) {
      return const _SessionInfo('London', '', 0.85);
    }
    // London Lunch 12:00-13:00 — low liquidity warning
    if (h >= 12.0 && h < 13.0) {
      return _SessionInfo('London Lunch', s.sessionLunchWarning, 0.4);
    }
    // New York afternoon 17:00-22:00
    if (h >= 17.0 && h < 22.0) {
      return const _SessionInfo('New York', '', 0.75);
    }
    // Tokyo 00:00-08:00 (London catches 08:00+ first)
    if (h < 8.0) {
      return _SessionInfo('Tokyo', s.sessionTokyoWarning, 0.3);
    }
    // Sydney 22:00-24:00
    return _SessionInfo('Sydney', s.sessionSydneyWarning, 0.3);
  }

  // ── Candlestick pattern detection ──────────────────────────────────────────

  static String _detectPattern(List<Candle> candles) {
    if (candles.length < 2) return '';
    final curr = candles.last;
    final prev = candles[candles.length - 2];

    final range = curr.high - curr.low;
    if (range <= 0) return '';

    final body          = (curr.close - curr.open).abs();
    final upperWick     = curr.high - math.max(curr.open, curr.close);
    final lowerWick     = math.min(curr.open, curr.close) - curr.low;
    final bodyRatio     = body / range;
    final upperRatio    = upperWick / range;
    final lowerRatio    = lowerWick / range;

    // Pin Bar: body ≤30%, dominant wick ≥60%
    if (lowerRatio >= 0.6 && bodyRatio <= 0.3) return 'BullishPinBar';
    if (upperRatio >= 0.6 && bodyRatio <= 0.3) return 'BearishPinBar';

    // Engulfing: current body engulfs previous body by ≥10%
    final prevBody     = (prev.close - prev.open).abs();
    if (prevBody <= 0) return '';
    final currHigh     = math.max(curr.open, curr.close);
    final currLow      = math.min(curr.open, curr.close);
    final prevHigh     = math.max(prev.open, prev.close);
    final prevLow      = math.min(prev.open, prev.close);

    if (curr.isBullish && !prev.isBullish &&
        currHigh > prevHigh && currLow < prevLow && body >= prevBody * 1.1) {
      return 'BullishEngulfing';
    }
    if (!curr.isBullish && prev.isBullish &&
        currHigh > prevHigh && currLow < prevLow && body >= prevBody * 1.1) {
      return 'BearishEngulfing';
    }
    return '';
  }

  // ── ATR(14) ────────────────────────────────────────────────────────────────

  static double _calculateAtr(List<Candle> candles, {int period = 14}) {
    if (candles.length < period + 1) return 0.0;
    final slice = candles.sublist(candles.length - period - 1);
    double sum = 0;
    for (int i = 1; i <= period; i++) {
      final c  = slice[i];
      final pc = slice[i - 1].close;
      sum += math.max(c.high - c.low,
             math.max((c.high - pc).abs(), (c.low - pc).abs()));
    }
    return sum / period;
  }

  // ── Dynamic accuracy 0-100% ────────────────────────────────────────────────
  // All 6 factors perfectly aligned → 100%.

  static double _dynamicAccuracy({
    required SignalType signal,
    required double rsi,
    required bool hasMacd,
    required double macdHisto,
    required double macdValue,
    required double macdSignalLine,
    required String htfLabel,
    required ZoneType zone,
    required _SessionInfo session,
    required String pattern,
    required Asset asset,
    required double atr,
  }) {
    if (signal == SignalType.wait) return 50.0;
    final buy = signal == SignalType.buy;
    double pts = 0.0;

    // RSI — max 20
    if (buy) {
      if (rsi < 32)              pts += 20;
      else if (rsi < 38)         pts += 14;
      else if (rsi > 52 && rsi < 62) pts += 8;
      else if (rsi > 38 && rsi < 52) pts += 4;
      else                       pts += 1;
    } else {
      if (rsi > 68)              pts += 20;
      else if (rsi > 62)         pts += 14;
      else if (rsi > 38 && rsi < 48) pts += 8;
      else if (rsi > 48 && rsi < 62) pts += 4;
      else                       pts += 1;
    }

    // MACD — max 15
    if (hasMacd) {
      final bullish = macdHisto > 0 && macdValue > macdSignalLine;
      final bearish = macdHisto < 0 && macdValue < macdSignalLine;
      if (buy)  { pts += bullish ? 15 : bearish ? 2 : 6; }
      else      { pts += bearish ? 15 : bullish ? 2 : 6; }
    } else {
      pts += 5;
    }

    // HTF — max 20
    if (buy) {
      if (htfLabel == 'Bullish')  pts += 20;
      else if (htfLabel == 'Sideways') pts += 8;
      else                         pts += 0;
    } else {
      if (htfLabel == 'Bearish')  pts += 20;
      else if (htfLabel == 'Sideways') pts += 8;
      else                         pts += 0;
    }

    // Zone — max 20
    if (buy) {
      switch (zone) {
        case ZoneType.strongDemand: pts += 20;
        case ZoneType.weakDemand:   pts += 12;
        case ZoneType.neutral:      pts += 6;
        case ZoneType.weakSupply:   pts += 2;
        case ZoneType.strongSupply: pts += 0;
      }
    } else {
      switch (zone) {
        case ZoneType.strongSupply: pts += 20;
        case ZoneType.weakSupply:   pts += 12;
        case ZoneType.neutral:      pts += 6;
        case ZoneType.weakDemand:   pts += 2;
        case ZoneType.strongDemand: pts += 0;
      }
    }

    // Session — max 15
    pts += (session.quality * 15).clamp(0, 15);

    // Pattern — max 10
    final patBull = pattern == 'BullishPinBar' || pattern == 'BullishEngulfing';
    final patBear = pattern == 'BearishPinBar' || pattern == 'BearishEngulfing';
    if (buy)  { pts += patBull ? 10 : patBear ? 0 : 3; }
    else      { pts += patBear ? 10 : patBull ? 0 : 3; }

    // ATR micro-bonus (max +3, min -3)
    if (atr > 0) {
      final atrPips = atr / asset.pipValue;
      if (atrPips > 15) pts += 3;
      else if (atrPips < 4) pts -= 3;
    }

    return pts.clamp(0.0, 100.0);
  }

  // ── Analysis summary builder ───────────────────────────────────────────────

  static String _makeSummary({
    required SignalType signal,
    required double accuracy,
    required double rsi,
    required double macdHisto,
    required String htfLabel,
    required ZoneType zone,
    required String sessionName,
    required String sessionWarning,
    required String pattern,
    required AppStrings s,
  }) {
    final acc = accuracy.toStringAsFixed(0);
    if (signal == SignalType.wait) {
      return s.t(
        ar: 'لا توجد إشارة واضحة حالياً. السوق يفتقر إلى توافق كافٍ بين المؤشرات. انتظر تأكيداً أقوى قبل الدخول.',
        en: 'No clear signal at this time. The market lacks sufficient indicator confluence. Wait for stronger confirmation before entering.',
        tr: 'Şu an net bir sinyal yok. Piyasa yeterli gösterge uyumu sağlamıyor. Giriş yapmadan önce daha güçlü onay bekleyin.',
      );
    }

    final dir = s.t(
      ar: signal == SignalType.buy ? 'شراء' : 'بيع',
      en: signal == SignalType.buy ? 'BUY' : 'SELL',
      tr: signal == SignalType.buy ? 'AL'  : 'SAT',
    );
    final strength = accuracy >= 80
        ? s.t(ar: 'قوية', en: 'strong', tr: 'güçlü')
        : accuracy >= 65
            ? s.t(ar: 'متوسطة', en: 'moderate', tr: 'orta')
            : s.t(ar: 'ضعيفة', en: 'weak', tr: 'zayıf');

    final isBuy = signal == SignalType.buy;
    final rsiPart = (isBuy ? rsi < 38 : rsi > 62)
        ? s.t(ar: 'RSI في منطقة الانعكاس', en: 'RSI in reversal zone', tr: 'RSI dönüş bölgesinde')
        : s.t(ar: 'RSI في منطقة الزخم', en: 'RSI in momentum zone', tr: 'RSI momentum bölgesinde');

    final htfPart = htfLabel == 'Sideways'
        ? s.t(ar: 'H1 جانبي', en: 'H1 ranging', tr: 'H1 yatay')
        : s.t(
            ar: 'H1 ${htfLabel == "Bullish" ? "صاعد" : "هابط"}',
            en: 'H1 $htfLabel',
            tr: 'H1 ${htfLabel == "Bullish" ? "yükseliş" : "düşüş"}',
          );

    final zonePart = switch (zone) {
      ZoneType.strongDemand => s.t(ar: 'منطقة طلب قوية', en: 'strong demand zone', tr: 'güçlü talep bölgesi'),
      ZoneType.weakDemand   => s.t(ar: 'منطقة طلب', en: 'demand zone', tr: 'talep bölgesi'),
      ZoneType.strongSupply => s.t(ar: 'منطقة عرض قوية', en: 'strong supply zone', tr: 'güçlü arz bölgesi'),
      ZoneType.weakSupply   => s.t(ar: 'منطقة عرض', en: 'supply zone', tr: 'arz bölgesi'),
      ZoneType.neutral      => s.t(ar: 'منطقة محايدة', en: 'neutral zone', tr: 'tarafsız bölge'),
    };

    var line1 = s.t(
      ar: 'إشارة $dir $strength ($acc٪) — $rsiPart، $htfPart، $zonePart.',
      en: '$strength $dir signal ($acc%) — $rsiPart, $htfPart, $zonePart.',
      tr: '$strength $dir sinyali ($acc%) — $rsiPart, $htfPart, $zonePart.',
    );

    var line2 = '';
    if (pattern.isNotEmpty) {
      final pName = s.patternName(pattern);
      final confirms = (isBuy && (pattern == 'BullishPinBar' || pattern == 'BullishEngulfing')) ||
                       (!isBuy && (pattern == 'BearishPinBar' || pattern == 'BearishEngulfing'));
      line2 = confirms
          ? s.t(ar: ' نمط $pName يؤكد الإشارة.', en: ' $pName confirms the signal.', tr: ' $pName sinyali doğruluyor.')
          : s.t(ar: ' نمط $pName يخالف الإشارة — توخّ الحذر.', en: ' $pName conflicts with the signal — be cautious.', tr: ' $pName sinyal ile çelişiyor — dikkatli olun.');
    }

    final line3 = sessionWarning.isNotEmpty
        ? s.t(ar: ' ⚠️ $sessionWarning.', en: ' ⚠️ $sessionWarning.', tr: ' ⚠️ $sessionWarning.')
        : s.t(
            ar: ' جلسة $sessionName — سيولة جيدة، ظروف مثالية للدخول.',
            en: ' $sessionName session — good liquidity, favourable entry conditions.',
            tr: ' $sessionName seansı — iyi likidite, giriş için uygun koşullar.',
          );

    return '$line1$line2$line3';
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  static Future<AnalysisResult> analyze({
    required Asset asset,
    required Timeframe timeframe,
    String lang = 'en',
    double? livePrice,
  }) async {
    final s = AppStrings.of(lang);

    // Market closed check
    if (_isMarketClosed()) return _buildMarketClosedResult(asset, s: s);

    // News freeze check
    final newsFrozen = await NewsCalendarService.checkEconomicCalendarNews(
      tradeTime: DateTime.now(),
      symbol: asset.symbol,
    );
    if (newsFrozen) return _buildWaitResult(asset, s: s);

    await Future.delayed(const Duration(milliseconds: 1200));

    return await _computeSignal(asset, timeframe, s, livePrice);
  }

  // ── Core Signal Engine ─────────────────────────────────────────────────────

  static Future<AnalysisResult> _computeSignal(Asset asset, Timeframe timeframe, AppStrings s, double? livePrice) async {
    // ── Fetch real indicators from Twelvedata ──────────────────────────────
    final realData = await _fetchRealIndicators(asset, timeframe);

    // If API failed, return data error — no random fallback
    if (realData == null) return _buildDataErrorResult(asset, s: s);

    // RSI — real only
    final rsi = (realData['rsi'] as num).toDouble().clamp(0.0, 100.0);

    // MACD — real only; if all zeros the API had no data
    final macdValue  = (realData['macd_value']     as num).toDouble();
    final macdSignal = (realData['macd_signal']    as num).toDouble();
    final macdHisto  = (realData['macd_histogram'] as num).toDouble();
    final hasMacd    = macdValue != 0.0 || macdSignal != 0.0 || macdHisto != 0.0;

    // Higher timeframe trend from EMA50 on H1 — real only
    final htfBias = switch (realData['htf_trend'] as String? ?? 'Sideways') {
      'Bullish' => 0.5,
      'Bearish' => -0.5,
      _         => 0.0,
    };

    // ── Session detection (warning only, never stops analysis) ────────────
    final session = _sessionInfo(s);

    // ── Confluence scoring ─────────────────────────────────────────────────
    // Score >0 = bullish pressure, <0 = bearish pressure
    double score = 0;
    final List<String> factors = [];

    final rsiStr = rsi.toStringAsFixed(1);
    // RSI
    if (rsi < 32) {
      score += 2.0;
      factors.add(s.rsiOversold(rsiStr));
    } else if (rsi > 68) {
      score -= 2.0;
      factors.add(s.rsiOverbought(rsiStr));
    } else if (rsi > 52 && rsi < 62) {
      score += 0.8;
      factors.add(s.rsiBullMomentum(rsiStr));
    } else if (rsi > 38 && rsi < 48) {
      score -= 0.8;
      factors.add(s.rsiBearPressure(rsiStr));
    } else {
      factors.add(s.rsiNeutral(rsiStr));
    }

    // MACD — only score if data is valid
    if (hasMacd) {
      if (macdHisto > 0 && macdValue > macdSignal) {
        score += 1.5;
        factors.add(s.macdBullish);
      } else if (macdHisto < 0 && macdValue < macdSignal) {
        score -= 1.5;
        factors.add(s.macdBearish);
      } else {
        factors.add(s.macdDiverging);
      }
    }

    // Supply/Demand Zone — real pivot detection only
    final zone = switch (realData['sd_zone'] as String? ?? 'neutral') {
      'strongDemand' => ZoneType.strongDemand,
      'weakDemand'   => ZoneType.weakDemand,
      'weakSupply'   => ZoneType.weakSupply,
      'strongSupply' => ZoneType.strongSupply,
      _              => ZoneType.neutral,
    };
    switch (zone) {
      case ZoneType.strongDemand: score += 2.5; factors.add(s.sdStrongDemand);
      case ZoneType.weakDemand:   score += 1.0; factors.add(s.sdWeakDemand);
      case ZoneType.neutral:                    factors.add(s.sdNeutral);
      case ZoneType.weakSupply:   score -= 1.0; factors.add(s.sdWeakSupply);
      case ZoneType.strongSupply: score -= 2.5; factors.add(s.sdStrongSupply);
    }

    // Higher timeframe trend filter
    String htfLabel;
    if (htfBias > 0.3) {
      score += 1.5;
      htfLabel = 'Bullish';
      factors.add(s.htfBullish);
    } else if (htfBias < -0.3) {
      score -= 1.5;
      htfLabel = 'Bearish';
      factors.add(s.htfBearish);
    } else {
      htfLabel = 'Sideways';
      factors.add(s.htfRanging);
    }

    // ── Determine signal ───────────────────────────────────────────────────
    SignalType signal;
    if (score >= 3.5) {
      signal = SignalType.buy;
    } else if (score <= -3.5) {
      signal = SignalType.sell;
    } else {
      signal = SignalType.wait;
    }

    // ── Price levels ───────────────────────────────────────────────────────
    final spread    = asset.pipValue * 2;
    final slPips    = _slPips(asset, timeframe);
    final tpPips    = slPips * 2.0; // fixed 1:2 RRR
    // Use last real candle close as entry — basePrice is stale
    final _rawCandles = realData['candles'] as List<dynamic>? ?? [];
    final _lastClose  = _rawCandles.isNotEmpty
        ? ((_rawCandles.last as Map<String, dynamic>)['c'] as num).toDouble()
        : null;
    final entry = livePrice ?? _lastClose ?? asset.basePrice;
    double sl, tp;

    if (signal == SignalType.buy) {
      sl = entry - slPips + spread;
      tp = entry + tpPips;
    } else if (signal == SignalType.sell) {
      sl = entry + slPips;
      tp = entry - tpPips + spread;
    } else {
      sl = entry - slPips;
      tp = entry + tpPips;
    }

    final rrr = (tp - entry).abs() / (entry - sl).abs();

    // ── Parse candle data ──────────────────────────────────────────────────
    final candlesRaw = realData['candles'] as List<dynamic>? ?? [];
    final candles = candlesRaw.map((c) {
      final m = c as Map<String, dynamic>;
      return Candle(
        open:  (m['o'] as num).toDouble(),
        high:  (m['h'] as num).toDouble(),
        low:   (m['l'] as num).toDouble(),
        close: (m['c'] as num).toDouble(),
      );
    }).toList();
    final pivotHighs = (realData['pivot_highs'] as List<dynamic>? ?? [])
        .map((v) => (v as num).toDouble()).toList();
    final pivotLows = (realData['pivot_lows'] as List<dynamic>? ?? [])
        .map((v) => (v as num).toDouble()).toList();

    // ── Candlestick pattern + ATR ──────────────────────────────────────────
    final pattern = _detectPattern(candles);
    final atr     = _calculateAtr(candles);

    // Add session warning to factors (if applicable) — already in user's language
    if (session.warning.isNotEmpty) {
      factors.add('⚠️ ${session.warning}');
    }

    // Add pattern factor
    if (pattern.isNotEmpty && signal != SignalType.wait) {
      final pf = s.patternFactor(pattern, signal);
      if (pf.isNotEmpty) factors.add(pf);
    }

    // Add ATR factor
    final atrStr = s.atrFactor(atr, asset.pipValue);
    if (atrStr.isNotEmpty) factors.add(atrStr);

    // ── Dynamic accuracy (0-100%) ──────────────────────────────────────────
    final accuracy = _dynamicAccuracy(
      signal: signal,
      rsi: rsi,
      hasMacd: hasMacd,
      macdHisto: macdHisto,
      macdValue: macdValue,
      macdSignalLine: macdSignal,
      htfLabel: htfLabel,
      zone: zone,
      session: session,
      pattern: pattern,
      asset: asset,
      atr: atr,
    );

    // ── Build summary (عصارة التحليل) ─────────────────────────────────────
    final summary = _makeSummary(
      signal: signal,
      accuracy: accuracy,
      rsi: rsi,
      macdHisto: macdHisto,
      htfLabel: htfLabel,
      zone: zone,
      sessionName: session.name,
      sessionWarning: session.warning,
      pattern: pattern,
      s: s,
    );

    // ── AI narratives ──────────────────────────────────────────────────────
    final sentiment = _buildSentiment(signal, asset, htfLabel, score, s);
    final claudeBox = await _buildClaudeOpinion(
      asset: asset,
      score: score,
      rsi: rsi,
      macdHisto: macdHisto,
      htfLabel: htfLabel,
      zone: zone,
      session: session,
      s: s,
    );

    return AnalysisResult(
      signal: signal,
      accuracy: accuracy,
      entryPoint: _roundPrice(entry, asset),
      stopLoss: _roundPrice(sl, asset),
      takeProfit: _roundPrice(tp, asset),
      riskRewardRatio: double.parse(rrr.toStringAsFixed(2)),
      rsi: double.parse(rsi.toStringAsFixed(1)),
      macdValue: macdValue,
      macdSignalLine: macdSignal,
      macdHistogram: macdHisto,
      zone: zone,
      confluenceFactors: factors,
      aiSentiment: sentiment,
      claudeOpinion: claudeBox,
      higherTfTrend: htfLabel,
      analysisTimestamp: _timestamp(),
      candles: candles,
      pivotHighs: pivotHighs,
      pivotLows: pivotLows,
      sessionName: session.name,
      sessionWarning: session.warning,
      summary: summary,
      candlePattern: pattern,
      atrValue: atr,
    );
  }

  // ── Helper builders ────────────────────────────────────────────────────────

  static AnalysisResult _buildMarketClosedResult(Asset asset, {required AppStrings s}) {
    return AnalysisResult(
      signal: SignalType.wait,
      accuracy: 0.0,
      entryPoint: asset.basePrice,
      stopLoss: asset.basePrice,
      takeProfit: asset.basePrice,
      riskRewardRatio: 0.0,
      rsi: 0.0,
      macdValue: 0,
      macdSignalLine: 0,
      macdHistogram: 0,
      zone: ZoneType.neutral,
      confluenceFactors: [s.marketClosedSignal],
      aiSentiment: s.marketClosedSentiment,
      claudeOpinion: s.marketClosedOpinion,
      higherTfTrend: 'Sideways',
      analysisTimestamp: _timestamp(),
    );
  }

  static AnalysisResult _buildDataErrorResult(Asset asset, {required AppStrings s}) {
    return AnalysisResult(
      signal: SignalType.wait,
      accuracy: 0.0,
      entryPoint: asset.basePrice,
      stopLoss: asset.basePrice,
      takeProfit: asset.basePrice,
      riskRewardRatio: 0.0,
      rsi: 0.0,
      macdValue: 0,
      macdSignalLine: 0,
      macdHistogram: 0,
      zone: ZoneType.neutral,
      confluenceFactors: [s.dataErrorSignal],
      aiSentiment: s.marketAmbiguous,
      claudeOpinion: s.dataErrorOpinion,
      higherTfTrend: 'Sideways',
      analysisTimestamp: _timestamp(),
    );
  }

  static AnalysisResult _buildWaitResult(Asset asset, {required AppStrings s}) {
    return AnalysisResult(
      signal: SignalType.wait,
      accuracy: 50.0,
      entryPoint: asset.basePrice,
      stopLoss: asset.basePrice - asset.pipValue * 20,
      takeProfit: asset.basePrice + asset.pipValue * 40,
      riskRewardRatio: 2.0,
      rsi: 50.0,
      macdValue: 0,
      macdSignalLine: 0,
      macdHistogram: 0,
      zone: ZoneType.neutral,
      confluenceFactors: [s.newsFreezeWait],
      aiSentiment: s.marketAmbiguous,
      claudeOpinion: s.claudeOpinion(asset.symbol, '0.00'),
      higherTfTrend: 'Sideways',
      analysisTimestamp: _timestamp(),
    );
  }

  static String _buildSentiment(SignalType sig, Asset asset, String htf, double score, AppStrings s) {
    if (sig == SignalType.buy) {
      return s.aiSentimentBuy(asset.symbol, s.htfTrendLabel(htf), score.toStringAsFixed(1));
    } else if (sig == SignalType.sell) {
      return s.aiSentimentSell(asset.symbol, s.htfTrendLabel(htf), score.abs().toStringAsFixed(1));
    } else {
      return s.aiSentimentWait(asset.symbol);
    }
  }

  static Future<Map<String, dynamic>?> _fetchRealIndicators(Asset asset, Timeframe tf) async {
    const url = 'https://forex-bridge.onrender.com/indicators';
    final interval = switch (tf) {
      Timeframe.m5  => '5min',
      Timeframe.m15 => '15min',
      Timeframe.m30 => '30min',
    };
    final body = json.encode({'symbol': asset.symbol, 'interval': interval});

    // Try up to 3 times — first attempt wakes Render.com if sleeping
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        final res = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: body,
        ).timeout(const Duration(seconds: 65));
        if (res.statusCode == 200) {
          return json.decode(res.body) as Map<String, dynamic>;
        }
        // Non-200: service waking up — wait then retry
        if (attempt < 2) await Future.delayed(const Duration(seconds: 30));
      } catch (_) {
        if (attempt < 2) await Future.delayed(const Duration(seconds: 10));
      }
    }
    return null;
  }

  static Future<String> _buildClaudeOpinion({
    required Asset asset,
    required double score,
    required double rsi,
    required double macdHisto,
    required String htfLabel,
    required ZoneType zone,
    required _SessionInfo session,
    required AppStrings s,
  }) async {
    try {
      const url = 'https://aixpkthloeafwakiijws.supabase.co/functions/v1/ai-analysis';
      const anonKey = 'sb_publishable_Jm9xmIjg1MHhajBFxAxSkw_6aluy7Sa';
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $anonKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'symbol': asset.symbol,
          'rsi': rsi.toStringAsFixed(1),
          'macd': macdHisto > 0 ? 'Bullish crossover' : macdHisto < 0 ? 'Bearish crossover' : 'Diverging',
          'htf': htfLabel,
          'zone': zone.name,
          'score': score.toStringAsFixed(1),
          'session': session.name,
          'sessionQuality': session.quality.toStringAsFixed(2),
          'sessionWarning': session.warning,
          'lang': s.lang,
        }),
      ).timeout(const Duration(seconds: 12));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['analysis'] ?? s.claudeOpinion(asset.symbol, score.toStringAsFixed(2));
      }
    } catch (_) {}
    return s.claudeOpinion(asset.symbol, score.toStringAsFixed(2));
  }

  // ── Utilities ──────────────────────────────────────────────────────────────

  static double _slPips(Asset asset, Timeframe tf) {
    final base = switch (tf) {
      Timeframe.m5  => 8,
      Timeframe.m15 => 15,
      Timeframe.m30 => 22,
    };
    return asset.pipValue * base;
  }

  static double _roundPrice(double price, Asset asset) {
    final decimals = asset.pipValue < 0.01 ? 5 : (asset.pipValue < 0.1 ? 3 : 2);
    final factor = math.pow(10, decimals).toDouble();
    return (price * factor).round() / factor;
  }

  static String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')} UTC';
  }
}
