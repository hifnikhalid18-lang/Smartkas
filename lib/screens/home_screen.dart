import 'package:flutter/material.dart';
import '../widgets/summary_cards.dart';
import '../widgets/menu_card.dart';
import '../widgets/filter_widgets.dart';
import '../widgets/status_widgets.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/settings_provider.dart';
import 'input_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';
import '../utils/app_styles.dart';
import '../widgets/transaction_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _selectedFilter = settingsProvider.defaultFilter;
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: ListenableBuilder(
          listenable: settingsProvider,
          builder: (context, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo,',
                style: AppTextStyles.caption.copyWith(fontSize: 14),
              ),
              Text(
                settingsProvider.username,
                style: AppTextStyles.title,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListenableBuilder(
        listenable: transactionProvider,
        builder: (context, _) {
          final balance = transactionProvider.totalBalance;
          final income = transactionProvider.totalIncome;
          final expense = transactionProvider.totalExpense;
          
          final allTransactions = transactionProvider.transactions;
          final filteredTransactions = allTransactions.where((tx) {
            if (_selectedFilter == 'Semua') return true;
            if (_selectedFilter == 'Pemasukan') return tx.type == TransactionType.pemasukan;
            if (_selectedFilter == 'Pengeluaran') return tx.type == TransactionType.pengeluaran;
            return true;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async => transactionProvider.loadTransactions(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SaldoSummaryCard(balance: CurrencyFormatterHelper.formatRupiah(balance)),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      IncomeSummaryCard(amount: CurrencyFormatterHelper.formatRupiah(income)),
                      const SizedBox(width: AppSpacing.md),
                      ExpenseSummaryCard(amount: CurrencyFormatterHelper.formatRupiah(expense)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text('Menu Cepat', style: AppTextStyles.title.copyWith(fontSize: 18)),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: MenuCard(
                          title: 'Tambah Masuk',
                          icon: Icons.add_rounded,
                          onTap: () => _navigateToInput('Pemasukan'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: MenuCard(
                          title: 'Tambah Keluar',
                          icon: Icons.remove_rounded,
                          onTap: () => _navigateToInput('Pengeluaran'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transaksi Terakhir', style: AppTextStyles.title.copyWith(fontSize: 18)),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                        child: const Text('Lihat Semua', style: TextStyle(color: AppColors.accent)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.sm),
                  SafeDataWrapper(
                    isLoading: transactionProvider.isLoading,
                    isEmpty: filteredTransactions.isEmpty,
                    emptyMessage: 'Belum ada transaksi',
                    emptyIcon: Icons.receipt_long_outlined,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length > 5 ? 5 : filteredTransactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final tx = filteredTransactions[index];
                        return TransactionItem(
                          transaction: tx,
                          onDelete: () => _showDeleteDialog(context, tx),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToInput('Transaksi'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 32),
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
