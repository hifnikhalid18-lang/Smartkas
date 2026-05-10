import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tentang Smartkas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo / Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wallet_rounded, size: 80, color: AppColors.accent),
            ),
            const SizedBox(height: 24),
            const Text(
              'Smartkas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              'Versi 1.0.0 (Production Ready)',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 32),
            _buildInfoCard(
              'Apa itu Smartkas?',
              'Smartkas adalah aplikasi manajemen keuangan offline yang dirancang untuk membantu Anda mencatat setiap transaksi dengan mudah, aman, dan tanpa perlu koneksi internet.',
            ),
            const SizedBox(height: 20),
            _buildFeatureList(),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            const Text('Dikembangkan dengan ❤️ untuk kemudahan finansial Anda.', textAlign: TextAlign.center, style: AppTextStyles.caption),
            const SizedBox(height: 8),
            const Text('© 2026 Smartkas Team', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.accent)),
          const SizedBox(height: 8),
          Text(content, style: AppTextStyles.body, textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Multi Kas (Dompet Terpisah)',
      'Riwayat & Laporan Visual',
      'Hutang & Piutang Tracking',
      'Target Menabung (Goal Tracking)',
      'Backup & Restore Data JSON',
      'Export PDF & Excel (Pro)',
      'Keamanan PIN Aplikasi',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fitur Utama:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 12),
                Text(f, style: AppTextStyles.body),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
