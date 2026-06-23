import '../../../features/dashboard/models/analysis_result.dart';
import '../../../features/dashboard/models/asset_model.dart';

/// All UI text for AR / EN / TR.
/// Technical symbols (RSI, MACD, MT5, EUR/USD …) are kept in English in every language.
class AppStrings {
  final String lang;
  const AppStrings._(this.lang);

  static const AppStrings ar = AppStrings._('ar');
  static const AppStrings en = AppStrings._('en');
  static const AppStrings tr = AppStrings._('tr');

  static AppStrings of(String code) {
    switch (code) {
      case 'ar': return ar;
      case 'tr': return tr;
      default:   return en;
    }
  }

  bool get isRtl => lang == 'ar';

  T _t<T>({required T ar, required T en, required T tr}) {
    switch (lang) {
      case 'ar': return ar;
      case 'tr': return tr;
      default:   return en;
    }
  }

  /// Public accessor so other services can do trilingual string selection.
  String t({required String ar, required String en, required String tr}) =>
      _t(ar: ar, en: en, tr: tr);

  // ── Navigation ──────────────────────────────────────────────────────────────
  String get markets     => _t(ar: 'الأسواق',     en: 'Markets',    tr: 'Piyasalar');
  String get platforms   => _t(ar: 'المنصات',     en: 'Platforms',  tr: 'Platformlar');
  String get education   => _t(ar: 'التعليم',     en: 'Education',  tr: 'Eğitim');
  String get about       => _t(ar: 'عن الأداة',   en: 'About',      tr: 'Hakkında');
  String get contact     => _t(ar: 'تواصل معنا',  en: 'Contact',    tr: 'İletişim');
  String get login       => _t(ar: 'الدخول',      en: 'Log In',     tr: 'Giriş');
  String get openAccount => _t(ar: 'فتح حساب',    en: 'Open Account', tr: 'Hesap Aç');

  // ── Hero ────────────────────────────────────────────────────────────────────
  String get aiBadge => _t(
    ar: 'مدعوم بالذكاء الاصطناعي · AI-Powered Scalping',
    en: 'Powered by Artificial Intelligence · AI-Powered Scalping',
    tr: 'Yapay Zeka Destekli · AI-Powered Scalping',
  );
  String get heroHeadline => _t(
    ar: 'ابدأ التداول اليوم مع\nأدوات تحليل الذكاء الاصطناعي',
    en: 'Start Trading Today\nwith AI Analysis Tools',
    tr: 'Bugün Ticarete Başlayın\nYapay Zeka Analiz Araçlarıyla',
  );
  String get heroSubtitle => _t(
    ar: 'احصل على إشارات تداول احترافية مدعومة بالذكاء الاصطناعي\nوتحليل متعدد الأطر الزمنية ومناطق العرض والطلب',
    en: 'Get professional trading signals powered by AI\nwith multi-timeframe analysis and supply & demand zones',
    tr: 'AI destekli profesyonel ticaret sinyalleri alın\nçoklu zaman dilimi analizi ve arz-talep bölgeleriyle',
  );
  String get ctaStart => _t(ar: 'ابدأ التداول الآن', en: 'Start Trading Now', tr: 'Ticarete Başla');
  String get ctaTry   => _t(ar: 'جرّب الأداة مجاناً', en: 'Try for Free',       tr: 'Ücretsiz Dene');

  // ── Hero Stats ──────────────────────────────────────────────────────────────
  String get statAssets     => _t(ar: 'أصل مالي متاح',  en: 'Assets Available',   tr: 'Mevcut Varlık');
  String get statAccuracy   => _t(ar: 'دقة الإشارات',   en: 'Signal Accuracy',     tr: 'Sinyal Doğruluğu');
  String get statTimeframes => _t(ar: 'أطر زمنية',      en: 'Timeframes',          tr: 'Zaman Dilimleri');
  String get statMt5Ready   => _t(ar: 'جاهز للربط',     en: 'Ready to Connect',    tr: 'Bağlamaya Hazır');

  // ── Header / Dashboard ──────────────────────────────────────────────────────
  String get mt5Connected => _t(ar: 'MT5 بريدج: متصل',     en: 'MT5 Bridge: Connected', tr: 'MT5 Bridge: Bağlı');
  String get mt5Offline   => _t(ar: 'MT5 بريدج: غير متصل', en: 'MT5 Bridge: Offline',   tr: 'MT5 Bridge: Çevrimdışı');
  String get timeframeLabel => _t(ar: 'الإطار:',           en: 'Timeframe:',            tr: 'Zaman Dilimi:');
  String get backHome     => _t(ar: 'الرئيسية',            en: 'Home',                  tr: 'Ana Sayfa');

  // ── Technical Gauges ────────────────────────────────────────────────────────
  String get technicalGauges    => _t(ar: 'المؤشرات الفنية',        en: 'TECHNICAL GAUGES',           tr: 'TEKNİK GÖSTERGELER');
  String get relativeStrength   => _t(ar: 'مؤشر القوة النسبية',     en: 'Relative Strength Index',    tr: 'Göreceli Güç Endeksi');
  String get signalLineCross    => _t(ar: 'تقاطع خط الإشارة',       en: 'Signal line crossover',      tr: 'Sinyal çizgisi kesişimi');
  String get institutionalZone  => _t(ar: 'منطقة مؤسسية',           en: 'Institutional zone detection', tr: 'Kurumsal bölge tespiti');
  String get macroTrendAlign    => _t(ar: 'التوجه الكلي',            en: 'Macro trend alignment',      tr: 'Makro trend hizalaması');
  String get supplyDemand       => _t(ar: 'العرض / الطلب',          en: 'Supply / Demand',            tr: 'Arz / Talep');
  String get higherTfFilter     => _t(ar: 'فلتر الإطار الأعلى (H1)', en: 'Higher TF Filter (H1)',    tr: 'Yüksek TF Filtresi (H1)');
  String get overbought         => _t(ar: 'تشبع شراء',              en: 'Overbought',                 tr: 'Aşırı Alım');
  String get neutral            => _t(ar: 'محايد',                  en: 'Neutral',                    tr: 'Nötr');
  String get oversold           => _t(ar: 'تشبع بيع',               en: 'Oversold',                   tr: 'Aşırı Satım');

