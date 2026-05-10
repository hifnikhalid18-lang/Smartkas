import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/banking_balance_card.dart';
import '../widgets/borderless_icon_button.dart';
import '../widgets/status_widgets.dart';
import '../providers/settings_provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_selector.dart';
import 'input_screen.dart';
import 'history_screen.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';
import '../utils/app_styles.dart';
import '../widgets/transaction_item.dart';
import 'settings_screen.dart';
import '../providers/navigation_provider.dart';

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
                bottom: false,
                child: RefreshIndicator(
                  onRefresh: () async => transactionProvider.loadTransactions(walletProvider.activeWallet?.id ?? ''),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
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
                              _buildQuickActionGrid(),
                              const SizedBox(height: AppSpacing.xl),
                              _buildMiniInsight(),
                              const SizedBox(height: AppSpacing.xl),
                            ],
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildPullUpDrawer(allTransactions),
                      ),
                    ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: settingsProvider,
              builder: (context, _) => Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.accent.withOpacity(0.1),
                    child: const Icon(Icons.person_rounded, color: AppColors.accent, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo,',
                          style: AppTextStyles.caption.copyWith(fontSize: 12),
                        ),
                        Text(
                          settingsProvider.username,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Row(
            children: [
              const WalletSelector(),
              const SizedBox(width: AppSpacing.xs),
              _buildCircleIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildQuickActionGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Action', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 2.2,
          children: [
            _buildActionCard(
              title: 'Tambah Masuk',
              icon: Icons.add_circle_outline_rounded,
              color: AppColors.success,
              onTap: () => _navigateToInput('Pemasukan'),
            ),
            _buildActionCard(
              title: 'Tambah Keluar',
              icon: Icons.remove_circle_outline_rounded,
              color: AppColors.error,
              onTap: () => _navigateToInput('Pengeluaran'),
            ),
            _buildActionCard(
              title: 'Transfer',
              icon: Icons.sync_alt_rounded,
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur Transfer akan segera hadir!')));
              },
            ),
            _buildActionCard(
              title: 'Laporan',
              icon: Icons.bar_chart_rounded,
              color: Colors.purple,
              onTap: () {
                navigationProvider.setIndex(2);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInsight() {
    final summaries = transactionProvider.categoryExpenseSummaries;
    String topCategory = summaries.isNotEmpty ? summaries.keys.first : 'Belum ada data';
    double amount = summaries.isNotEmpty ? summaries.values.first : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: AppColors.accent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              const Text('Insight Mini', style: AppTextStyles.subtitle),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pengeluaran terbesar:', style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text(topCategory, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              if (summaries.isNotEmpty)
                Text(
                  CurrencyFormatterHelper.formatRupiah(amount),
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.error),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPullUpDrawer(List<TransactionModel> transactions) {
    final recent = transactions.take(10).toList(); 

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
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
          const SizedBox(height: AppSpacing.md),
          SafeDataWrapper(
            isLoading: transactionProvider.isLoading,
            isEmpty: recent.isEmpty,
            emptyMessage: 'Belum ada transaksi.\nYuk, mulai catat pengeluaran pertamamu!',
            emptyIcon: Icons.wallet_rounded,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                return TransactionItem(
                  transaction: recent[index],
                  onDelete: () => _showDeleteDialog(context, recent[index]),
                );
              },
            ),
          ),
        ],
      ),
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

