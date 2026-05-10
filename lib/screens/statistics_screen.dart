import 'package:flutter/material.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/summary_month_card.dart';
import '../widgets/chart_widget.dart';
import '../widgets/reusable_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

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
          final periodTitle = transactionProvider.statPeriod == 'Semua' ? 'Seluruh Transaksi' : 'Ringkasan ${transactionProvider.statPeriod}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPeriodFilter(),
                const SizedBox(height: AppSpacing.md),
                SummaryMonthCard(
                  income: income,
                  expense: expense,
                  balance: balance,
                  title: periodTitle,
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
                        children: [
                          const Expanded(child: Text('Persentase Pengeluaran', style: AppTextStyles.body)),
                          const SizedBox(width: AppSpacing.md),
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
  Widget _buildPeriodFilter() {
    final periods = ['Bulan Ini', 'Bulan Lalu', 'Semua'];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedMd,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: periods.map((period) {
          final isSelected = transactionProvider.statPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => transactionProvider.setStatPeriod(period),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Center(
                  child: Text(
                    period,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.secondaryText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