  // ── MACD ────────────────────────────────────────────────────────────────────
  String get histogram        => _t(ar: 'المدرج',            en: 'Histogram',                           tr: 'Histogram');
  String get signalChip       => _t(ar: 'الإشارة',           en: 'Signal',                              tr: 'Sinyal');
  String get bullishCrossover => _t(ar: 'تقاطع صاعد — زخم تصاعدي', en: 'Bullish crossover — upward momentum', tr: 'Yükseliş kesişimi — yukarı momentum');
  String get bearishCrossover => _t(ar: 'تقاطع هابط — ضغط بيعي',   en: 'Bearish crossover — downward pressure', tr: 'Düşüş kesişimi — aşağı baskı');

  // ── Empty states ────────────────────────────────────────────────────────────
  String get runToLoadMacd    => _t(ar: 'شغّل التحليل لتحميل MACD',         en: 'Run analysis to load MACD',         tr: 'MACD yüklemek için analizi çalıştırın');
  String get runToDetectZones => _t(ar: 'شغّل التحليل لاكتشاف المناطق',      en: 'Run analysis to detect zones',      tr: 'Bölgeleri tespit etmek için analizi çalıştırın');
  String get runToLoadHtf     => _t(ar: 'شغّل التحليل لتحميل التوجه',        en: 'Run analysis to load HTF bias',     tr: 'HTF eğilimi yüklemek için analizi çalıştırın');

  // ── Zone labels ─────────────────────────────────────────────────────────────
  String zoneLabel(ZoneType z) {
    switch (z) {
      case ZoneType.strongDemand: return _t(ar: 'منطقة طلب قوية',   en: 'Strong Demand Zone',  tr: 'Güçlü Talep Bölgesi');
      case ZoneType.weakDemand:   return _t(ar: 'منطقة طلب ضعيفة',  en: 'Weak Demand Zone',    tr: 'Zayıf Talep Bölgesi');
      case ZoneType.neutral:      return _t(ar: 'منطقة محايدة',      en: 'Neutral Territory',   tr: 'Tarafsız Bölge');
      case ZoneType.weakSupply:   return _t(ar: 'منطقة عرض ضعيفة',  en: 'Weak Supply Zone',    tr: 'Zayıf Arz Bölgesi');
      case ZoneType.strongSupply: return _t(ar: 'منطقة عرض قوية',   en: 'Strong Supply Zone',  tr: 'Güçlü Arz Bölgesi');
    }
  }

  String zoneDesc(ZoneType z) {
    switch (z) {
      case ZoneType.strongDemand: return _t(
        ar: 'منطقة طلب جديدة غير مختبرة — احتمال عالٍ لرد فعل صعودي قوي',
        en: 'Fresh, untested demand zone — high probability of strong bullish reaction',
        tr: 'Taze, test edilmemiş talep bölgesi — güçlü yükseliş reaksiyonu olasılığı yüksek',
      );
      case ZoneType.weakDemand: return _t(
        ar: 'منطقة طلب تم اختبارها جزئياً — لا يزال هناك بعض اهتمام بالشراء',
        en: 'Partially tested demand zone — some buying interest remains',
        tr: 'Kısmen test edilmiş talep bölgesi — biraz alım ilgisi kalmış',
      );
      case ZoneType.neutral: return _t(
        ar: 'لا يوجد هيكل عرض أو طلب مهم عند السعر الحالي',
        en: 'No significant supply or demand structure detected at current price',
        tr: 'Mevcut fiyatta önemli bir arz veya talep yapısı tespit edilmedi',
      );
      case ZoneType.weakSupply: return _t(
        ar: 'منطقة عرض تم اختبارها جزئياً — ضغط بيعي خفيف فوق السعر',
        en: 'Partially tested supply zone — light selling pressure above',
        tr: 'Kısmen test edilmiş arz bölgesi — yukarıda hafif satış baskısı',
      );
      case ZoneType.strongSupply: return _t(
        ar: 'منطقة عرض جديدة غير مختبرة — احتمال عالٍ لرفض هبوطي حاد',
        en: 'Fresh, untested supply zone — high probability of sharp bearish rejection',
        tr: 'Taze, test edilmemiş arz bölgesi — sert düşüş reddi olasılığı yüksek',
      );
    }
  }

  // ── HTF Trend ───────────────────────────────────────────────────────────────
  String htfTrendLabel(String trend) {
    if (trend == 'Bullish') return _t(ar: 'صاعد',  en: 'Bullish',  tr: 'Yükseliş');
    if (trend == 'Bearish') return _t(ar: 'هابط',  en: 'Bearish',  tr: 'Düşüş');
    return _t(ar: 'جانبي', en: 'Sideways', tr: 'Yatay');
  }

  String htfSubLabel(String trend) {
    if (trend == 'Bullish') return _t(ar: 'الصفقات الشرائية متوافقة مع الاتجاه ✓', en: 'Short-TF longs are trend-aligned ✓', tr: 'Kısa-TF longlar trend ile hizalı ✓');
    if (trend == 'Bearish') return _t(ar: 'الصفقات البيعية متوافقة مع الاتجاه ✓',  en: 'Short-TF shorts are trend-aligned ✓', tr: 'Kısa-TF shortlar trend ile hizalı ✓');
    return _t(ar: 'تداول فقط من مستويات العرض/الطلب المتطرفة', en: 'Trade only from key S/D extremes', tr: 'Yalnızca anahtar A/T uçlarından işlem yapın');
  }

