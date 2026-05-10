import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COLOR SYSTEM
// Neutral-first palette. Emerald is a brand accent, not decoration.
// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  // Backgrounds
  static const Color background  = Color(0xFFF8FAFC); // Slate 50
  static const Color surface     = Colors.white;
  static const Color cardBg      = Color(0xFFF1F5F9); // Slate 100 — chip/pill bg

  // Text
  static const Color primaryText   = Color(0xFF0F172A); // Slate 900
  static const Color secondaryText = Color(0xFF64748B); // Slate 500
  static const Color muted         = Color(0xFF94A3B8); // Slate 400 — dates, hints

  // Structural
  static const Color border    = Color(0xFFE2E8F0); // Slate 200
  static const Color hairline  = Color(0xFFF1F5F9); // Slate 100 — thin separators

  // Brand — Emerald (use sparingly)
  static const Color accent      = Color(0xFF10B981); // Emerald 500
  static const Color accentLight = Color(0xFFECFDF5); // Emerald 50
  static const Color accentDark  = Color(0xFF047857); // Emerald 700

  // Semantic
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color error   = Color(0xFFF43F5E); // Rose 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500

  // Shadows — very subtle
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: const Color(0xFF10B981).withOpacity(0.18),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// GRADIENTS
// ─────────────────────────────────────────────────────────────────────────────
class AppGradients {
  // Dark navy gradient for the balance section — sophisticated, not garish
  static const LinearGradient balanceGrad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );

  // Emerald — only for FABs / primary CTAs
  static const LinearGradient emerald = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // Drawer header
  static const LinearGradient navySlate = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF334155)],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPOGRAPHY
// ─────────────────────────────────────────────────────────────────────────────
class AppTextStyles {
  // Balance — the most important number on screen
  static const TextStyle balance = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppColors.primaryText,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.primaryText,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.primaryText,
  );

  // Monetary amounts in list
  static const TextStyle amount = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.primaryText,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );

  // Micro label — dates, badges, tiny info
  static const TextStyle micro = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    letterSpacing: 0.2,
  );

  // Section header — uppercase tracking (iOS grouping style)
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
    letterSpacing: 0.8,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SPACING — intentionally varied, not all the same
// ─────────────────────────────────────────────────────────────────────────────
class AppSpacing {
  static const double tiny = 4.0;
  static const double xs   = 6.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double xxl  = 48.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// RADII
// ─────────────────────────────────────────────────────────────────────────────
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static BorderRadius roundedSm = BorderRadius.circular(sm);
  static BorderRadius roundedMd = BorderRadius.circular(md);
  static BorderRadius roundedLg = BorderRadius.circular(lg);
  static BorderRadius roundedXl = BorderRadius.circular(xl);
}
