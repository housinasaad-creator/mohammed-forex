import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/locale_provider.dart';
import '../models/analysis_result.dart';
import '../providers/dashboard_provider.dart';

class TechnicalGaugesWidget extends StatelessWidget {
  const TechnicalGaugesWidget({super.key, this.scrollable = true});
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final result = provider.result;
    final s = context.watch<LocaleProvider>().s;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: s.technicalGauges, icon: Icons.speed_rounded),
        const SizedBox(height: 18),
        _GaugeCard(
          title: 'RSI (14)',
          subtitle: s.relativeStrength,
          child: _RsiGauge(value: result?.rsi ?? 50, animated: result != null),
        ),
        const SizedBox(height: 16),
        _GaugeCard(
          title: 'MACD',
          subtitle: s.signalLineCross,
          child: _MacdPanel(result: result),
        ),
        const SizedBox(height: 16),
        _GaugeCard(
          title: s.supplyDemand,
          subtitle: s.institutionalZone,
          child: _ZonePanel(result: result),
        ),
        const SizedBox(height: 16),
        _GaugeCard(
          title: s.higherTfFilter,
          subtitle: s.macroTrendAlign,
          child: _HtfPanel(result: result),
        ),
      ],
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: scrollable
          ? SingleChildScrollView(padding: const EdgeInsets.all(20), child: content)
          : Padding(padding: const EdgeInsets.all(20), child: content),
    );
  }
}

// ── Section Label ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gold),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Gauge Card wrapper ─────────────────────────────────────────────────────────

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ── RSI Gauge ──────────────────────────────────────────────────────────────────

class _RsiGauge extends StatefulWidget {
  const _RsiGauge({required this.value, required this.animated});
  final double value;
  final bool animated;

  @override
  State<_RsiGauge> createState() => _RsiGaugeState();
}