  // ── AI Execution Chamber ────────────────────────────────────────────────────
  String get aiChamberTitle   => _t(ar: 'غرفة تنفيذ الذكاء الاصطناعي', en: 'AI EXECUTION CHAMBER',           tr: 'YAPAY ZEKA YÜRÜTME ODASI');
  String get analyzeNowBtn    => _t(ar: 'حلل الآن  ·  Analyze Now',      en: 'Analyze Now  ·  حلل الآن',      tr: 'Şimdi Analiz Et  ·  Analyze Now');
  String get clearBtn         => _t(ar: 'مسح',                            en: 'Clear',                          tr: 'Temizle');
  String get selectAssetHint  => _t(ar: 'اختر أصلاً وانقر',              en: 'Select an asset and click',      tr: 'Bir varlık seçin ve tıklayın');
  String get generateSignalHint => _t(ar: '"حلل الآن" لتوليد إشارة',    en: '"Analyze Now" to generate signal', tr: '"Şimdi Analiz Et" ile sinyal oluşturun');
  String get activeLabel      => _t(ar: 'نشط:',                           en: 'Active:',                        tr: 'Aktif:');
  String get analysingLabel   => _t(ar: 'يتم تحليل السوق...',            en: 'Analysing Market...',            tr: 'Piyasa Analiz Ediliyor...');

  List<String> get loadingSteps => _t(
    ar: [
      'جلب هيكل السعر...',
      'حساب RSI و MACD...',
      'مسح مناطق العرض والطلب...',
      'فحص توجه الإطار الأعلى...',
      'تشغيل محرك التقاطعات...',
      'توليد إشارة الذكاء الاصطناعي...',
    ],
    en: [
      'Fetching price structure...',
      'Computing RSI and MACD...',
      'Scanning supply & demand zones...',
      'Checking higher timeframe bias...',
      'Running confluence engine...',
      'Generating AI signal...',
    ],
    tr: [
      'Fiyat yapısı alınıyor...',
      'RSI ve MACD hesaplanıyor...',
      'Arz ve talep bölgeleri taranıyor...',
      'Yüksek zaman dilimi eğilimi kontrol ediliyor...',
      'Birleşme motoru çalıştırılıyor...',
      'Yapay zeka sinyali oluşturuluyor...',
    ],
  );

  // ── Result Card ─────────────────────────────────────────────────────────────
  String get accuracyLabel       => _t(ar: 'الدقة',                en: 'Accuracy',             tr: 'Doğruluk');
  String get tradeParameters     => _t(ar: 'معاملات التداول',      en: 'TRADE PARAMETERS',     tr: 'İŞLEM PARAMETRELERİ');
  String get entryLabel          => _t(ar: 'الدخول',               en: 'ENTRY',                tr: 'GİRİŞ');
  String get stopLossLabel       => _t(ar: 'وقف الخسارة',          en: 'STOP LOSS',            tr: 'ZARAR DURDURMA');
  String get takeProfitLabel     => _t(ar: 'جني الأرباح',          en: 'TAKE PROFIT',          tr: 'KAR AL');
  String get technicalConfluence => _t(ar: 'التقاطعات الفنية',     en: 'TECHNICAL CONFLUENCE', tr: 'TEKNİK UYUM');
  String get aiMarketSentiment   => _t(ar: 'تحليل الذكاء الاصطناعي', en: 'AI MARKET SENTIMENT', tr: 'YAPAY ZEKA PİYASA DUYARLILIĞI');
  String get claudeExpertLabel   => _t(ar: 'رأي كلود الخبير',      en: 'Financial Expert Opinion', tr: 'Finansal Uzman Görüşü');

  // ── Signal labels ───────────────────────────────────────────────────────────
  String signalLabel(SignalType s) {
    switch (s) {
      case SignalType.buy:  return _t(ar: 'شراء', en: 'BUY',  tr: 'AL');
      case SignalType.sell: return _t(ar: 'بيع',  en: 'SELL', tr: 'SAT');
      case SignalType.wait: return _t(ar: 'انتظر', en: 'WAIT', tr: 'BEKLE');
    }
  }

  // ── Sidebar categories ──────────────────────────────────────────────────────
  String categoryLabel(AssetCategory c) {
    switch (c) {
      case AssetCategory.forexMajor:  return _t(ar: 'الأزواج الرئيسية',   en: 'Major Pairs',         tr: 'Majör Pariteler');
      case AssetCategory.forexMinor:  return _t(ar: 'الأزواج الثانوية',   en: 'Cross / Minor Pairs', tr: 'Minör Pariteler');
      case AssetCategory.forexExotic: return _t(ar: 'الأزواج الغريبة',    en: 'Exotic Pairs',        tr: 'Egzotik Pariteler');
      case AssetCategory.metals:      return _t(ar: 'المعادن الثمينة',    en: 'Precious Metals',     tr: 'Kıymetli Madenler');
      case AssetCategory.energy:      return _t(ar: 'الطاقة والنفط',      en: 'Energies & Oil',      tr: 'Enerji & Petrol');
      case AssetCategory.commodities: return _t(ar: 'السلع الزراعية',     en: 'Agricultural',        tr: 'Tarımsal Ürünler');
    }
  }

  // ── Dashboard bottom bar ────────────────────────────────────────────────────
  String get advancedDashboard => _t(ar: 'لوحة تداول متقدمة',       en: 'Advanced Scalping Dashboard',       tr: 'Gelişmiş Scalping Panosu');
  String get confluenceEngine  => _t(ar: 'محرك تقاطع متعدد الأطر', en: 'Multi-Timeframe Confluence Engine', tr: 'Çoklu Zaman Dilimi Birleşme Motoru');

