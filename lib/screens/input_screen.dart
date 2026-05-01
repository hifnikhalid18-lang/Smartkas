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

    // Membersihkan input dari titik (pemisah ribuan) agar bisa diparsing
    final String cleanNominal = nominalText.replaceAll('.', '');
    final double? nominal = double.tryParse(cleanNominal);
    
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
                'TIPE TRANSAKSI',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedType = TransactionType.pemasukan),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _selectedType == TransactionType.pemasukan ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'PEMASUKAN',
                            style: TextStyle(
                              color: _selectedType == TransactionType.pemasukan ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedType = TransactionType.pengeluaran),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _selectedType == TransactionType.pengeluaran ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'PENGELUARAN',
                            style: TextStyle(
                              color: _selectedType == TransactionType.pengeluaran ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'NOMINAL',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.black12),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
              const SizedBox(height: 32),
              const Text(
                'KETERANGAN',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _keteranganController,
                maxLines: 3,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Contoh: Beli Makan Siang',
                  hintStyle: TextStyle(color: Colors.black12),
                  contentPadding: EdgeInsets.all(16),
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
              const SizedBox(height: 48),
              InkWell(
                onTap: _simpan,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      isEditing ? 'UPDATE DATA' : 'SIMPAN TRANSAKSI',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
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
