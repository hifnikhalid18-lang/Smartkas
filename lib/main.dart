import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/app_styles.dart';

void main() {
  runApp(const KasKuApp());
}

class KasKuApp extends StatelessWidget {
  const KasKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smartkas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          primary: AppColors.accent,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.display,
          titleLarge: AppTextStyles.title,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.subtitle,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primaryText),
          titleTextStyle: AppTextStyles.title,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
