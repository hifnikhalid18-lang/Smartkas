import 'package:flutter/material.dart';

class ReusableColorScheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF10B981),   // Emerald
      secondary: Color(0xFF0F172A), // Slate 900
      surface: Colors.white,
      background: Color(0xFFF8FAFC),
      onPrimary: Colors.white,
      onSurface: Color(0xFF0F172A),
      onBackground: Color(0xFF0F172A),
      error: Color(0xFFF43F5E),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8FAFC),
      surfaceTintColor: Colors.transparent,
      foregroundColor: Color(0xFF0F172A),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
        letterSpacing: -0.2,
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFF1F5F9), thickness: 1),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF10B981),   // Emerald
      secondary: Color(0xFF10B981),
      surface: Color(0xFF1E293B),   // Slate 800
      background: Color(0xFF0F172A), // Slate 900
      onPrimary: Colors.white,
      onSurface: Colors.white,
      onBackground: Color(0xFFCBD5E1),
      error: Color(0xFFF43F5E),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F172A),
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.2,
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF1E293B), thickness: 1),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
  );
}
