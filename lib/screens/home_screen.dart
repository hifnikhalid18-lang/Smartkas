import 'package:flutter/material.dart';
import '../widgets/saldo_card.dart';
import '../widgets/menu_card.dart';
import '../widgets/transaction_item.dart';
import 'input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Saldo Total Card Component
            const SaldoCard(amount: 'Rp 0'),
            const SizedBox(height: 24),
            
            // Menu Cards
            Row(
              children: [
                MenuCard(
                  title: '[ + Pemasukan ]',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InputScreen(title: 'Pemasukan')),
                    );
                  },
                ),
                const SizedBox(width: 16),
                MenuCard(
                  title: '[ - Pengeluaran ]',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InputScreen(title: 'Pengeluaran')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // List Transaksi
            const Text(
              'Riwayat Transaksi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  TransactionItem(
                    title: 'Uang Masuk',
                    amount: 'Rp 10.000',
                    date: '01 Mei 2026',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InputScreen(title: 'Tambah Transaksi')),
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
