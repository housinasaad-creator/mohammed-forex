import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/locale_provider.dart';
import '../providers/dashboard_provider.dart';
import 'animated_hover_button.dart';
import 'analysis_result_card.dart';

class AiExecutionChamberWidget extends StatelessWidget {
  const AiExecutionChamberWidget({super.key, this.scrollable = true});
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final s = context.watch<LocaleProvider>().s;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(
              s.aiChamberTitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ActionBar(provider: provider),
        const SizedBox(height: 20),
        _ResultsArea(provider: provider),
      ],
    );

    return scrollable
        ? SingleChildScrollView(padding: const EdgeInsets.all(20), child: content)
        : Padding(padding: const EdgeInsets.all(20), child: content);
  }
}

// ── Action Bar ─────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.provider});
  final DashboardProvider provider;

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LocaleProvider>();
    final s = lp.s;
    return Row(
      children: [
        // Main CTA — Analyze Now
        Expanded(
          flex: 3,
          child: AnimatedHoverButton(
            label: s.analyzeNowBtn,
            icon: Icons.bolt_rounded,
            glowColor: AppColors.gold,
            height: 58,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            isLoading: provider.isLoading,
            enabled: !provider.isLoading,
            onPressed: () => provider.runAnalysis(lang: lp.lang),
          ),
        ),
        const SizedBox(width: 12),

        // Clear results button
        if (provider.result != null)
          AnimatedHoverOutlinedButton(
            label: s.clearBtn,
            icon: Icons.refresh_rounded,
            glowColor: AppColors.textMuted,
            borderColor: AppColors.border,
            textColor: AppColors.textSecondary,
            onPressed: () => provider.clearResult(),
          ),
      ],
    );
  }
}

// ── Results Area ──────────────────────────────────────────────────────────────

class _ResultsArea extends StatelessWidget {
  const _ResultsArea({required this.provider});
  final DashboardProvider provider;

  @override
  Widget build(BuildContext context) {
    switch (provider.state) {
      case AnalysisState.idle:
        return _IdlePlaceholder(assetSymbol: provider.selectedAsset.symbol);
      case AnalysisState.loading:
        return const _LoadingState();
      case AnalysisState.done:
        return AnalysisResultCard(
          result: provider.result!,
          asset: provider.selectedAsset,
          timeframe: provider.selectedTimeframe,
        );
      case AnalysisState.error:
        return _ErrorState(message: provider.errorMessage);
    }
  }
}

// ── Idle Placeholder ──────────────────────────────────────────────────────────

class _IdlePlaceholder extends StatelessWidget {
  const _IdlePlaceholder({required this.assetSymbol});
  final String assetSymbol;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().s;
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gold hex icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withOpacity(0.08),
              border: Border.all(color: AppColors.borderGold, width: 1.5),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: AppColors.gold,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.selectAssetHint,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            s.generateSignalHint,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${s.activeLabel} $assetSymbol',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading State ─────────────────────────────────────────────────────────────

class _LoadingState extends StatefulWidget {
  const _LoadingState();

  @override
  State<_LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<_LoadingState>
    with TickerProviderStateMixin {
  late AnimationController _spinCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  int _step = 0;

  static const int _stepCount = 6;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(_pulseCtrl);
    _cycleStep();
  }

  void _cycleStep() {
    Future.delayed(const Duration(milliseconds: 260), () {
      if (!mounted) return;
      setState(() => _step = (_step + 1) % _stepCount);
      _cycleStep();
    });
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().s;
    final steps = s.loadingSteps;

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGold),
      ),
      child: Column(
        children: [
          RotationTransition(
            turns: _spinCtrl,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold,
                  width: 2.5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                gradient: SweepGradient(
                  colors: [
                    AppColors.gold.withOpacity(0),
                    AppColors.gold,
                  ],
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.gold,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.analysingLabel,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Opacity(
              opacity: _pulseAnim.value,
              child: Text(
                steps[_step % steps.length],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            child: LinearProgressIndicator(
              backgroundColor: AppColors.gaugeTrack,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error State ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.neonRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neonRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.neonRed, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.neonRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
