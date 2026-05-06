import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../utils/currency_formatter.dart';
import 'reusable_card.dart';

class DebtSummaryCard extends StatelessWidget {
  final double totalHutang;
  final double totalPiutang;

  const DebtSummaryCard({
    super.key,
    required this.totalHutang,
    required this.totalPiutang,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                'Total Hutang',
                totalHutang,
                AppColors.error,
                Icons.outbound_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildSummaryItem(
                'Total Piutang',
                totalPiutang,
                AppColors.success,
                Icons.move_to_inbox_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String title, double amount, Color color, IconData icon) {
    return ReusableCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatterHelper.formatRupiah(amount),
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
