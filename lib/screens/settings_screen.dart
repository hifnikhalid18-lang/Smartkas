import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/debt_provider.dart';
import '../providers/savings_provider.dart';
import '../utils/app_styles.dart';
import 'theme_settings_screen.dart';
import '../widgets/startup_background.dart';
import 'pin_setup_screen.dart';
import '../providers/security_provider.dart';
import '../screens/backup_restore_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: settingsProvider.username);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pengaturan', style: AppTextStyles.title.copyWith(fontSize: 17)),
      ),
      body: StartupBackground(
        child: ListenableBuilder(
          listenable: Listenable.merge([settingsProvider, securityProvider]),
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profil ────────────────────────────────────────────────
                _sectionHeader('Profil'),
                _settingsGroup([
                  _buildNameTile(),
                ]),

                // ── Tampilan ──────────────────────────────────────────────
                _sectionHeader('Tampilan'),
                _settingsGroup([
                  _buildNavTile(
                    icon: Icons.palette_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Tema Aplikasi',
                    subtitle: 'Terang, Gelap, atau Sistem',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemeSettingsScreen())),
                  ),
                ]),

                // ── Keamanan ──────────────────────────────────────────────
                _sectionHeader('Keamanan'),
                _settingsGroup([
                  _buildToggleTile(
                    icon: Icons.lock_outline_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                    title: 'Kunci PIN',
                    subtitle: 'Minta PIN saat buka aplikasi',
                    value: securityProvider.pinEnabled,
                    onChanged: (v) {
                      if (v) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PinSetupScreen()));
                      } else {
                        securityProvider.togglePIN(false, '');
                      }
                    },
                  ),
                  if (securityProvider.pinEnabled) ...[
                    const _SettingsDivider(),
                    _buildNavTile(
                      icon: Icons.lock_reset_rounded,
                      iconColor: const Color(0xFF0EA5E9),
                      title: 'Ubah PIN',
                      subtitle: 'Ganti kode keamanan',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PinSetupScreen(isChanging: true))),
                    ),
                  ],
                ]),

                // ── Backup & Data ─────────────────────────────────────────
                _sectionHeader('Data'),
                _settingsGroup([
                  _buildNavTile(
                    icon: Icons.cloud_upload_outlined,
                    iconColor: const Color(0xFF10B981),
                    title: 'Backup & Restore',
                    subtitle: 'Ekspor atau impor data',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupRestoreScreen())),
                  ),
                ]),

                // ── Filter default ────────────────────────────────────────
                _sectionHeader('Preferensi'),
                _settingsGroup([
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Filter Default Beranda', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Tampilkan transaksi ini saat buka aplikasi', style: AppTextStyles.micro),
                        const SizedBox(height: 12),
                        _buildFilterSelector(),
                      ],
                    ),
                  ),
                ]),

                // ── Danger ────────────────────────────────────────────────
                _sectionHeader('Zona Berbahaya'),
                _settingsGroup([
                  ListTile(
                    onTap: () => _showResetDialog(context),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 18),
                    ),
                    title: Text('Reset Semua Data', style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
                    subtitle: Text('Hapus semua transaksi dan catatan', style: AppTextStyles.micro),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error, size: 18),
                  ),
                ]),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      ),
    );
  }

  // ── Section & Group Helpers ───────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 20, AppSpacing.md, 6),
      child: Text(title.toUpperCase(), style: AppTextStyles.sectionLabel),
    );
  }

  Widget _settingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.softShadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }

  // ── Tile Types ────────────────────────────────────────────────────────────
  Widget _buildNameTile() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person_outline_rounded, color: Color(0xFFF59E0B), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Kas / Pengguna', style: AppTextStyles.micro),
                TextField(
                  controller: _nameCtrl,
                  onChanged: (v) => settingsProvider.setUsername(v),
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Masukkan nama',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTextStyles.micro),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 18),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTextStyles.micro),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
      ),
    );
  }

  Widget _buildFilterSelector() {
    final filters = ['Semua', 'Pemasukan', 'Pengeluaran'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(40)),
      child: Row(
        children: filters.map((f) {
          final isSel = settingsProvider.defaultFilter == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => settingsProvider.setDefaultFilter(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: isSel ? AppColors.softShadow : [],
                ),
                child: Center(
                  child: Text(
                    f,
                    style: TextStyle(
                      color: isSel ? AppColors.primaryText : AppColors.muted,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
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

  // ── Reset Dialog ──────────────────────────────────────────────────────────
  void _showResetDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Pilih Opsi Reset', style: AppTextStyles.title.copyWith(fontSize: 16)),
            const SizedBox(height: 16),
            _resetOption(ctx, 'Hapus Transaksi Saja', Icons.receipt_long_outlined, AppColors.warning, () {
              transactionProvider.clearAllTransactions();
            }),
            const SizedBox(height: 10),
            _resetOption(ctx, 'Reset Seluruh Data', Icons.delete_forever_rounded, AppColors.error, () {
              transactionProvider.clearAllTransactions();
              for (var d in debtProvider.debts.toList()) debtProvider.deleteDebt(d.id);
              for (var g in savingsProvider.goals.toList()) savingsProvider.deleteGoal(g.id);
            }),
          ],
        ),
      ),
    );
  }

  Widget _resetOption(BuildContext ctx, String label, IconData icon, Color color, VoidCallback action) {
    return ListTile(
      onTap: () {
        Navigator.pop(ctx);
        _confirmReset(label, action);
      },
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label, style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.muted),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _confirmReset(String title, VoidCallback action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              action();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data berhasil direset.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Reset', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 64, color: AppColors.hairline);
  }
}
