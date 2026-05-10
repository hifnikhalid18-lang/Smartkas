import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../utils/app_styles.dart';
import '../utils/currency_formatter.dart';
import '../utils/category_helper.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome   = transaction.type == TransactionType.pemasukan;
    final catColor   = CategoryHelper.getCategoryColor(transaction.category);
    final catIcon    = CategoryHelper.getCategoryIcon(transaction.category);
    final amountColor = isIncome ? AppColors.success : AppColors.error;
    final sign       = isIncome ? '+' : '−';

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error.withOpacity(0.08),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false; // let provider handle it
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 11),
          child: Row(
            children: [
              // Square icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(catIcon, color: catColor, size: 18),
              ),
              const SizedBox(width: 12),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (transaction.title.isNotEmpty)
                      Text(
                        transaction.title,
                        style: AppTextStyles.micro.copyWith(color: AppColors.secondaryText, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Amount + date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$sign ${CurrencyFormatterHelper.formatRupiah(transaction.amount)}',
                    style: AppTextStyles.amount.copyWith(color: amountColor, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd MMM').format(transaction.date),
                    style: AppTextStyles.micro,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
