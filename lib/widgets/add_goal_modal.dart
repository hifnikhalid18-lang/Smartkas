import 'package:flutter/material.dart';
import '../models/savings_goal.dart';
import '../providers/savings_provider.dart';
import '../utils/app_styles.dart';

class AddGoalModal extends StatefulWidget {
  const AddGoalModal({super.key});

  @override
  State<AddGoalModal> createState() => _AddGoalModalState();
}

class _AddGoalModalState extends State<AddGoalModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  IconData _selectedIcon = Icons.savings_rounded;

  final List<IconData> _icons = [
    Icons.savings_rounded,
    Icons.laptop_mac_rounded,
    Icons.directions_car_rounded,
    Icons.home_rounded,
    Icons.flight_takeoff_rounded,
    Icons.shopping_cart_rounded,
    Icons.favorite_rounded,
    Icons.star_rounded,
  ];

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
          const Text('Buat Target Baru', style: AppTextStyles.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Nama Target',
              hintText: 'Contoh: Beli Laptop Baru',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal Target (Rp)',
              hintText: 'Contoh: 5000000',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixText: 'Rp ',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_rounded, color: AppColors.accent),
            title: Text(_selectedDate == null ? 'Pilih Deadline (Opsional)' : _selectedDate.toString().split(' ')[0]),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Pilih Ikon', style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                final icon = _icons[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIcon == icon ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
                      border: Border.all(color: _selectedIcon == icon ? AppColors.accent : AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: _selectedIcon == icon ? AppColors.accent : AppColors.secondaryText),
                  ),
                );
              },
            ),
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
            child: const Text('Simpan Target', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _submit() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    final newGoal = SavingsGoalModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      targetAmount: amount,
      startDate: DateTime.now(),
      targetDate: _selectedDate,
    );

    savingsProvider.addGoal(newGoal);
    Navigator.pop(context);
  }
}
