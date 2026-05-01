import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/saldo_card.dart';
import '../widgets/menu_card.dart';
import '../widgets/transaction_item.dart';
import 'input_screen.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Beranda',
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Komponen Saldo Otomatis
                SaldoCard(balance: currencyFormat.format(balance)),
                const SizedBox(height: 16),
                // Baris Menu
                Row(
                  children: [
                    MenuCard(
                      title: 'Pemasukan',
                      icon: Icons.add_circle_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputScreen(type: 'Pemasukan'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    MenuCard(
                      title: 'Pengeluaran',
                      icon: Icons.remove_circle_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputScreen(type: 'Pengeluaran'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Judul Riwayat
                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Daftar Transaksi Dinamis
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada transaksi',
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return TransactionItem(
                              title: transaction.title,
                              amount: currencyFormat.format(transaction.amount),
                              date: DateFormat('dd MMM yyyy').format(transaction.date),
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
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InputScreen(type: 'Transaksi'),
            ),
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 32),
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
