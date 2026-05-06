import 'package:flutter/material.dart';
import '../models/savings_goal.dart';
import '../utils/app_styles.dart';
import '../utils/currency_formatter.dart';
import 'reusable_card.dart';

class SavingsGoalCard extends StatelessWidget {
  final SavingsGoalModel goal;
  final VoidCallback onAddFunds;
  final VoidCallback onDelete;

  const SavingsGoalCard({
    super.key,
    required this.goal,
    required this.onAddFunds,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = goal.targetAmount - goal.currentAmount;
    final percentage = (goal.progress * 100).toStringAsFixed(1);
    final colorScheme = Theme.of(context).colorScheme;

    return ReusableCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(goal.icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    if (goal.deadline != null)
                      Text(
                        'Deadline: ${goal.deadline.toString().split(' ')[0]}',
                        style: AppTextStyles.caption,
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress: $percentage%',
                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
              Text(
                '${CurrencyFormatterHelper.formatRupiah(goal.currentAmount)} / ${CurrencyFormatterHelper.formatRupiah(goal.targetAmount)}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 10,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (remaining > 0)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Kurang ${CurrencyFormatterHelper.formatRupiah(remaining)} lagi',
                    style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onAddFunds,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Tambah Dana'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                  SizedBox(width: 8),
                  Text('Target Tercapai!', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
