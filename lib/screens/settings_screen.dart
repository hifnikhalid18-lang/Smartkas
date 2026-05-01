import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';
import '../providers/transaction_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: settingsProvider.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
          'Pengaturan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 1.0),
        ),
      ),
      body: ListenableBuilder(
        listenable: settingsProvider,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 3. Username Input
                const Text(
                  'NAMA PENGGUNA / KAS',
                  style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _usernameController,
                  onChanged: (value) => settingsProvider.setUsername(value),
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Kas Keluarga',
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.zero),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5), borderRadius: BorderRadius.zero),
                  ),
                ),
                const SizedBox(height: 32),

                // 2. Default Filter Selector
                const Text(
                  'FILTER DEFAULT BERANDA',
                  style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
                _buildFilterSelector(),
                const SizedBox(height: 48),

                // 1. Reset Data Button
                const Text(
                  'ZONA BERHAYA',
                  style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _showResetDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'RESET SEMUA DATA',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSelector() {
    final filters = ['Semua', 'Pemasukan', 'Pengeluaran'];
    return Row(
      children: filters.map((filter) {
        final isSelected = settingsProvider.defaultFilter == filter;
        return Expanded(
          child: InkWell(
            onTap: () => settingsProvider.setDefaultFilter(filter),
            child: Container(
              margin: EdgeInsets.only(right: filter == 'Pengeluaran' ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.zero),
        title: const Text('Reset Data?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Tindakan ini akan menghapus seluruh transaksi secara permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(color: Colors.black54))),
          TextButton(
            onPressed: () {
              transactionProvider.clearAllTransactions();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil direset'), backgroundColor: Colors.black),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
