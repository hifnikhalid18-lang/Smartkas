import 'package:flutter/material.dart';

class ReusableColorScheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4F8CFF),   // Soft Blue
      secondary: Color(0xFF6DD3C7), // Soft Teal
      tertiary: Color(0xFFA78BFA),  // Soft Purple
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Color(0xFF1E293B),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F7FB), // Soft blue-white
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F7FB),
      surfaceTintColor: Colors.transparent,
      foregroundColor: Color(0xFF1E293B),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E293B),
        letterSpacing: -0.3,
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFE2E8F0), thickness: 1),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF4F8CFF),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF4F8CFF);
        return null;
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4F8CFF), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)), // Soft grey placeholder
      labelStyle: const TextStyle(color: Color(0xFF64748B)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F8CFF),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4F8CFF),
      secondary: Color(0xFF6DD3C7),
      surface: Color(0xFF1E293B), 
      onPrimary: Colors.white,
      onSurface: Color(0xFFF1F5F9),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
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
        letterSpacing: -0.3,
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF1E293B), thickness: 1),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
  );
}
