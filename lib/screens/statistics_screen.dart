import 'package:flutter/material.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/summary_month_card.dart';
import '../widgets/chart_widget.dart';
import '../widgets/reusable_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Statistik Keuangan'),
      ),
      body: ListenableBuilder(
        listenable: transactionProvider,
        builder: (context, _) {
          final income = transactionProvider.monthlyIncome;
          final expense = transactionProvider.monthlyExpense;
          final balance = transactionProvider.monthlyBalance;
          final percentage = transactionProvider.expensePercentage;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SummaryMonthCard(
                  income: income,
                  expense: expense,
                  balance: balance,
                ),
                const SizedBox(height: AppSpacing.lg),
                
                ReusableCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Text(
                        'PERBANDINGAN',
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SimpleBarChart(income: income, expense: expense),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                ReusableCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Persentase Pengeluaran', style: AppTextStyles.body),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: percentage > 80 ? AppColors.error : AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ClipRRect(
                        borderRadius: AppRadius.roundedMd,
                        child: LinearProgressIndicator(
                          value: (percentage / 100).clamp(0.0, 1.0),
                          backgroundColor: AppColors.background,
                          color: percentage > 80 ? AppColors.error : AppColors.accent,
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        percentage > 100 
                            ? 'Peringatan: Pengeluaran melebihi pemasukan!' 
                            : percentage > 80 
                                ? 'Hati-hati: Pengeluaran sudah hampir mencapai pemasukan.'
                                : 'Kondisi keuangan Anda bulan ini stabil.',
                        style: AppTextStyles.caption.copyWith(
                          color: percentage > 80 ? AppColors.error : AppColors.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
