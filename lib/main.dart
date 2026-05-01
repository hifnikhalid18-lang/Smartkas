import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const KasKuApp());
}

class KasKuApp extends StatelessWidget {
  const KasKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KasKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