class _RsiGaugeState extends State<_RsiGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim =
        Tween<double>(begin: 0, end: widget.value / 100).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    if (widget.animated) _ctrl.forward();
  }

  @override
  void didUpdateWidget(_RsiGauge old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _anim = Tween<double>(begin: 0, end: widget.value / 100).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      );
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rsiColor = widget.value < 30
        ? AppColors.neonGreen
        : widget.value > 70
            ? AppColors.neonRed
            : AppColors.gold;

    return Row(
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => CustomPaint(
              painter: _ArcGaugePainter(
                progress: _anim.value,
                arcColor: rsiColor,
                trackColor: AppColors.gaugeTrack,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.value.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: rsiColor,
                      ),
                    ),
                    Text(
                      'RSI',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Builder(builder: (ctx) {
            final s = ctx.watch<LocaleProvider>().s;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ZoneRow(
                  label: s.overbought,
                  range: '> 70',
                  color: AppColors.neonRed,
                  isActive: widget.value > 70,
                ),
                const SizedBox(height: 6),
                _ZoneRow(
                  label: s.neutral,
                  range: '30–70',
                  color: AppColors.gold,
                  isActive: widget.value >= 30 && widget.value <= 70,
                ),
                const SizedBox(height: 6),
                _ZoneRow(
                  label: s.oversold,
                  range: '< 30',
                  color: AppColors.neonGreen,
                  isActive: widget.value < 30,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _ZoneRow extends StatelessWidget {
  const _ZoneRow({
    required this.label,
    required this.range,
    required this.color,
    required this.isActive,
  });

  final String label;
  final String range;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : color.withOpacity(0.25),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isActive ? color : AppColors.textMuted,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          range,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ── MACD Panel ────────────────────────────────────────────────────────────────

class _MacdPanel extends StatelessWidget {
  const _MacdPanel({this.result});
  final AnalysisResult? result;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().s;
    if (result == null) {
      return _EmptyState(text: s.runToLoadMacd);
    }

    final macdVal = result!.macdValue;
    final sigLine = result!.macdSignalLine;
    final histo   = result!.macdHistogram;
    final isBull  = histo > 0;
    final histoColor = isBull ? AppColors.neonGreen : AppColors.neonRed;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ValueChip(
                label: 'MACD',
                value: _fmt(macdVal),
                color: macdVal > 0 ? AppColors.neonGreen : AppColors.neonRed,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ValueChip(
                label: s.signalChip,
                value: _fmt(sigLine),
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ValueChip(
                label: s.histogram,
                value: _fmt(histo),
                color: histoColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _MacdHistogramBar(histogram: histo),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              isBull ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 14,
              color: histoColor,
            ),
            const SizedBox(width: 6),
            Text(
              isBull ? s.bullishCrossover : s.bearishCrossover,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: histoColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v.abs() < 0.001) return v.toStringAsExponential(2);
    return v.toStringAsFixed(5);
  }
}

class _MacdHistogramBar extends StatelessWidget {
  const _MacdHistogramBar({required this.histogram});
  final double histogram;

  @override
  Widget build(BuildContext context) {
    final pct = (histogram.abs() / 0.002).clamp(0.05, 1.0);
    final color = histogram > 0 ? AppColors.neonGreen : AppColors.neonRed;

    return SizedBox(
      height: 20,
      child: Stack(
        children: [
          // Track
          Container(
            decoration: BoxDecoration(
              color: AppColors.gaugeTrack,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Left half | center line | right half
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: histogram < 0
                      ? FractionallySizedBox(
                          widthFactor: pct,
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
              Container(width: 1, height: 20, color: AppColors.border),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: histogram > 0
                      ? FractionallySizedBox(
                          widthFactor: pct,
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Zone Panel ────────────────────────────────────────────────────────────────

class _ZonePanel extends StatelessWidget {
  const _ZonePanel({this.result});
  final AnalysisResult? result;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().s;
    if (result == null) {
      return _EmptyState(text: s.runToDetectZones);
    }

    final zone = result!.zone;
    final color = zone.color;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.zoneLabel(zone),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StrengthBar(strength: zone.strength, color: color),
        const SizedBox(height: 8),
        Text(
          s.zoneDesc(zone),
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── HTF Panel ──────────────────────────────────────────────────────────────────

class _HtfPanel extends StatelessWidget {
  const _HtfPanel({this.result});
  final AnalysisResult? result;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().s;
    if (result == null) {
      return _EmptyState(text: s.runToLoadHtf);
    }

    final trend = result!.higherTfTrend;
    final color = trend == 'Bullish'
        ? AppColors.neonGreen
        : trend == 'Bearish'
            ? AppColors.neonRed
            : AppColors.waitAmber;
    final icon = trend == 'Bullish'
        ? Icons.trending_up_rounded
        : trend == 'Bearish'
            ? Icons.trending_down_rounded
            : Icons.swap_horiz_rounded;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'H1 Trend: ${s.htfTrendLabel(trend)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                s.htfSubLabel(trend),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────

class _ValueChip extends StatelessWidget {
  const _ValueChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.strength, required this.color});
  final double strength;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.gaugeTrack,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        FractionallySizedBox(
          widthFactor: strength.clamp(0.0, 1.0),
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: LinearGradient(
                colors: [color.withOpacity(0.6), color],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty_rounded,
              size: 14, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Arc Gauge Painter ──────────────────────────────────────────────────────────

class _ArcGaugePainter extends CustomPainter {
  const _ArcGaugePainter({
    required this.progress,
    required this.arcColor,
    required this.trackColor,
  });

  final double progress; // 0.0–1.0
  final Color arcColor;
  final Color trackColor;

  static const double _startAngle = math.pi * 0.75;
  static const double _sweepTotal = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    canvas.drawArc(
      rect,
      _startAngle,
      _sweepTotal,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0) {
      // Glow
      canvas.drawArc(
        rect,
        _startAngle,
        _sweepTotal * progress,
        false,
        Paint()
          ..color = arcColor.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // Arc
      canvas.drawArc(
        rect,
        _startAngle,
        _sweepTotal * progress,
        false,
        Paint()
          ..color = arcColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round,
      );
    }

    // Tick marks at 30 and 70
    _drawTick(canvas, center, radius, 0.3);
    _drawTick(canvas, center, radius, 0.7);
  }

  void _drawTick(Canvas canvas, Offset center, double radius, double pct) {
    final angle = _startAngle + _sweepTotal * pct;
    final inner = Offset(
      center.dx + (radius - 10) * math.cos(angle),
      center.dy + (radius - 10) * math.sin(angle),
    );
    final outer = Offset(
      center.dx + (radius + 2) * math.cos(angle),
      center.dy + (radius + 2) * math.sin(angle),
    );
    canvas.drawLine(
      inner,
      outer,
      Paint()
        ..color = AppColors.textMuted
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_ArcGaugePainter old) =>
      old.progress != progress || old.arcColor != arcColor;
}
