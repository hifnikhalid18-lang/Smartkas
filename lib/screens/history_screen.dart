import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';
import 'input_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
          final transactions = transactionProvider.transactions;
          final balance = transactionProvider.totalBalance;
          final income = transactionProvider.totalIncome;
          final expense = transactionProvider.totalExpense;

          // Grouping logic
          final Map<String, List<TransactionModel>> groupedTransactions = {};
          for (var tx in transactions) {
            final dateKey = DateFormat('dd MMMM yyyy').format(tx.date);
            if (!groupedTransactions.containsKey(dateKey)) {
              groupedTransactions[dateKey] = [];
            }
            groupedTransactions[dateKey]!.add(tx);
          }

          final dateKeys = groupedTransactions.keys.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ringkasan Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Total Saldo', currencyFormat.format(balance), isBold: true),
                      const Divider(color: Colors.black),
                      _buildSummaryRow('Total Pemasukan', currencyFormat.format(income)),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Total Pengeluaran', currencyFormat.format(expense)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Daftar Terkelompok
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(
                          child: Text('Belum ada transaksi'),
                        )
                      : ListView.builder(
                          itemCount: dateKeys.length,
                          itemBuilder: (context, index) {
                            final dateKey = dateKeys[index];
                            final items = groupedTransactions[dateKey]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Tanggal
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: Text(
                                      dateKey,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Daftar Item untuk tanggal tersebut
                                ...items.map((transaction) {
                                  return TransactionItem(
                                    title: transaction.title,
                                    amount: currencyFormat.format(transaction.amount),
                                    date: DateFormat('HH:mm').format(transaction.date), // Tampilkan jam saja karena tanggal sudah di header
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
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
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
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
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
}