  // ── Features section ─────────────────────────────────────────────────────────
  String get featuresTag      => _t(ar: 'خدماتنا',                         en: 'Our Services',             tr: 'Hizmetlerimiz');
  String get featuresTitle    => _t(ar: 'كل ما تحتاجه للتداول الناجح',   en: 'Everything for Successful Trading', tr: 'Başarılı Ticaret İçin Her Şey');
  String get featuresSubtitle => _t(
    ar: 'أدوات متكاملة ودعم متخصص لمساعدتك على تحقيق أهدافك في الأسواق المالية',
    en: 'Complete tools and expert support to help you achieve your financial market goals',
    tr: 'Finansal piyasa hedeflerinize ulaşmanıza yardımcı olacak araçlar ve uzman destek',
  );
  String get feat1Title => _t(ar: 'منصة MetaTrader 5',         en: 'MetaTrader 5 Platform',     tr: 'MetaTrader 5 Platformu');
  String get feat1Desc  => _t(
    ar: 'تداول على أقوى منصات التداول في العالم مع أدوات تحليل فني متكاملة وتنفيذ فوري للأوامر',
    en: 'Trade on the world\'s most powerful platform with full technical analysis tools and instant order execution',
    tr: 'Tam teknik analiz araçları ve anlık emir icrası ile dünyanın en güçlü platformunda işlem yapın',
  );
  String get feat2Title => _t(ar: 'تحليل الذكاء الاصطناعي',  en: 'AI Analysis Engine',        tr: 'Yapay Zeka Analiz Motoru');
  String get feat2Desc  => _t(
    ar: 'احصل على إشارات دقيقة بنظام توافق متعدد الأطر الزمنية ومناطق العرض والطلب الذكية',
    en: 'Get accurate signals with multi-timeframe confluence engine and intelligent supply & demand zones',
    tr: 'Çoklu zaman dilimi birleşme motoru ve akıllı arz-talep bölgeleriyle doğru sinyaller alın',
  );
  String get feat2Cta   => _t(ar: 'جرب الأداة الآن', en: 'Try the Tool Now', tr: 'Şimdi Deneyin');
  String get feat3Title => _t(ar: 'دعم فني متخصص 24/5', en: '24/5 Expert Support',    tr: '24/5 Uzman Destek');
  String get feat3Desc  => _t(
    ar: 'فريق من المحللين الماليين المحترفين جاهز لمساعدتك طوال جلسات التداول العالمية',
    en: 'A team of professional financial analysts ready to assist you throughout global trading sessions',
    tr: 'Küresel ticaret seansları boyunca size yardımcı olmaya hazır profesyonel finansal analistler ekibi',
  );

  // ── Tool Showcase ───────────────────────────────────────────────────────────
  String get toolTag       => _t(ar: 'الأداة الرئيسية',       en: 'Main Tool',              tr: 'Ana Araç');
  String get toolTitle     => _t(ar: 'أداة التحليل الذكية\nمحرك الإشارات الاحترافي', en: 'Smart Analysis Tool\nProfessional Signal Engine', tr: 'Akıllı Analiz Aracı\nProfesyonel Sinyal Motoru');
  String get toolDesc      => _t(
    ar: 'لوحة تحكم تفاعلية متطورة تجمع بين RSI وMACD ومناطق العرض والطلب وفلتر الاتجاه العام لتوليد إشارات تداول دقيقة على أطر M5 وM15 وM30',
    en: 'An advanced interactive dashboard combining RSI, MACD, supply & demand zones and the macro trend filter to generate precise trading signals on M5, M15 and M30',
    tr: 'RSI, MACD, arz-talep bölgeleri ve makro trend filtresini birleştiren gelişmiş etkileşimli bir gösterge paneli, M5, M15 ve M30\'da kesin ticaret sinyalleri üretir',
  );
  String get toolLaunchBtn => _t(ar: '⚡  حلل الآن  ·  Analyze Now', en: '⚡  Analyze Now  ·  حلل الآن', tr: '⚡  Şimdi Analiz Et  ·  Analyze Now');

  // ── Why Us ──────────────────────────────────────────────────────────────────
  String get whyTag      => _t(ar: 'لماذا mohammed forex', en: 'Why mohammed forex',    tr: 'Neden mohammed forex');
  String get whyTitle    => _t(ar: 'الأداة التي يثق بها المحترفون', en: 'The Tool Professionals Trust', tr: 'Profesyonellerin Güvendiği Araç');
  String get whySubtitle => _t(
    ar: 'بُنيت بمعايير احترافية لتلبية متطلبات متداولي السكالبينج المحترفين',
    en: 'Built to professional standards to meet the demands of expert scalping traders',
    tr: 'Uzman scalping yatırımcılarının taleplerini karşılamak için profesyonel standartlarda inşa edildi',
  );
  String get why1Label   => _t(ar: 'أصل مالي',   en: 'Financial Assets',    tr: 'Finansal Varlık');
  String get why1Desc    => _t(ar: 'أزواج فوركس ومعادن وطاقة وسلع زراعية', en: 'Forex pairs, metals, energy and agricultural commodities', tr: 'Forex pariteler, metaller, enerji ve tarımsal emtialar');
  String get why2Label   => _t(ar: 'دقة الإشارات', en: 'Signal Accuracy',  tr: 'Sinyal Doğruluğu');
  String get why2Desc    => _t(ar: 'نظام توافق متعدد الأطر الزمنية',       en: 'Multi-timeframe confluence system',          tr: 'Çoklu zaman dilimi birleşme sistemi');
  String get why3Label   => _t(ar: 'أطر زمنية',  en: 'Timeframes',         tr: 'Zaman Dilimleri');
  String get why3Desc    => _t(ar: 'تحليل على M5 وM15 وM30 في آن واحد',   en: 'Simultaneous analysis on M5, M15 and M30',  tr: 'M5, M15 ve M30\'da eş zamanlı analiz');
  String get why4Label   => _t(ar: 'جاهز للربط', en: 'Ready to Connect',   tr: 'Bağlamaya Hazır');
  String get why4Desc    => _t(ar: 'بنية جاهزة للاتصال المباشر بسيرفر MT5', en: 'Pre-built architecture for direct MT5 bridge connection', tr: 'Doğrudan MT5 bağlantısı için hazır mimari');

