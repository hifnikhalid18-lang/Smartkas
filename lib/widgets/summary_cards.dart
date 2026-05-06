import 'package:flutter/material.dart';
import 'reusable_card.dart';
import '../utils/app_styles.dart';

class SaldoSummaryCard extends StatelessWidget {
  final String balance;

  const SaldoSummaryCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      color: AppColors.accent,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      child: Column(
        children: [
          const Text(
            'Total Saldo',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            balance,
            style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 32),
          ),
        ],
      ),
    );
  }
}

class IncomeSummaryCard extends StatelessWidget {
  final String amount;

  const IncomeSummaryCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReusableCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_downward_rounded, color: AppColors.success, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Masuk', style: AppTextStyles.caption),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(amount, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseSummaryCard extends StatelessWidget {
  final String amount;

  const ExpenseSummaryCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReusableCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_upward_rounded, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Keluar', style: AppTextStyles.caption),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(amount, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
