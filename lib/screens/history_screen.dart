import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_item.dart';
import '../widgets/status_widgets.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';
import '../services/backup_export_service.dart';
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showDataManagement(context),
            icon: const Icon(Icons.settings, color: Colors.black),
            tooltip: 'Manajemen Data',
          ),
          IconButton(
            onPressed: () => _showResetDialog(context),
            icon: const Icon(Icons.refresh, color: Colors.black),
            tooltip: 'Reset Semua Data',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
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
                   tx.amount.toString().contains(query);
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari keterangan atau nominal...',
                    hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.zero,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black),
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
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('TOTAL SALDO', CurrencyFormatterHelper.formatRupiah(balance), isBold: true),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(color: Colors.black, thickness: 1),
                      ),
                      _buildSummaryRow('Pemasukan', CurrencyFormatterHelper.formatRupiah(income)),
                      const SizedBox(height: 6),
                      _buildSummaryRow('Pengeluaran', CurrencyFormatterHelper.formatRupiah(expense)),
                    ],
                  ),
                ),
              ),
              
              Container(height: 1, color: Colors.black12),
              
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: dateKeys.length,
                    itemBuilder: (context, index) {
                      final dateKey = dateKeys[index];
                      final items = groupedTransactions[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    dateKey,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(indent: 8, color: Colors.black12)),
                              ],
                            ),
                          ),
                          ...items.map((transaction) {
                            return TransactionItem(
                              title: transaction.title,
                              amount: CurrencyFormatterHelper.formatRupiah(transaction.amount),
                              date: DateFormat('HH:mm').format(transaction.date),
                              onDelete: () => _showDeleteDialog(context, transaction),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InputScreen(
                                      type: transaction.type == TransactionType.pemasukan ? 'Pemasukan' : 'Pengeluaran',
                                      transactionToEdit: transaction,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                          const SizedBox(height: 8),
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
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? Colors.black : Colors.black54,
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            letterSpacing: isBold ? 1.0 : 0.0,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 18 : 15,
          ),
        ),
      ],
    );
  }

  void _showDataManagement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'MANAJEMEN DATA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
              ),
              const SizedBox(height: 24),
              _buildDataButton(
                context, 
                'Backup Data (JSON)', 
                Icons.backup_outlined, 
                () => BackupExportService.backupData(transactionProvider.transactions)
              ),
              const SizedBox(height: 12),
              _buildDataButton(
                context, 
                'Restore Data (JSON)', 
                Icons.restore_outlined, 
                () async {
                  bool success = await BackupExportService.restoreData();
                  if (success && mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data berhasil direstore!'), backgroundColor: Colors.black),
                    );
                  }
                }
              ),
              const SizedBox(height: 12),
              _buildDataButton(
                context, 
                'Ekspor Data (CSV)', 
                Icons.description_outlined, 
                () => BackupExportService.exportToCSV(transactionProvider.transactions)
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.zero,
          ),
          title: const Text(
            'Hapus Transaksi?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Data yang dihapus tidak bisa dikembalikan.',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () {
                transactionProvider.deleteTransaction(transaction);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaksi berhasil dihapus'),
                    backgroundColor: Colors.black,
                  ),
                );
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.zero,
          ),
          title: const Text(
            'Reset Semua Data?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Tindakan ini akan menghapus SELURUH transaksi dan mengembalikan saldo ke Rp 0. Apakah Anda yakin?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () {
                transactionProvider.clearAllTransactions();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Seluruh data berhasil dihapus'),
                    backgroundColor: Colors.black,
                  ),
                );
              },
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