  // ── News Section ─────────────────────────────────────────────────────────────
  String get newsTag      => _t(ar: 'آخر الأخبار',               en: 'Latest News',          tr: 'Son Haberler');
  String get newsTitle    => _t(ar: 'الأحداث الاقتصادية',        en: 'Economic Events',      tr: 'Ekonomik Olaylar');
  String get newsSubtitle => _t(ar: 'تابع أهم الأحداث المحركة للأسواق', en: 'Track key market-moving events', tr: 'Piyasayı harekete geçiren olayları takip edin');

  String get newsEvent1 => _t(ar: 'قرار الفائدة الأمريكية — الاحتياطي الفيدرالي', en: 'US Federal Reserve Interest Rate Decision', tr: 'ABD Federal Rezerv Faiz Kararı');
  String get newsEvent2 => _t(ar: 'EUR/USD — بيان السياسة النقدية للبنك المركزي الأوروبي', en: 'EUR/USD — ECB Monetary Policy Statement', tr: 'EUR/USD — ECB Para Politikası Açıklaması');
  String get newsEvent3 => _t(ar: 'إصدار الناتج المحلي الإجمالي البريطاني الشهري', en: 'UK GDP Monthly Release', tr: 'İngiltere GSYH Aylık Verisi');
  String get newsEvent4 => _t(ar: 'الرواتب غير الزراعية الأمريكية', en: 'US Non-Farm Payrolls', tr: 'ABD Tarım Dışı İstihdam');
  String get newsEvent5 => _t(ar: 'بيان بنك الاحتياطي الأسترالي — أسعار الفائدة', en: 'Australia RBA Rate Statement', tr: 'Avustralya RBA Faiz Açıklaması');
  String get newsEvent6 => _t(ar: 'تقرير مؤشر أسعار المستهلكين الكندي', en: 'Canada CPI Report', tr: 'Kanada TÜFE Raporu');

  String get newsFreezeTitle => _t(ar: 'حماية الأخبار',          en: 'News Freeze',          tr: 'Haber Dondurma');
  String get newsFreezeDesc  => _t(
    ar: 'تُجمّد الأداة إشارات السكالبينج تلقائياً قبل 15 دقيقة من الأخبار الاقتصادية عالية التأثير وبعدها بـ 15 دقيقة، لحماية حسابك من التقلبات العشوائية.',
    en: 'The tool automatically freezes scalping signals 15 minutes before and after high-impact economic events, protecting your account from random volatility.',
    tr: 'Araç, yüksek etkili ekonomik olaylardan 15 dakika önce ve sonra scalping sinyallerini otomatik olarak dondurarak hesabınızı rastgele oynaklıktan korur.',
  );
  String get highImpact   => _t(ar: 'تأثير عالٍ',               en: 'High Impact',          tr: 'Yüksek Etki');
  String get mediumImpact => _t(ar: 'تأثير متوسط',              en: 'Medium Impact',        tr: 'Orta Etki');

  // ── Footer ──────────────────────────────────────────────────────────────────
  String get footerTagline  => _t(ar: 'أداة التحليل الأكثر تقدماً في السوق العربي', en: 'The most advanced analysis tool on the market', tr: 'Piyasadaki en gelişmiş analiz aracı');
  String get footerRisk     => _t(ar: 'التداول ينطوي على مخاطر. لا تستثمر ما لا تستطيع تحمل خسارته.', en: 'Trading involves risk. Never invest more than you can afford to lose.', tr: 'Ticaret risk içerir. Kaybetmeyi göze alamayacağınız miktardan fazlasını yatırmayın.');
  String get footerCopyright => _t(ar: '© 2025 mohammed forex. جميع الحقوق محفوظة.', en: '© 2025 mohammed forex. All rights reserved.', tr: '© 2025 mohammed forex. Tüm hakları saklıdır.');

  String get footerCol1Title => _t(ar: 'الأسواق',     en: 'Markets',   tr: 'Piyasalar');
  String get footerCol2Title => _t(ar: 'الشركة',      en: 'Company',   tr: 'Şirket');
  String get footerCol3Title => _t(ar: 'الدعم',       en: 'Support',   tr: 'Destek');

  List<String> get footerCol1Items => _t(
    ar: ['الفوركس', 'المعادن', 'النفط والطاقة', 'السلع الزراعية'],
    en: ['Forex', 'Metals', 'Oil & Energy', 'Agricultural'],
    tr: ['Forex', 'Metaller', 'Petrol & Enerji', 'Tarımsal Ürünler'],
  );
  List<String> get footerCol2Items => _t(
    ar: ['عن الشركة', 'فريق العمل', 'الشركاء', 'المدونة'],
    en: ['About Us', 'Our Team', 'Partners', 'Blog'],
    tr: ['Hakkımızda', 'Ekibimiz', 'Ortaklar', 'Blog'],
  );
  List<String> get footerCol3Items => _t(
    ar: ['مركز المساعدة', 'تواصل معنا', 'الشروط والأحكام', 'سياسة الخصوصية'],
    en: ['Help Center', 'Contact Us', 'Terms & Conditions', 'Privacy Policy'],
    tr: ['Yardım Merkezi', 'Bize Ulaşın', 'Şartlar ve Koşullar', 'Gizlilik Politikası'],
  );

