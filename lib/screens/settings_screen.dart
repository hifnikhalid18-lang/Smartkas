import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/debt_provider.dart';
import '../providers/savings_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/reusable_card.dart';
import '../widgets/reminder_settings_card.dart';
import 'theme_settings_screen.dart';
import 'pin_setup_screen.dart';
import '../providers/security_provider.dart';

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
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Contoh: Kas Keluarga',
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
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
                _buildSectionTitle('KEAMANAN'),
                ListenableBuilder(
                  listenable: securityProvider,
                  builder: (context, _) {
                    return Column(
                      children: [
                        ReusableCard(
                          margin: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Row(
                            children: [
                              const Icon(Icons.security_rounded, color: AppColors.accent),
                              const SizedBox(width: AppSpacing.md),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kunci PIN', style: AppTextStyles.body),
                                    Text('Minta PIN saat buka aplikasi', style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                              Switch(
                                value: securityProvider.pinEnabled,
                                onChanged: (value) {
                                  if (value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const PinSetupScreen()),
                                    );
                                  } else {
                                    securityProvider.togglePIN(false, '');
                                  }
                                },
                                activeColor: AppColors.accent,
                              ),
                            ],
                          ),
                        ),
                        if (securityProvider.pinEnabled) ...[
                          const SizedBox(height: AppSpacing.md),
                          ReusableCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PinSetupScreen(isChanging: true)),
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.lock_reset_rounded, color: AppColors.secondaryText),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text('Ubah PIN Keamanan', style: AppTextStyles.body),
                                ),
                                Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
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
      builder: (context) => SimpleDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        title: const Text('Pilih Opsi Reset'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _confirmReset(context, 'Hapus Transaksi Saja?', 'Hanya data transaksi yang akan dihapus.', () {
                transactionProvider.clearAllTransactions();
              });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Hapus Transaksi Saja', style: AppTextStyles.body),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _confirmReset(context, 'Reset Seluruh Data?', 'Semua transaksi, hutang, dan tabungan akan dihapus secara permanen.', () {
                transactionProvider.clearAllTransactions();
                // Add methods to clear debt and savings if they exist
                // Assuming we can just delete one by one or clear list
                for (var debt in debtProvider.debts.toList()) {
                  debtProvider.deleteDebt(debt.id);
                }
                for (var goal in savingsProvider.goals.toList()) {
                  savingsProvider.deleteGoal(goal.id);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Reset Seluruh Data', style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
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
