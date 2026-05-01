import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/saldo_card.dart';
import '../widgets/menu_card.dart';
import '../widgets/transaction_item.dart';
import 'input_screen.dart';
import 'history_screen.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Semua';

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
          final balance = transactionProvider.totalBalance;
          
          // Filter logic
          final allTransactions = transactionProvider.transactions;
          final filteredTransactions = allTransactions.where((tx) {
            if (_selectedFilter == 'Semua') return true;
            if (_selectedFilter == 'Pemasukan') return tx.type == TransactionType.pemasukan;
            if (_selectedFilter == 'Pengeluaran') return tx.type == TransactionType.pengeluaran;
            return true;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SaldoCard(balance: currencyFormat.format(balance)),
                const SizedBox(height: 16),
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
                
                // Filter UI
                Row(
                  children: [
                    const Text(
                      'Riwayat',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_new, size: 20, color: Colors.black),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pemasukan'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pengeluaran'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Daftar Transaksi Dinamis & Terfilter
                Expanded(
                  child: filteredTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 80,
                                color: Colors.black26,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Belum ada transaksi',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Klik tombol + untuk menambah',
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
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