  // ── Analysis Service strings ─────────────────────────────────────────────────
  // RSI factors
  String rsiOversold(String rsiVal)   => _t(ar: 'RSI $rsiVal — تشبع بيع: منطقة انعكاس صاعد محتمل',      en: 'RSI $rsiVal — Oversold: high-probability reversal zone',               tr: 'RSI $rsiVal — Aşırı Satım: Yüksek olasılıklı dönüş bölgesi');
  String rsiOverbought(String rsiVal) => _t(ar: 'RSI $rsiVal — تشبع شراء: مرحلة توزيع محتملة',           en: 'RSI $rsiVal — Overbought: distribution phase detected',                tr: 'RSI $rsiVal — Aşırı Alım: Dağıtım aşaması tespit edildi');
  String rsiBullMomentum(String rsiVal) => _t(ar: 'RSI $rsiVal — استمرار الزخم الصاعد',                  en: 'RSI $rsiVal — Bullish momentum continuation territory',                tr: 'RSI $rsiVal — Yükseliş momentum devamı bölgesi');
  String rsiBearPressure(String rsiVal) => _t(ar: 'RSI $rsiVal — ضغط هابط، البائعون مسيطرون',            en: 'RSI $rsiVal — Bearish pressure, sellers in control',                   tr: 'RSI $rsiVal — Düşüş baskısı, satıcılar kontrolde');
  String rsiNeutral(String rsiVal)    => _t(ar: 'RSI $rsiVal — منطقة محايدة، لا ميزة من RSI وحده',       en: 'RSI $rsiVal — Neutral zone, no edge from RSI alone',                  tr: 'RSI $rsiVal — Nötr bölge, RSI tek başına avantaj sağlamıyor');

  // MACD factors
  String get macdBullish => _t(ar: 'تقاطع MACD صاعد مؤكد — توسع هستوغرام تصاعدي',  en: 'MACD bullish crossover confirmed — upward histogram expansion',    tr: 'MACD yükseliş kesişimi onaylandı — histogram yukarı genişliyor');
  String get macdBearish => _t(ar: 'تقاطع MACD هابط مؤكد — هستوغرام تحت الصفر',    en: 'MACD bearish crossover confirmed — histogram below zero line',     tr: 'MACD düşüş kesişimi onaylandı — histogram sıfırın altında');
  String get macdDiverging => _t(ar: 'هستوغرام MACD متباعد — التقاطع قادم، لا اتجاه واضح', en: 'MACD histogram diverging — cross pending, no clear bias yet', tr: 'MACD histogram ıraksaması — kesişim bekleniyor, net yön yok');

  // S/D Zone factors
  String get sdStrongDemand => _t(ar: 'السعر يلمس منطقة طلب قوية — كتلة شراء مؤسسية', en: 'Price tapping into fresh Strong Demand Zone — institutional buying floor', tr: 'Fiyat güçlü talep bölgesine değiyor — kurumsal alım tabanı');
  String get sdWeakDemand   => _t(ar: 'منطقة طلب ضعيفة — دعم خفيف، راقب تأكيد الحجم', en: 'Weak Demand Zone in play — minor support, watch for volume confirmation', tr: 'Zayıf talep bölgesi aktif — hafif destek, hacim onayını izleyin');
  String get sdNeutral      => _t(ar: 'السعر في منطقة محايدة — لا توجد منطقة عرض/طلب نشطة', en: 'Price in neutral territory — no active S/D zone present', tr: 'Fiyat tarafsız bölgede — aktif A/T bölgesi yok');
  String get sdWeakSupply   => _t(ar: 'منطقة عرض ضعيفة — مقاومة خفيفة، ضغط بيعي جزئي', en: 'Weak Supply Zone overhead — light selling pressure, partial resistance', tr: 'Üstte zayıf arz bölgesi — hafif satış baskısı, kısmi direnç');
  String get sdStrongSupply => _t(ar: 'منطقة عرض قوية تعرقل الصعود — منطقة رفض هابط قوية', en: 'Strong Supply Zone blocking upside — high-probability rejection area', tr: 'Güçlü arz bölgesi yukarıyı engelliyor — yüksek olasılıklı ret bölgesi');

  // HTF factors
  String get htfBullish => _t(ar: 'فلتر H1: صاعد — الدخول متوافق مع الزخم الكلي',          en: 'H1 trend filter: BULLISH — entry aligned with macro momentum',       tr: 'H1 trend filtresi: YÜKSELİŞ — giriş makro momentum ile hizalı');
  String get htfBearish => _t(ar: 'فلتر H1: هابط — الدخول ضد المشترين، السمارت موني يبيع', en: 'H1 trend filter: BEARISH — entry against retail bulls, smart money sells', tr: 'H1 trend filtresi: DÜŞÜŞ — giriş perakende alıcılara karşı, akıllı para satıyor');
  String get htfRanging => _t(ar: 'فلتر H1: جانبي — تداول فقط من مستويات العرض/الطلب المتطرفة', en: 'H1 trend filter: RANGING — scalp only from extreme S/D levels', tr: 'H1 trend filtresi: YATAY — yalnızca aşırı A/T seviyelerinden scalp yapın');

