import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_item.dart';
import '../widgets/status_widgets.dart';
import '../widgets/reusable_card.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';
import '../utils/app_styles.dart';
import '../services/backup_export_service.dart';
import '../widgets/wallet_selector.dart';
import '../providers/wallet_provider.dart';
import 'input_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load transactions if needed (though usually handled by home)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (walletProvider.activeWallet != null) {
        transactionProvider.loadTransactions(walletProvider.activeWallet!.id);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: walletProvider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Riwayat'),
            actions: [
              const WalletSelector(),
              IconButton(
                onPressed: () => _showDataManagement(context),
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Manajemen Data',
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: ListenableBuilder(
        listenable: transactionProvider,
        builder: (context, _) {
          final allTransactions = transactionProvider.transactions;
          final balance = transactionProvider.totalBalance;
          final income = transactionProvider.totalIncome;
          final expense = transactionProvider.totalExpense;

          final filteredTransactions = allTransactions.where((tx) {
            final query = _searchQuery.toLowerCase();
            return tx.title.toLowerCase().contains(query) ||
                   tx.amount.toString().contains(query) ||
                   tx.category.toLowerCase().contains(query) ||
                   tx.type.name.toLowerCase().contains(query);
          }).toList();

          final Map<String, List<TransactionModel>> groupedTransactions = {};
          for (var tx in filteredTransactions) {
            final dateKey = DateFormat('dd MMMM yyyy').format(tx.date);
            if (!groupedTransactions.containsKey(dateKey)) {
              groupedTransactions[dateKey] = [];
            }
            groupedTransactions[dateKey]!.add(tx);
          }

          final dateKeys = groupedTransactions.keys.toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari transaksi...',
                    hintStyle: AppTextStyles.caption.copyWith(color: AppColors.secondaryText.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondaryText),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      borderRadius: AppRadius.roundedMd,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                      borderRadius: AppRadius.roundedMd,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: AppColors.secondaryText),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ) 
                      : null,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ReusableCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      _buildSummaryRow('TOTAL SALDO', CurrencyFormatterHelper.formatRupiah(balance), isBold: true),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Divider(color: AppColors.border, thickness: 0.5),
                      ),
                      _buildSummaryRow('Pemasukan', CurrencyFormatterHelper.formatRupiah(income), color: AppColors.success),
                      const SizedBox(height: 6),
                      _buildSummaryRow('Pengeluaran', CurrencyFormatterHelper.formatRupiah(expense), color: AppColors.error),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              Expanded(
                child: SafeDataWrapper(
                  isLoading: transactionProvider.isLoading,
                  isEmpty: filteredTransactions.isEmpty,
                  emptyMessage: _searchQuery.isEmpty 
                      ? 'Belum ada riwayat transaksi' 
                      : 'Hasil pencarian tidak ditemukan',
                  emptyIcon: _searchQuery.isEmpty 
                      ? Icons.history_toggle_off 
                      : Icons.search_off,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    physics: const BouncingScrollPhysics(),
                    itemCount: dateKeys.length,
                    itemBuilder: (context, index) {
                      final dateKey = dateKeys[index];
                      final items = groupedTransactions[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            child: Row(
                              children: [
                                Text(
                                  dateKey,
                                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Expanded(child: Divider(indent: AppSpacing.sm, color: AppColors.border)),
                              ],
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, i) {
                              final tx = items[i];
                              return TransactionItem(
                                transaction: tx,
                                onDelete: () => _showDeleteDialog(context, tx),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InputScreen(
                                        type: tx.type == TransactionType.pemasukan ? 'Pemasukan' : 'Pengeluaran',
                                        transactionToEdit: tx,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  },
);
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 18 : 14,
            color: color ?? AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  void _showDataManagement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MANAJEMEN DATA',
                style: AppTextStyles.title.copyWith(letterSpacing: 1.2),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildDataButton(
                context, 
                'Backup Data (JSON)', 
                Icons.backup_rounded, 
                () => BackupExportService.backupData(transactionProvider.transactions)
              ),
              const SizedBox(height: AppSpacing.md),
              _buildDataButton(
                context, 
                'Restore Data (JSON)', 
                Icons.restore_rounded, 
                () async {
                  bool success = await BackupExportService.restoreData();
                  if (success && mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data berhasil direstore!'), behavior: SnackBarBehavior.floating),
                    );
                  }
                }
              ),
              const SizedBox(height: AppSpacing.md),
              _buildDataButton(
                context, 
                'Ekspor Data (CSV)', 
                Icons.description_rounded, 
                () => BackupExportService.exportToCSV(transactionProvider.transactions)
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ReusableCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
        ],
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
