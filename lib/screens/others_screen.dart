import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../widgets/reusable_card.dart';
import 'debt_screen.dart';
import 'savings_screen.dart';
import 'settings_screen.dart';
import 'pin_setup_screen.dart';
import '../services/backup_export_service.dart';
import '../providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class OthersScreen extends StatelessWidget {
  const OthersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lainnya'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('LAYANAN KEUANGAN'),
            const SizedBox(height: AppSpacing.sm),
            _buildMenuCard(
              context,
              title: 'Hutang Piutang',
              subtitle: 'Manajemen pinjaman & tagihan',
              icon: Icons.people_outline_rounded,
              color: Colors.indigo,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DebtScreen())),
            ),
            _buildMenuCard(
              context,
              title: 'Target Menabung',
              subtitle: 'Rencana tabungan & impian',
              icon: Icons.savings_outlined,
              color: Colors.pinkAccent,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavingsScreen())),
            ),
            _buildMenuCard(
              context,
              title: 'Multi Kas',
              subtitle: 'Kelola banyak buku kas',
              icon: Icons.account_balance_wallet_outlined,
              color: AppColors.accent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih kas melalui header di Beranda!')));
              },
            ),
            
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('PENGATURAN SISTEM'),
            const SizedBox(height: AppSpacing.sm),
            _buildMenuCard(
              context,
              title: 'Keamanan Aplikasi',
              subtitle: 'Proteksi akses dengan PIN',
              icon: Icons.lock_outline_rounded,
              color: AppColors.warning,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PinSetupScreen())),
            ),
            _buildMenuCard(
              context,
              title: 'Pencadangan Data',
              subtitle: 'Backup & restore transaksi',
              icon: Icons.cloud_upload_outlined,
              color: Colors.blueGrey,
              onTap: () {
                final txProvider = context.read<TransactionProvider>();
                BackupExportService.backupData(txProvider.transactions);
              },
            ),
            _buildMenuCard(
              context,
              title: 'Pengaturan App',
              subtitle: 'Kustomisasi, Profil, & Tema',
              icon: Icons.settings_outlined,
              color: Colors.grey,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
            _buildMenuCard(
              context,
              title: 'Tentang Smartkas',
              subtitle: 'Versi & Informasi Aplikasi',
              icon: Icons.info_outline_rounded,
              color: Colors.blue,
              onTap: () => _showAbout(context),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.xs),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppColors.softShadow,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Smartkas',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.wallet_rounded, size: 48, color: AppColors.accent),
      applicationLegalese: '© 2026 Smartkas. All rights reserved.',
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Aplikasi pencatat keuangan offline modern untuk kebutuhan sehari-hari yang dikembangkan dengan Flutter.',
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}
