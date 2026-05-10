import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';
import '../screens/input_screen.dart';
import '../utils/app_styles.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: 1,
          ),
          boxShadow: isSelected ? AppColors.softShadow : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.secondaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class TransactionListView extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel) onDelete;

  const TransactionListView({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionItem(
          transaction: transaction,
          onDelete: () => onDelete(transaction),
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
    );
  }
}
