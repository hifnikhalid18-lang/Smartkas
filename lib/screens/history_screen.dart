import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_item.dart';
import '../widgets/status_widgets.dart';
import '../widgets/reusable_card.dart';

import '../widgets/startup_background.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';
import '../utils/app_styles.dart';
import '../utils/snackbar_helper.dart';
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
          appBar: AppBar(
            title: const Text('Riwayat Transaksi'),
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
          body: StartupBackground(
            child: ListenableBuilder(
              listenable: transactionProvider,
              builder: (context, _) {
                final allTransactions = transactionProvider.transactions;
                final balance = transactionProvider.totalBalance;
                final income = transactionProvider.totalIncome;
                final expense = transactionProvider.totalExpense;

                final filteredTransactions = transactionProvider.filteredTransactions.where((tx) {
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => setState(() => _searchQuery = value),
                              decoration: InputDecoration(
                                hintText: 'Cari transaksi...',
                                hintStyle: AppTextStyles.caption.copyWith(color: AppColors.secondaryText.withOpacity(0.5)),
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondaryText),
                                filled: true,
                                fillColor: AppColors.surface,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
                                  borderRadius: AppRadius.roundedMd,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                                  borderRadius: AppRadius.roundedMd,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buildCalendarButton(),
                        ],
                      ),
                    ),

                    _buildFilterChips(),
                    const SizedBox(height: AppSpacing.md),

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
                      child: filteredTransactions.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_searchQuery.isEmpty ? Icons.receipt_long_outlined : Icons.search_off, size: 48, color: AppColors.muted),
                                const SizedBox(height: 12),
                                Text(_searchQuery.isEmpty ? 'Belum ada riwayat transaksi' : 'Hasil pencarian tidak ditemukan', style: AppTextStyles.caption),
                              ],
                            ),
                          )
                        : ListView.builder(
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
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppColors.softShadow,
      ),
      child: IconButton(
        icon: const Icon(Icons.calendar_month_rounded, color: AppColors.accent),
        onPressed: () {
          SnackbarHelper.showInfo(context, 'Pilih tanggal dari Kalender Transaksi...');
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: filters.map((filter) {
          final isSelected = transactionProvider.statPeriod == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => transactionProvider.setStatPeriod(filter),
              selectedColor: AppColors.accent,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.secondaryText,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? AppColors.accent : AppColors.border.withOpacity(0.5)),
              ),
            ),
          );
        }).toList(),
      ),
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
                'KEAMANAN & DATA',
                style: AppTextStyles.title.copyWith(letterSpacing: 1.2),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildDataButton(
                context, 
                'Master Backup (JSON)', 
                Icons.backup_rounded, 
                () => BackupExportService.masterBackup()
              ),
              const SizedBox(height: AppSpacing.md),
              _buildDataButton(
                context, 
                'Pulihkan Data (JSON)', 
                Icons.restore_rounded, 
                () async {
                  bool success = await BackupExportService.masterRestore();
                  if (success && mounted) {
                    Navigator.pop(context);
                    SnackbarHelper.showSuccess(context, 'Data berhasil dipulihkan!');
                  }
                }
              ),
              const SizedBox(height: AppSpacing.md),
              _buildDataButton(
                context, 
                'Ekspor Laporan (Excel)', 
                Icons.description_rounded, 
                () => BackupExportService.exportToExcel(transactionProvider.transactions, walletProvider.activeWallet?.name ?? 'Kas')
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
                SnackbarHelper.showSuccess(context, 'Transaksi berhasil dihapus');
              },
              child: const Text('Hapus', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

}
