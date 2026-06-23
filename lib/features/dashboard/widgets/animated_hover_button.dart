import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Reusable hover-animated button.
/// On hover: lifts 4 px upward + glowing colored drop-shadow.
class AnimatedHoverButton extends StatefulWidget {
  const AnimatedHoverButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.glowColor = AppColors.gold,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.width,
    this.height = 52,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w700,
    this.borderRadius = 10,
    this.isLoading = false,
    this.enabled = true,
    this.letterSpacing = 1.2,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color glowColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final double? width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final bool isLoading;
  final bool enabled;
  final double letterSpacing;

  @override
  State<AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<AnimatedHoverButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _lift;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _lift = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _glow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent _) {
    if (!widget.enabled || widget.isLoading) return;
    setState(() => _hovered = true);
    _ctrl.forward();
  }

  void _onExit(PointerEvent _) {
    setState(() => _hovered = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.gold;
    final fg = widget.foregroundColor ?? AppColors.background;

    return MouseRegion(
      cursor: (widget.enabled && !widget.isLoading)
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _lift.value),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor
                      .withOpacity(0.15 + _glow.value * 0.45),
                  blurRadius: 8 + _glow.value * 22,
                  spreadRadius: _glow.value * 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InkWell(
            onTap: (widget.enabled && !widget.isLoading) ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Ink(
              decoration: BoxDecoration(
                color: widget.enabled ? bg : bg.withOpacity(0.4),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: widget.enabled
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          bg,
                          Color.lerp(bg, Colors.white, 0.1)!,
                        ],
                      )
                    : null,
              ),
              child: _buildContent(fg),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color fg) {
    return Center(
      child: widget.isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(fg),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: fg, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: fg,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                    letterSpacing: widget.letterSpacing,
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Outlined variant ──────────────────────────────────────────────────────────

class AnimatedHoverOutlinedButton extends StatefulWidget {
  const AnimatedHoverOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.glowColor = AppColors.gold,
    this.borderColor = AppColors.gold,
    this.textColor = AppColors.gold,
    this.icon,
    this.height = 44,
    this.borderRadius = 8,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color glowColor;
  final Color borderColor;
  final Color textColor;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final double fontSize;

  @override
  State<AnimatedHoverOutlinedButton> createState() =>
      _AnimatedHoverOutlinedButtonState();
}

class _AnimatedHoverOutlinedButtonState
    extends State<AnimatedHoverOutlinedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _lift;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _lift = Tween<double>(begin: 0, end: -3)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _glow = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, child) => Transform.translate(
          offset: Offset(0, _lift.value),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(_glow.value * 0.4),
                  blurRadius: _glow.value * 16,
                  spreadRadius: _glow.value,
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.textColor,
            side: BorderSide(color: widget.borderColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            minimumSize: Size(0, widget.height),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: widget.textColor),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
