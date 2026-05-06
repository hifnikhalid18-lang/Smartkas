import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../utils/currency_formatter.dart';
import 'reusable_card.dart';

class SummaryMonthCard extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;

  const SummaryMonthCard({
    super.key,
    required this.income,
    required this.expense,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RINGKASAN BULAN INI',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRow('Pemasukan', income, AppColors.success),
          const SizedBox(height: AppSpacing.sm),
          _buildRow('Pengeluaran', expense, AppColors.error),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(color: AppColors.border, thickness: 0.5),
          ),
          _buildRow('Sisa Saldo', balance, AppColors.primaryText, isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(color: isBold ? AppColors.primaryText : AppColors.secondaryText)),
        Text(
          CurrencyFormatterHelper.formatRupiah(value),
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
