import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class InputScreen extends StatefulWidget {
  final String type;
  final TransactionModel? transactionToEdit;

  const InputScreen({
    super.key,
    required this.type,
    this.transactionToEdit,
  });

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late TextEditingController _nominalController;
  late TextEditingController _keteranganController;
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();
    _nominalController = TextEditingController(
      text: widget.transactionToEdit?.amount.toStringAsFixed(0) ?? '',
    );
    _keteranganController = TextEditingController(
      text: widget.transactionToEdit?.title ?? '',
    );
    _selectedType = widget.transactionToEdit?.type ??
        (widget.type == 'Pemasukan'
            ? TransactionType.pemasukan
            : TransactionType.pengeluaran);
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  void _simpan() {
    final String nominalText = _nominalController.text.trim();
    final String keterangan = _keteranganController.text.trim();

    if (nominalText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal tidak boleh kosong')),
      );
      return;
    }

    final double? nominal = double.tryParse(nominalText);
    if (nominal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal harus berupa angka')),
      );
      return;
    }

    final String finalKeterangan = keterangan.isEmpty ? 'Tanpa keterangan' : keterangan;

    if (widget.transactionToEdit != null) {
      // Logic Update
      final updatedTransaction = TransactionModel(
        id: widget.transactionToEdit!.id,
        title: finalKeterangan,
        amount: nominal,
        date: widget.transactionToEdit!.date,
        type: _selectedType,
      );
      transactionProvider.updateTransaction(updatedTransaction);
    } else {
      // Logic Tambah Baru
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: finalKeterangan,
        amount: nominal,
        date: DateTime.now(),
        type: _selectedType,
      );
      transactionProvider.addTransaction(transaction);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionToEdit != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isEditing ? 'Edit ${widget.type}' : 'Input ${widget.type}',
          style: const TextStyle(
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
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tipe Transaksi:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedType = TransactionType.pemasukan),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedType == TransactionType.pemasukan ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'Pemasukan',
                            style: TextStyle(
                              color: _selectedType == TransactionType.pemasukan ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedType = TransactionType.pengeluaran),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedType == TransactionType.pengeluaran ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'Pengeluaran',
                            style: TextStyle(
                              color: _selectedType == TransactionType.pengeluaran ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Nominal:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Masukkan nominal',
                  hintStyle: TextStyle(color: Colors.black26),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Keterangan:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _keteranganController,
                maxLines: 3,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Contoh: Beli Makan',
                  hintStyle: TextStyle(color: Colors.black26),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: _simpan,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2.5),
                  ),
                  child: Center(
                    child: Text(
                      isEditing ? 'Update' : 'Simpan',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
