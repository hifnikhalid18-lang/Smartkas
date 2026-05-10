import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../providers/wallet_provider.dart';
import '../screens/history_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/debt_screen.dart';
import '../screens/savings_screen.dart';
import '../screens/wallet_management_screen.dart';
import '../screens/backup_restore_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/about_screen.dart';
import '../screens/calendar_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 0,
      width: MediaQuery.of(context).size.width * 0.78,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _sectionLabel('Keuangan'),
                _item(context, icon: Icons.history_rounded,                 iconColor: const Color(0xFF6366F1), title: 'Semua Transaksi',   route: const HistoryScreen()),
                _item(context, icon: Icons.bar_chart_rounded,               iconColor: const Color(0xFF10B981), title: 'Laporan',            route: const StatisticsScreen()),
                _item(context, icon: Icons.people_outline_rounded,          iconColor: const Color(0xFFF59E0B), title: 'Hutang Piutang',     route: const DebtScreen()),
                _item(context, icon: Icons.savings_outlined,                iconColor: const Color(0xFF0EA5E9), title: 'Target Menabung',    route: const SavingsScreen()),
                _item(context, icon: Icons.calendar_month_rounded,          iconColor: const Color(0xFF8B5CF6), title: 'Kalender',          route: const CalendarScreen()),
                _sectionLabel('Pengaturan'),
                _item(context, icon: Icons.account_balance_wallet_outlined, iconColor: const Color(0xFF10B981), title: 'Kelola Kas',         route: const WalletManagementScreen()),
                _item(context, icon: Icons.cloud_done_outlined,             iconColor: const Color(0xFF0EA5E9), title: 'Backup & Restore',   route: const BackupRestoreScreen()),
                _item(context, icon: Icons.settings_outlined,               iconColor: AppColors.muted,         title: 'Pengaturan',         route: const SettingsScreen()),
                _sectionLabel('Info'),
                _item(context, icon: Icons.info_outline_rounded,            iconColor: AppColors.muted,         title: 'Tentang Smartkas',   route: const AboutScreen()),
                const SizedBox(height: 20),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return ListenableBuilder(
      listenable: walletProvider,
      builder: (_, __) {
        final wallet = walletProvider.activeWallet?.name ?? 'Smartkas';
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(gradient: AppGradients.balanceCard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.wallet_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 16),
              const Text(
                'SMARTKAS',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                wallet,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Section Label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
      child: Text(label.toUpperCase(), style: AppTextStyles.sectionLabel),
    );
  }

  // ── Menu Item ─────────────────────────────────────────────────────────────
  Widget _item(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget route,
  }) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => route));
      },
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 17),
      ),
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500, fontSize: 14)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Text('Smartkas v1.0.0', style: AppTextStyles.micro),
    );
  }
}
