import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/locale_provider.dart';
import '../models/asset_model.dart';
import '../providers/dashboard_provider.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  final Set<AssetCategory> _expanded = {
    AssetCategory.forexMajor,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 262,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          _buildLogo(),
          const Divider(color: AppColors.border, height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildCategory(AssetCategory.forexMajor,  AssetCatalogue.forexMajor),
                  _buildCategory(AssetCategory.forexMinor,  AssetCatalogue.forexMinor),
                  _buildCategory(AssetCategory.forexExotic, AssetCatalogue.forexExotic),
                  _buildCategory(AssetCategory.metals,      AssetCatalogue.metals),
                  _buildCategory(AssetCategory.energy,      AssetCatalogue.energy),
                  _buildCategory(AssetCategory.commodities, AssetCatalogue.commodities),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  // ── Logo Panel ─────────────────────────────────────────────────────────────

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Row(
        children: [
          _GoldCircleLogo(size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'mohammed',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gold,
                    letterSpacing: 0.3,
                    height: 1.1,
                  ),
                ),
                Text(
                  'forex',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    letterSpacing: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Section ───────────────────────────────────────────────────────

  Widget _buildCategory(AssetCategory category, List<Asset> assets) {
    final isOpen = _expanded.contains(category);
    return Column(
      children: [
        _CategoryHeader(
          category: category,
          isExpanded: isOpen,
          onTap: () => setState(() {
            if (isOpen) {
              _expanded.remove(category);
            } else {
              _expanded.add(category);
            }
          }),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState:
              isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(
            children: assets
                .map((a) => _AssetTile(asset: a))
                .toList(),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 14, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            'v1.0.0 · Portfolio Build',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textMuted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _GoldCircleLogo extends StatelessWidget {
  const _GoldCircleLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [AppColors.goldLight, AppColors.gold, AppColors.goldDim],
          stops: [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'MF',
          style: GoogleFonts.inter(
            fontSize: size * 0.34,
            fontWeight: FontWeight.w900,
            color: AppColors.background,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

class _CategoryHeader extends StatefulWidget {
  const _CategoryHeader({
    required this.category,
    required this.isExpanded,
    required this.onTap,
  });

  final AssetCategory category;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  State<_CategoryHeader> createState() => _CategoryHeaderState();
}

class _CategoryHeaderState extends State<_CategoryHeader> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _hovered
                ? AppColors.surfaceHigh
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                widget.category.icon,
                size: 16,
                color: widget.category.accentColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.watch<LocaleProvider>().s.categoryLabel(widget.category),
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: widget.isExpanded ? 0 : -0.25,
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetTile extends StatefulWidget {
  const _AssetTile({required this.asset});
  final Asset asset;

  @override
  State<_AssetTile> createState() => _AssetTileState();
}

class _AssetTileState extends State<_AssetTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final isSelected =
        provider.selectedAsset.symbol == widget.asset.symbol;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => provider.selectAsset(widget.asset),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? AppColors.gold.withOpacity(0.12)
                : _hovered
                    ? AppColors.surfaceHigh
                    : Colors.transparent,
            border: isSelected
                ? Border.all(color: AppColors.borderGold, width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Circular Logo Badge
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.asset.logoColor.withOpacity(0.15),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.gold
                        : widget.asset.logoColor.withOpacity(0.5),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.asset.abbreviation,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.gold
                          : widget.asset.logoColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.asset.symbol,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.gold
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.asset.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
