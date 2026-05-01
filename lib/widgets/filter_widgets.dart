import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';
import '../screens/input_screen.dart';
import '../utils/currency_formatter.dart';

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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(4),
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
          title: transaction.title,
          amount: CurrencyFormatterHelper.formatRupiah(transaction.amount),
          date: DateFormat('dd MMM yyyy').format(transaction.date),
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
