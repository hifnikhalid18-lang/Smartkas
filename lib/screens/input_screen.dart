import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../utils/currency_formatter.dart';

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
  
  String? _nominalError;
  String? _keteranganError;

  @override
  void initState() {
    super.initState();
    _nominalController = TextEditingController(
      text: widget.transactionToEdit != null 
          ? CurrencyFormatterHelper.formatRupiah(widget.transactionToEdit!.amount)
          : '',
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

  bool _validate() {
    bool isValid = true;
    final String nominalText = _nominalController.text.trim();
    final String keterangan = _keteranganController.text.trim();

    setState(() {
      // Validasi Nominal
      if (nominalText.isEmpty) {
        _nominalError = 'Nominal tidak boleh kosong';
        isValid = false;
      } else {
        final double nominal = CurrencyFormatterHelper.parseRupiah(nominalText);
        if (nominal <= 0) {
          _nominalError = 'Nominal harus lebih besar dari 0';
          isValid = false;
        } else if (nominal > 999999999) {
          _nominalError = 'Maksimal Rp 999.999.999';
          isValid = false;
        } else {
          _nominalError = null;
        }
      }

      // Validasi Keterangan
      if (keterangan.isEmpty) {
        _keteranganError = 'Keterangan tidak boleh kosong';
        isValid = false;
      } else {
        _keteranganError = null;
      }
    });

    return isValid;
  }

  void _simpan() {
    if (!_validate()) return;

    final double nominal = CurrencyFormatterHelper.parseRupiah(_nominalController.text.trim());
    final String keterangan = _keteranganController.text.trim();

    if (widget.transactionToEdit != null) {
      final updatedTransaction = TransactionModel(
        id: widget.transactionToEdit!.id,
        title: keterangan,
        amount: nominal,
        date: widget.transactionToEdit!.date,
        type: _selectedType,
      );
      transactionProvider.updateTransaction(updatedTransaction);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil diperbarui'),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: keterangan,
        amount: nominal,
        date: DateTime.now(),
        type: _selectedType,
      );
      transactionProvider.addTransaction(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil ditambahkan'),
          backgroundColor: Colors.black,
        ),
      );
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
          isEditing ? 'Edit Transaksi' : 'Tambah ${widget.type}',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 3. Transaction Type Selector
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
                  _buildTypeOption(TransactionType.pemasukan, 'PEMASUKAN'),
                  const SizedBox(width: 16),
                  _buildTypeOption(TransactionType.pengeluaran, 'PENGELUARAN'),
                ],
              ),
              const SizedBox(height: 32),

              // 1. Input Nominal Field
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RupiahInputFormatter(),
                ],
                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Rp 0',
                  hintStyle: const TextStyle(color: Colors.black12),
                  errorText: _nominalError,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.zero,
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.5),
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 2. Input Keterangan Field
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
                maxLines: 2,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Contoh: Beli Makan Siang',
                  hintStyle: const TextStyle(color: Colors.black12),
                  errorText: _keteranganError,
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.zero,
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.5),
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Submit Button
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

  Widget _buildTypeOption(TransactionType type, String label) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
