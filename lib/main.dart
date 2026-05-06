import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/local_notification_service.dart';
import 'providers/theme_provider.dart';
import 'utils/reusable_color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();
  runApp(const KasKuApp());
}

class KasKuApp extends StatelessWidget {
  const KasKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'Smartkas',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ReusableColorScheme.lightTheme,
          darkTheme: ReusableColorScheme.darkTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
