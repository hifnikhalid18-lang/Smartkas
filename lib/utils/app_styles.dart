import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SMARTKAS STARTUP PREMIUM — Color System
// Modern Blue/Teal Startup Theme
// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF4F7FB); // Soft blue-white
  static const Color surface    = Color(0xFFFFFFFF); // Clean white card
  static const Color cardBg     = Color(0xFFF8FAFC); // Very light slate for inner elements

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color primaryText   = Color(0xFF1E293B); // Slate 800
  static const Color secondaryText = Color(0xFF64748B); // Slate 500
  static const Color muted         = Color(0xFF94A3B8); // Slate 400

  // ── Structure ──────────────────────────────────────────────────────────────
  static const Color border   = Color(0xFFE2E8F0); // Slate 200
  static const Color hairline = Color(0xFFF1F5F9); // Slate 100

  // ── Brand — Blue/Teal/Purple ──────────────────────────────────────────────
  static const Color accent      = Color(0xFF4F8CFF); // Primary Blue
  static const Color accentLight = Color(0xFFEFF6FF); // Soft Blue Tint
  static const Color accentDark  = Color(0xFF1D4ED8); // Deep Blue
  
  static const Color secondary   = Color(0xFF6DD3C7); // Soft Teal
  static const Color tertiary    = Color(0xFFA78BFA); // Soft Purple (Accent 2)

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E); // Green 500
  static const Color error   = Color(0xFFEF4444); // Red 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500

  // ── Shadows ────────────────────────────────────────────────────────────────
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF64748B).withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF64748B).withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF4F8CFF).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF1E293B).withValues(alpha: 0.03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  // Shadow glow
  static List<BoxShadow> balanceShadow = [
    BoxShadow(
      color: const Color(0xFF4F8CFF).withValues(alpha: 0.25),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: const Color(0xFF6DD3C7).withValues(alpha: 0.10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// GRADIENTS
// ─────────────────────────────────────────────────────────────────────────────
class AppGradients {
  // App Background — tidak dipakai jika menggunakan StartupBackground widget
  static const LinearGradient appBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF4F7FB),
      Color(0xFFE2E8F0),
    ],
  );

  // Balance card / Header — Modern Blue to Teal
  static const LinearGradient balanceCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4F8CFF), // Soft Blue
      Color(0xFF6DD3C7), // Soft Teal
    ],
  );

  // CTA / FAB
  static const LinearGradient primaryCTA = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F8CFF), Color(0xFF3B82F6)],
  );

  // Accent background subtle
  static const LinearGradient accentSubtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F8CFF), Color(0xFF6DD3C7)],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPOGRAPHY
// ─────────────────────────────────────────────────────────────────────────────
class AppTextStyles {
  static const TextStyle balance = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static const TextStyle balanceLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Color(0xCCFFFFFF),
    letterSpacing: 0.5,
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
    letterSpacing: -0.3,
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

  static const TextStyle micro = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    letterSpacing: 0.2,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.muted,
    letterSpacing: 1.0,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SPACING & RADII
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

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;
  static BorderRadius roundedSm  = BorderRadius.circular(sm);
  static BorderRadius roundedMd  = BorderRadius.circular(md);
  static BorderRadius roundedLg  = BorderRadius.circular(lg);
  static BorderRadius roundedXl  = BorderRadius.circular(xl);
  static BorderRadius roundedXxl = BorderRadius.circular(xxl);
}
