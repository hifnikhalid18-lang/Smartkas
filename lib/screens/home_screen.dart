import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/banking_balance_card.dart';
import '../widgets/banking_menu_item.dart';
import '../widgets/status_widgets.dart';
import '../providers/settings_provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_selector.dart';
import 'input_screen.dart';
import 'history_screen.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';
import '../utils/app_styles.dart';
import '../widgets/transaction_item.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _selectedFilter = settingsProvider.defaultFilter;
    walletProvider.addListener(_onWalletProviderChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    walletProvider.removeListener(_onWalletProviderChanged);
    super.dispose();
  }

  void _onWalletProviderChanged() {
    if (mounted && walletProvider.activeWallet != null) {
      _loadData();
    }
  }

  void _loadData() {
    if (walletProvider.activeWallet != null) {
      transactionProvider.loadTransactions(walletProvider.activeWallet!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: walletProvider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: ListenableBuilder(
            listenable: transactionProvider,
            builder: (context, _) {
              final balance = transactionProvider.totalBalance;
              final income = transactionProvider.totalIncome;
              final expense = transactionProvider.totalExpense;
              final allTransactions = transactionProvider.transactions;

              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async => transactionProvider.loadTransactions(walletProvider.activeWallet?.id ?? ''),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.md),
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.lg),
                        BankingBalanceCard(
                          balance: CurrencyFormatterHelper.formatRupiah(balance),
                          income: CurrencyFormatterHelper.formatRupiah(income),
                          expense: CurrencyFormatterHelper.formatRupiah(expense),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildActionButtons(),
                        const SizedBox(height: AppSpacing.xl),
                        _buildRecentActivity(allTransactions),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: settingsProvider,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wallet_rounded, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      walletProvider.activeWallet?.name ?? 'Dompet Utama',
                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                  ],
                ),
                Text(
                  'Halo, ${settingsProvider.username}',
                  style: AppTextStyles.title.copyWith(fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            _buildCircleIconButton(
              icon: Icons.notifications_none_rounded,
              onTap: () {
                // Notif placeholder
              },
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildCircleIconButton(
              icon: Icons.settings_outlined,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleIconButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: AppColors.softShadow,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primaryText, size: 22),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildBigButton(
            title: 'Tambah Masuk',
            icon: Icons.add_circle_outline_rounded,
            color: AppColors.success,
            onTap: () => _navigateToInput('Pemasukan'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildBigButton(
            title: 'Tambah Keluar',
            icon: Icons.remove_circle_outline_rounded,
            color: AppColors.error,
            onTap: () => _navigateToInput('Pengeluaran'),
          ),
        ),
      ],
    );
  }

  Widget _buildBigButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<TransactionModel> transactions) {
    final recent = transactions.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Aktivitas Terbaru', style: AppTextStyles.title),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
              child: const Text('Lihat Semua', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SafeDataWrapper(
          isLoading: transactionProvider.isLoading,
          isEmpty: recent.isEmpty,
          emptyMessage: 'Belum ada transaksi',
          emptyIcon: Icons.receipt_long_outlined,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recent.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction: recent[index],
                onDelete: () => _showDeleteDialog(context, recent[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToInput(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputScreen(type: type),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          title: const Text('Hapus Transaksi?'),
          content: const Text('Data yang dihapus tidak bisa dikembalikan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: AppColors.secondaryText)),
            ),
            TextButton(
              onPressed: () {
                transactionProvider.deleteTransaction(transaction);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaksi berhasil dihapus'),
                    backgroundColor: AppColors.primaryText,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

