import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SMARTKAS FINANCE PREMIUM — Color System
// Emerald Finance Theme
// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF4F7F5); // off-white kehijauan — bukan putih polos
  static const Color surface    = Color(0xFFFFFFFF); // card surface — clean white
  static const Color cardBg     = Color(0xFFF0F4F2); // pill / chip background (sedikit hijau)

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color primaryText   = Color(0xFF111827); // hampir hitam
  static const Color secondaryText = Color(0xFF6B7280); // subtext abu
  static const Color muted         = Color(0xFF9CA3AF); // placeholder, tanggal, hint

  // ── Structure ──────────────────────────────────────────────────────────────
  static const Color border   = Color(0xFFE5E7EB); // pembatas tipis
  static const Color hairline = Color(0xFFF0F4F2); // separator sangat tipis

  // ── Brand — Emerald Teal (UTAMA) ──────────────────────────────────────────
  static const Color accent      = Color(0xFF14B88A); // primary brand color
  static const Color accentLight = Color(0xFFE8F8F3); // tint untuk chip/bg
  static const Color accentDark  = Color(0xFF0F766E); // secondary / pressed state

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF1FA971); // income — hijau teal sedikit lebih gelap
  static const Color error   = Color(0xFFE25555); // expense — merah tidak terlalu neon
  static const Color warning = Color(0xFFF59E0B); // amber

  // ── Shadows ────────────────────────────────────────────────────────────────
  // Semua shadow sangat tipis — kuncinya di offset + blur, bukan opacity besar
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF0F766E).withValues(alpha: 0.06),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF111827).withValues(alpha: 0.03),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F766E).withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF111827).withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  // Shadow untuk balance card — emerald-tinted
  static List<BoxShadow> balanceShadow = [
    BoxShadow(
      color: const Color(0xFF14B88A).withValues(alpha: 0.28),
      blurRadius: 28,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: const Color(0xFF0F766E).withValues(alpha: 0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// GRADIENTS
// ─────────────────────────────────────────────────────────────────────────────
class AppGradients {
  // Balance card — premium emerald finance gradient
  static const LinearGradient balanceCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F9D7A), // teal emerald dalam
      Color(0xFF14B88A), // emerald utama
      Color(0xFF36C2A4), // emerald terang di kanan bawah
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Drawer header — dark slate premium
  static const LinearGradient navySlate = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
  );

  // FAB / CTA
  static const LinearGradient emerald = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF14B88A), Color(0xFF0F766E)],
  );

  // Accent background subtle (untuk carousel card aktif)
  static const LinearGradient accentSubtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F9D7A), Color(0xFF0F766E)],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPOGRAPHY
// Premium finance app — jelas, bersih, hierarki kuat
// ─────────────────────────────────────────────────────────────────────────────
class AppTextStyles {
  // Balance — angka terpenting di layar
  static const TextStyle balance = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -1.5,
    height: 1.0,
  );

  // Balance label (di dalam card)
  static const TextStyle balanceLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Color(0xCCFFFFFF), // putih 80%
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
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
    letterSpacing: 0.8,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SPACING
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
  static const double xl = 20.0;
  static const double xxl = 28.0;
  static BorderRadius roundedSm  = BorderRadius.circular(sm);
  static BorderRadius roundedMd  = BorderRadius.circular(md);
  static BorderRadius roundedLg  = BorderRadius.circular(lg);
  static BorderRadius roundedXl  = BorderRadius.circular(xl);
  static BorderRadius roundedXxl = BorderRadius.circular(xxl);
}
