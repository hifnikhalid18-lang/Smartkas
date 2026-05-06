import 'package:flutter/material.dart';
import 'reusable_card.dart';
import '../utils/app_styles.dart';

class SaldoCard extends StatelessWidget {
  final String balance;

  const SaldoCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      color: AppColors.accent,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      child: Column(
        children: [
          const Text(
            'TOTAL SALDO',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            balance,
            style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 36),
          ),
        ],
      ),
    );
  }
}
