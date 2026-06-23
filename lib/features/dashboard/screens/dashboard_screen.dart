import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/locale_provider.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/technical_gauges_widget.dart';
import '../widgets/ai_execution_chamber_widget.dart';
import '../widgets/candlestick_chart_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.showBackButton = false});
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _AmbientGlow(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SidebarWidget(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HeaderWidget(showBackButton: showBackButton),
                    Expanded(
                      child: SingleChildScrollView(
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 340,
                                child: CandlestickChartWidget(),
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Flexible(
                                      flex: 4,
                                      child: TechnicalGaugesWidget(scrollable: false),
                                    ),
                                    const Flexible(
                                      flex: 6,
                                      child: AiExecutionChamberWidget(scrollable: false),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const _BottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Ambient Background Glow ────────────────────────────────────────────────────

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Top-left gold glow near sidebar
            Positioned(
              top: -120,
              left: -80,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Center-right subtle glow
            Positioned(
              bottom: -100,
              right: 100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.neonGreen.withOpacity(0.025),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Status Bar ──────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().s;
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: isMobile
          ? Center(
              child: Text(
                'mohammed forex  ·  ${s.advancedDashboard}',
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.textMuted, letterSpacing: 0.3),
              ),
            )
          : Row(
              children: [
                Text(
                  'mohammed forex  ·  ${s.advancedDashboard}  ·  ${s.confluenceEngine}',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textMuted, letterSpacing: 0.3),
                ),
                const Spacer(),
                Text(
                  'Portfolio Build  ·  Claude Sonnet 4.6 API Ready  ·  MT5 Bridge Ready',
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textMuted, letterSpacing: 0.3),
                ),
              ],
            ),
    );
  }
}
