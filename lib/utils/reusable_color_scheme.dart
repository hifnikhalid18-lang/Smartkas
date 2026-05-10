import 'package:flutter/material.dart';

class ReusableColorScheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF14B88A),   // Emerald Teal
      secondary: Color(0xFF0F766E), // Teal Dark
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Color(0xFF111827),
      error: Color(0xFFE25555),
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F7F5), // off-white kehijauan
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F7F5),
      surfaceTintColor: Colors.transparent,
      foregroundColor: Color(0xFF111827),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF111827),
        letterSpacing: -0.3,
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFF0F4F2), thickness: 1),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF14B88A),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF14B88A);
        return null;
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F4F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF14B88A), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF14B88A),
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
      primary: Color(0xFF14B88A),
      secondary: Color(0xFF0F766E),
      surface: Color(0xFF1C2B27), // dark teal surface
      onPrimary: Colors.white,
      onSurface: Color(0xFFE5E7EB),
      error: Color(0xFFE25555),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1A16), // dark teal-black
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F1A16),
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
    dividerTheme: const DividerThemeData(color: Color(0xFF1C2B27), thickness: 1),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
  );
}