  // AI Sentiment
  String aiSentimentBuy(String symbol, String htf, String score) => _t(
    ar: 'تحليل الذكاء الاصطناعي: $symbol يُظهر نمط تراكم كلاسيكياً. الاتجاه $htf يوفر تأكيداً اتجاهياً قوياً. يبدو أن تدفق أوامر المؤسسات مائل نحو الشراء عند المستويات الحالية. درجة التقاطع $score — إعداد عالي الاحتمالية. يُنصح بدخول محدد المخاطر مع تحديد حجم المركز بدقة.',
    en: 'AI Sentiment: $symbol is exhibiting a classic accumulation pattern. The $htf macro trend provides strong directional confirmation. Institutional order flow appears skewed toward longs at current levels. Confluence score of $score — high-probability setup. Risk-defined entry recommended with strict position sizing.',
    tr: 'Yapay Zeka Duyarlılığı: $symbol klasik bir birikim kalıbı sergilemiş. $htf makro trendi güçlü yönsel onay sağlıyor. Kurumsal emir akışı mevcut seviyelerde longlara yöneliyor gibi görünüyor. Birleşme skoru $score — yüksek olasılıklı kurulum. Katı pozisyon büyüklüğü ile risk tanımlı giriş önerilir.',
  );
  String aiSentimentSell(String symbol, String htf, String score) => _t(
    ar: 'تحليل الذكاء الاصطناعي: $symbol يُظهر خصائص توزيع. هيكل الاتجاه $htf يفضل البائعين. رُصد بصمة السمارت موني في منطقة العرض. درجة التقاطع الهابطة $score — إعداد عالي القناعة. أدر المخاطرة بإحكام؛ ادخل فقط عند إغلاق شمعة التأكيد.',
    en: 'AI Sentiment: $symbol is showing distribution characteristics. The $htf trend structure favors sellers. Smart-money footprint detected in supply. Confluence score of $score bearish — high-conviction setup. Manage risk tightly; scale in at confirmation candle close only.',
    tr: 'Yapay Zeka Duyarlılığı: $symbol dağıtım özellikleri gösteriyor. $htf trend yapısı satıcıları destekliyor. Arz bölgesinde akıllı para izi tespit edildi. Düşüş yönlü birleşme skoru $score — yüksek güvenli kurulum. Riski sıkıca yönetin; yalnızca onay mumu kapanışında girin.',
  );
  String aiSentimentWait(String symbol) => _t(
    ar: 'تحليل الذكاء الاصطناعي: $symbol يفتقر إلى قناعة اتجاهية كافية في الوقت الحالي. السوق يتوازن بين المشترين والبائعين دون تحيز مسيطر. الدخول الآن ينطوي على مخاطرة زائدة. راقب كسر النطاق الحالي مع تأكيد الحجم قبل التزام رأس المال.',
    en: 'AI Sentiment: $symbol lacks sufficient directional conviction at this moment. The market is balancing between buyers and sellers without a dominant bias. Entering now would carry excessive noise risk. Monitor for a break of the current range with volume confirmation before committing capital.',
    tr: 'Yapay Zeka Duyarlılığı: $symbol şu an yeterli yönsel kanıya sahip değil. Piyasa, baskın bir eğilim olmaksızın alıcılar ve satıcılar arasında dengeleniyor. Şimdi girmek aşırı gürültü riski taşır. Sermaye taahhüt etmeden önce hacim onayıyla mevcut aralığın kırılmasını izleyin.',
  );

  // Claude Opinion
  String claudeOpinion(String symbol, String score) => _t(
    ar: '🔗 كلود — خبير مالي — جاهز للـ API\n\nهذا القسم مُهيأ مسبقاً للتكامل الفعلي مع Claude claude-sonnet-4-6.\nبمجرد الاتصال عبر Anthropic API، سيظهر هنا تحليل مالي شامل يشمل السياق الكلي وتقييم المخاطر وتعليقاً على تدفق أوامر المؤسسات لـ $symbol (الدرجة: $score).',
    en: '🔗 Claude Financial Expert — API Placeholder\n\nThis section is pre-wired for live Claude claude-sonnet-4-6 integration.\nOnce connected via the Anthropic API, a certified financial analysis will appear here including macro context, risk assessment, and institutional flow commentary tailored to $symbol (score: $score).',
    tr: '🔗 Claude Finansal Uzman — API Yer Tutucusu\n\nBu bölüm canlı Claude claude-sonnet-4-6 entegrasyonu için önceden yapılandırılmıştır.\nAnthropic API üzerinden bağlandıktan sonra, $symbol için makro bağlam, risk değerlendirmesi ve kurumsal akış yorumunu içeren sertifikalı bir finansal analiz burada görünecektir (skor: $score).',
  );

  // Market closed
  String get marketClosedSignal => _t(
    ar: 'السوق مغلق — يفتح الأحد 21:00 UTC',
    en: 'Market closed — reopens Sunday 21:00 UTC',
    tr: 'Piyasa kapalı — Pazar 21:00 UTC\'de açılır',
  );
  String get marketClosedSentiment => _t(
    ar: 'سوق الفوركس مغلق حالياً. يفتح الأحد مساءً الساعة 21:00 UTC. استخدم هذا الوقت لمراجعة خططك والاستعداد للأسبوع القادم.',
    en: 'The forex market is currently closed. It reopens Sunday at 21:00 UTC. Use this time to review your strategy and prepare for the new week.',
    tr: 'Forex piyasası şu anda kapalı. Pazar 21:00 UTC\'de yeniden açılıyor. Bu zamanı stratejinizi gözden geçirmek için kullanın.',
  );
  String get marketClosedOpinion => _t(
    ar: 'السوق مغلق — لا يمكن إجراء تحليل.\n\nيفتح سوق الفوركس الأحد الساعة 21:00 UTC. عُد حينها للحصول على إشارات حقيقية مبنية على البيانات الحية.',
    en: 'Market is closed — analysis unavailable.\n\nForex market reopens Sunday at 21:00 UTC. Return then for real signals based on live market data.',
    tr: 'Piyasa kapalı — analiz mevcut değil.\n\nForex piyasası Pazar 21:00 UTC\'de açılıyor. Canlı verilere dayalı sinyaller için o zaman dönün.',
  );

  // Data fetch error
  String get dataErrorSignal => _t(
    ar: 'تعذّر جلب البيانات — حاول مرة أخرى',
    en: 'Failed to fetch market data — please retry',
    tr: 'Piyasa verisi alınamadı — lütfen tekrar deneyin',
  );
  String get dataErrorOpinion => _t(
    ar: 'تعذّر الاتصال بخادم البيانات. تأكد من اتصالك بالإنترنت ثم اضغط "حلل الآن" مرة أخرى.',
    en: 'Could not reach the data server. Check your internet connection and press "Analyze Now" again.',
    tr: 'Veri sunucusuna ulaşılamadı. İnternet bağlantınızı kontrol edip tekrar deneyin.',
  );

