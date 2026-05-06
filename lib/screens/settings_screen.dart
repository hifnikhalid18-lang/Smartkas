import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/reusable_card.dart';
import '../widgets/reminder_settings_card.dart';
import 'theme_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: settingsProvider.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListenableBuilder(
        listenable: settingsProvider,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('PROFIL'),
                ReusableCard(
                  margin: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nama Pengguna / Kas', style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _usernameController,
                        onChanged: (value) => settingsProvider.setUsername(value),
                        decoration: InputDecoration(
                          hintText: 'Contoh: Kas Keluarga',
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.roundedMd,
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                _buildSectionTitle('PREFERENSI'),
                ReusableCard(
                  margin: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Filter Default Beranda', style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.md),
                      _buildFilterSelector(),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
                _buildSectionTitle('TAMPILAN'),
                ReusableCard(
                  margin: const EdgeInsets.only(top: AppSpacing.sm),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ThemeSettingsScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.palette_rounded, color: AppColors.accent),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tema Aplikasi', style: AppTextStyles.body),
                            Text('Terang, Gelap, atau Sistem', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
                _buildSectionTitle('PENGINGAT'),
                const ReminderSettingsCard(),

                const SizedBox(height: AppSpacing.xl),
                _buildSectionTitle('ZONA BERBAHAYA'),
                ReusableCard(
                  margin: const EdgeInsets.only(top: AppSpacing.sm),
                  color: AppColors.error.withOpacity(0.05),
                  onTap: () => _showResetDialog(context),
                  child: Row(
                    children: [
                      const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'RESET SEMUA DATA',
                        style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.error),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildFilterSelector() {
    final filters = ['Semua', 'Pemasukan', 'Pengeluaran'];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.roundedMd,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: filters.map((filter) {
          final isSelected = settingsProvider.defaultFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => settingsProvider.setDefaultFilter(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.secondaryText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        title: const Text('Reset Data?'),
        content: const Text('Tindakan ini akan menghapus seluruh transaksi secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              transactionProvider.clearAllTransactions();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil direset'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Reset', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
