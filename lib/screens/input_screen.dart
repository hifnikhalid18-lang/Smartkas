import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../utils/currency_formatter.dart';
import '../utils/app_styles.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/reusable_card.dart';

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
  late String _selectedCategory;
  late DateTime _selectedDate;
  
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
    _selectedCategory = widget.transactionToEdit?.category ?? 'Lainnya';
    _selectedDate = widget.transactionToEdit?.date ?? DateTime.now();
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
        date: _selectedDate,
        type: _selectedType,
        category: _selectedCategory,
      );
      transactionProvider.updateTransaction(updatedTransaction);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil diperbarui'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryText,
        ),
      );
    } else {
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: keterangan,
        amount: nominal,
        date: _selectedDate,
        type: _selectedType,
        category: _selectedCategory,
      );
      transactionProvider.addTransaction(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil ditambahkan'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryText,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaksi' : 'Tambah ${widget.type}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('TIPE TRANSAKSI'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _buildTypeOption(TransactionType.pemasukan, 'PEMASUKAN'),
                  const SizedBox(width: AppSpacing.md),
                  _buildTypeOption(TransactionType.pengeluaran, 'PENGELUARAN'),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              _buildSectionTitle('KATEGORI'),
              const SizedBox(height: AppSpacing.sm),
              CategoryDropdown(
                type: _selectedType,
                selectedCategory: _selectedCategory,
                onChanged: (value) {
                  if (value != null) setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              _buildSectionTitle('TANGGAL'),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.accent,
                            onPrimary: Colors.white,
                            onSurface: AppColors.primaryText,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.roundedMd,
                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: AppColors.secondaryText, size: 20),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              _buildSectionTitle('NOMINAL'),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RupiahInputFormatter(),
                ],
                style: AppTextStyles.body.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Rp 0',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  errorText: _nominalError,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                    borderRadius: AppRadius.roundedMd,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                    borderRadius: AppRadius.roundedMd,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                    borderRadius: AppRadius.roundedMd,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.error, width: 2),
                    borderRadius: AppRadius.roundedMd,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              _buildSectionTitle('KETERANGAN'),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _keteranganController,
                maxLines: 2,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Contoh: Beli Makan Siang',
                  filled: true,
                  fillColor: AppColors.surface,
                  errorText: _keteranganError,
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                    borderRadius: AppRadius.roundedMd,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                    borderRadius: AppRadius.roundedMd,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                    borderRadius: AppRadius.roundedMd,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.error, width: 2),
                    borderRadius: AppRadius.roundedMd,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryText,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
                  elevation: 0,
                ),
                child: Text(
                  isEditing ? 'UPDATE TRANSAKSI' : 'SIMPAN TRANSAKSI',
                  style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
    );
  }

  Widget _buildTypeOption(TransactionType type, String label) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedType = type;
          // Reset category to default of new type
          _selectedCategory = 'Lainnya';
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : AppColors.surface,
            borderRadius: AppRadius.roundedMd,
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.border,
              width: 1.5,
            ),
            boxShadow: isSelected ? AppColors.softShadow : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? Colors.white : AppColors.secondaryText,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
