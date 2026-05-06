import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class SimpleBarChart extends StatelessWidget {
  final double income;
  final double expense;

  const SimpleBarChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final double maxVal = (income > expense ? income : expense);
    final double incomeHeight = maxVal == 0 ? 0 : (income / maxVal) * 150;
    final double expenseHeight = maxVal == 0 ? 0 : (expense / maxVal) * 150;

    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar('Pemasukan', incomeHeight, AppColors.success),
          _buildBar('Pengeluaran', expenseHeight, AppColors.error),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          width: 50,
          height: height.clamp(10, 150).toDouble(),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sm)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
