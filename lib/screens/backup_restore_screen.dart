import 'package:flutter/material.dart';
import '../services/backup_export_service.dart';
import '../providers/transaction_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/reusable_card.dart';

class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Keamanan & Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader('BACKUP & RESTORE', Icons.cloud_done_rounded),
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              'Master Backup (Semua Data)',
              'Cadangkan semua kas, transaksi, hutang, dan target ke file JSON.',
              Icons.backup_rounded,
              Colors.blue,
              () => BackupExportService.masterBackup(),
            ),
            _buildActionCard(
              context,
              'Pulihkan Data (Master Restore)',
              'Impor data dari file backup JSON sebelumnya.',
              Icons.settings_backup_restore_rounded,
              AppColors.warning,
              () async {
                bool success = await BackupExportService.masterRestore();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil dipulihkan! Silakan restart aplikasi.'), behavior: SnackBarBehavior.floating),
                  );
                }
              },
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader('EKSPOR LAPORAN', Icons.description_rounded),
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              'Ekspor PDF (Buku Kas Aktif)',
              'Download laporan dalam format dokumen PDF rapi.',
              Icons.picture_as_pdf_rounded,
              Colors.redAccent,
              () => BackupExportService.exportToPDF(
                transactionProvider.transactions, 
                walletProvider.activeWallet?.name ?? 'Utama'
              ),
            ),
            _buildActionCard(
              context,
              'Ekspor Excel (Buku Kas Aktif)',
              'Download laporan dalam format tabel Excel (.xlsx).',
              Icons.table_view_rounded,
              Colors.green,
              () => BackupExportService.exportToExcel(
                transactionProvider.transactions, 
                walletProvider.activeWallet?.name ?? 'Utama'
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              'Catatan: Data Anda disimpan secara lokal di perangkat ini. Lakukan backup secara rutin untuk menghindari kehilangan data.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ReusableCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
      ),
    );
  }
}
