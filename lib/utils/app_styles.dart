import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Monochrome)
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color primaryText = Color(0xFF212529);
  static const Color secondaryText = Color(0xFF6C757D);
  static const Color border = Color(0xFFE9ECEF);
  
  // Accent Color (Emerald Soft)
  static const Color accent = Color(0xFF10B981);
  static const Color accentLight = Color(0xFFD1FAE5);
  
  // Functional Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  
  // Shadow
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}

class AppTextStyles {
  static const String fontFamily = 'Inter'; // Fallback to system if not loaded

  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: -0.5,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    letterSpacing: -0.2,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static BorderRadius roundedMd = BorderRadius.circular(md);
  static BorderRadius roundedLg = BorderRadius.circular(lg);
}
