import 'package:flutter/material.dart';
import '../models/debt.dart';
import '../providers/debt_provider.dart';
import '../utils/app_styles.dart';

class DebtFormModal extends StatefulWidget {
  final DebtModel? debtToEdit;

  const DebtFormModal({super.key, this.debtToEdit});

  @override
  State<DebtFormModal> createState() => _DebtFormModalState();
}

class _DebtFormModalState extends State<DebtFormModal> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DebtType _type = DebtType.piutang;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.debtToEdit != null) {
      _nameController.text = widget.debtToEdit!.personName;
      _amountController.text = widget.debtToEdit!.amount.toString();
      _type = widget.debtToEdit!.type;
      _selectedDate = widget.debtToEdit!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.debtToEdit == null ? 'Tambah Catatan' : 'Edit Catatan',
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SegmentedButton<DebtType>(
            segments: const [
              ButtonSegment(value: DebtType.piutang, label: Text('Piutang'), icon: Icon(Icons.arrow_downward_rounded)),
              ButtonSegment(value: DebtType.hutang, label: Text('Hutang'), icon: Icon(Icons.arrow_upward_rounded)),
            ],
            selected: {_type},
            onSelectionChanged: (Set<DebtType> newSelection) {
              setState(() => _type = newSelection.first);
            },
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: _type == DebtType.piutang ? AppColors.success : AppColors.error,
              selectedForegroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nama Orang',
              hintText: 'Siapa yang berhutang/diutangi?',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal (Rp)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixText: 'Rp ',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_rounded, color: AppColors.accent),
            title: Text(_selectedDate.toString().split(' ')[0]),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              widget.debtToEdit == null ? 'Simpan Catatan' : 'Update Catatan',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _submit() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    final debt = DebtModel(
      id: widget.debtToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      personName: _nameController.text,
      amount: amount,
      type: _type,
      date: _selectedDate,
      isPaid: widget.debtToEdit?.isPaid ?? false,
    );

    if (widget.debtToEdit == null) {
      debtProvider.addDebt(debt);
    } else {
      debtProvider.updateDebt(debt);
    }
    
    Navigator.pop(context);
  }
}
