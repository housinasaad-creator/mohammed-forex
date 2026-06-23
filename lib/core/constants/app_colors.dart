import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background     = Color(0xFF07080F); // Deep Space Black
  static const Color surface        = Color(0xFF0E0F1E); // Deep Navy Surface
  static const Color surfaceHigh    = Color(0xFF141528); // Elevated Surface
  static const Color sidebarBg      = Color(0xFF09091A); // Sidebar Dark
  static const Color headerBg       = Color(0xFF0B0C1E); // Header Dark

  // ── Gold Brand ────────────────────────────────────────────────────────────
  static const Color gold           = Color(0xFFC9A84C); // Warm Metallic Gold
  static const Color goldLight      = Color(0xFFE8C55A); // Champagne Gold
  static const Color goldDim        = Color(0xFF7A6428); // Subdued Gold

  // ── Signal Colors — Premium Teal & Rose ───────────────────────────────────
  static const Color neonGreen      = Color(0xFF26C6A4); // Premium Teal (BUY)
  static const Color neonGreenDim   = Color(0xFF1A9980); // Teal Dim
  static const Color neonRed        = Color(0xFFE8415A); // Deep Rose (SELL)
  static const Color neonRedDim     = Color(0xFFB53050); // Rose Dim
  static const Color waitAmber      = Color(0xFFF59E0B); // Amber (WAIT)

  // ── Chart Indicator Colors ────────────────────────────────────────────────
  static const Color indicatorAmber = Color(0xFFF59E0B); // MA Line 1
  static const Color indicatorPurple = Color(0xFF818CF8); // MA Line 2
  static const Color indicatorBlue  = Color(0xFF3B82F6); // Support/Resistance

  // ── Typography ────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFFECECF8); // Cool White
  static const Color textSecondary  = Color(0xFF7878A0); // Blue-Gray
  static const Color textMuted      = Color(0xFF484868); // Dark Blue-Gray

  // ── Borders & Dividers ────────────────────────────────────────────────────
  static const Color border         = Color(0xFF1A1A30);
  static const Color borderGold     = Color(0x44C9A84C);
  static const Color borderActive   = Color(0xFFC9A84C);

  // ── Gauge Background ──────────────────────────────────────────────────────
  static const Color gaugeTrack     = Color(0xFF1A1A30);

  // ── Glows (for box-shadows) ───────────────────────────────────────────────
  static const Color glowGold       = Color(0x44C9A84C);
  static const Color glowGreen      = Color(0x4426C6A4);
  static const Color glowRed        = Color(0x44E8415A);
  static const Color glowAmber      = Color(0x44F59E0B);
}