  // News freeze wait result
  String get newsFreezeAutoCheck => _t(
    ar: 'تفحص الأداة تلقائياً التقويم الاقتصادي قبل كل تحليل وتوقف الإشارات خلال فترات الخطر',
    en: 'The tool automatically checks the economic calendar before every analysis and pauses signals during high-risk periods',
    tr: 'Araç, her analizden önce ekonomik takvimi otomatik olarak kontrol eder ve yüksek riskli dönemlerde sinyalleri duraklatır',
  );

  String get newsFreezeWait => _t(
    ar: 'حدث اقتصادي عالي التأثير قريب — الإشارة مجمّدة',
    en: 'High-impact news event nearby — signal frozen',
    tr: 'Yakında yüksek etkili ekonomik olay var — sinyal donduruldu',
  );
  String get insufficientConfluence => _t(
    ar: 'توافق غير كافٍ — انتظر',
    en: 'Insufficient confluence — stand aside',
    tr: 'Yetersiz birleşim — bekleyin',
  );
  String get marketAmbiguous => _t(
    ar: 'ظروف السوق غامضة حالياً. الصبر هو الموقف.',
    en: 'Market conditions are currently ambiguous. Patience is a position.',
    tr: 'Piyasa koşulları şu an belirsiz. Sabır da bir pozisyondur.',
  );

  // ── Summary ─────────────────────────────────────────────────────────────────
  String get summaryLabel => _t(ar: 'عصارة التحليل', en: 'Analysis Summary', tr: 'Analiz Özeti');
  String get sessionLabel => _t(ar: 'الجلسة', en: 'Session', tr: 'Seans');
  String get patternLabel => _t(ar: 'نمط شمعي', en: 'Pattern', tr: 'Mum Formasyonu');

  // ── Session warning strings ──────────────────────────────────────────────────
  String get sessionLunchWarning => _t(
    ar: 'وقت غداء لندن — سيولة منخفضة، تجنب دخولاً جديدة',
    en: 'London Lunch — low liquidity, avoid new entries',
    tr: 'Londra Öğle Arası — düşük likidite, yeni giriş önlenmez',
  );
  String get sessionTokyoWarning => _t(
    ar: 'جلسة طوكيو — سيولة محدودة على أزواج الدولار، احذر التذبذب',
    en: 'Tokyo session — limited USD liquidity, beware of choppy price action',
    tr: 'Tokyo seansı — USD likiditesi sınırlı, dalgalı fiyat hareketine dikkat',
  );
  String get sessionSydneyWarning => _t(
    ar: 'جلسة سيدني — أدنى سيولة في اليوم، تقلبات ضيقة متوقعة',
    en: 'Sydney session — lowest liquidity of the day, narrow range expected',
    tr: 'Sidney seansı — günün en düşük likiditesi, dar aralık bekleniyor',
  );

  // ── Pattern name translations ────────────────────────────────────────────────
  String patternName(String key) {
    switch (key) {
      case 'BullishPinBar':    return _t(ar: 'دبوس صاعد (Pin Bar)',     en: 'Bullish Pin Bar',       tr: 'Yükseliş Pin Bar');
      case 'BearishPinBar':    return _t(ar: 'دبوس هابط (Pin Bar)',     en: 'Bearish Pin Bar',       tr: 'Düşüş Pin Bar');
      case 'BullishEngulfing': return _t(ar: 'ابتلاع صاعد (Engulfing)', en: 'Bullish Engulfing',     tr: 'Yükseliş Engulfing');
      case 'BearishEngulfing': return _t(ar: 'ابتلاع هابط (Engulfing)', en: 'Bearish Engulfing',     tr: 'Düşüş Engulfing');
      default:                 return '';
    }
  }

  String patternFactor(String key, SignalType signal) {
    final name = patternName(key);
    final confirms = _patternConfirms(key, signal);
    if (confirms == null) return '';
    return confirms
        ? _t(ar: 'نمط $name — يؤكد الإشارة ✓', en: 'Pattern: $name — confirms signal ✓', tr: 'Formasyon: $name — sinyali onaylıyor ✓')
        : _t(ar: 'نمط $name — يخالف الإشارة ⚠️', en: 'Pattern: $name — conflicts with signal ⚠️', tr: 'Formasyon: $name — sinyal ile çelişiyor ⚠️');
  }

  bool? _patternConfirms(String key, SignalType signal) {
    if (key.isEmpty) return null;
    final bullish = key.startsWith('Bullish');
    if (signal == SignalType.buy)  return bullish;
    if (signal == SignalType.sell) return !bullish;
    return null;
  }

  String atrFactor(double atr, double pipValue) {
    if (atr <= 0) return '';
    final atrPips = atr / pipValue;
    final quality = atrPips > 15
        ? _t(ar: 'تقلب ممتاز للسكالبينج', en: 'excellent scalping volatility', tr: 'mükemmel scalping oynaklığı')
        : atrPips > 8
            ? _t(ar: 'تقلب مناسب', en: 'good volatility', tr: 'iyi oynaklık')
            : _t(ar: 'تقلب منخفض — حجم المركز بحذر', en: 'low volatility — size down', tr: 'düşük oynaklık — pozisyon küçültün');
    return _t(
      ar: 'ATR(14): ${atrPips.toStringAsFixed(1)} pip — $quality',
      en: 'ATR(14): ${atrPips.toStringAsFixed(1)} pips — $quality',
      tr: 'ATR(14): ${atrPips.toStringAsFixed(1)} pip — $quality',
    );
  }
}
