import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Pro-Smartkas)
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color primaryText = Color(0xFF1E293B); // Slate 800
  static const Color secondaryText = Color(0xFF64748B); // Slate 500
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  
  // Accent Color (Emerald Pro)
  static const Color accent = Color(0xFF059669);
  static const Color accentLight = Color(0xFFD1FAE5);
  
  // Functional Colors
  static const Color error = Color(0xFFE11D48); // Rose Red
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  
  // Shadow (Soft UI - 4% opacity)
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF1E293B).withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: const Color(0xFF059669).withOpacity(0.1),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}

class AppGradients {
  static const LinearGradient emerald = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF10B981)],
  );

  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white24, Colors.white10],
  );
}

class AppTextStyles {
  static const String fontFamily = 'Inter'; // Fallback to system if not loaded

  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
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
  static const double sm = 10.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static BorderRadius roundedMd = BorderRadius.circular(md);
  static BorderRadius roundedLg = BorderRadius.circular(lg);
  static BorderRadius roundedXl = BorderRadius.circular(xl);
}
