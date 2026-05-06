import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/reusable_card.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Tema'),
      ),
      body: ListenableBuilder(
        listenable: themeProvider,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildThemeOption(
                  context,
                  title: 'Terang',
                  subtitle: 'Tampilan bersih dan cerah',
                  icon: Icons.light_mode_rounded,
                  mode: ThemeMode.light,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildThemeOption(
                  context,
                  title: 'Gelap',
                  subtitle: 'Nyaman di mata saat malam',
                  icon: Icons.dark_mode_rounded,
                  mode: ThemeMode.dark,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildThemeOption(
                  context,
                  title: 'Sistem',
                  subtitle: 'Mengikuti pengaturan HP Anda',
                  icon: Icons.settings_brightness_rounded,
                  mode: ThemeMode.system,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
  }) {
    final isSelected = themeProvider.themeMode == mode;
    final colorScheme = Theme.of(context).colorScheme;

    return ReusableCard(
      onTap: () => themeProvider.setThemeMode(mode),
      border: isSelected ? Border.all(color: colorScheme.primary, width: 2) : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isSelected ? colorScheme.primary : AppColors.secondaryText).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? colorScheme.primary : AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: colorScheme.primary),
        ],
      ),
    );
  }
}
