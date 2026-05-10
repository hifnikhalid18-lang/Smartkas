import 'package:flutter/material.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/summary_month_card.dart';
import '../widgets/donut_chart_widget.dart';
import '../widgets/reusable_card.dart';
import '../utils/category_helper.dart';
import '../utils/currency_formatter.dart';
import '../models/transaction.dart';

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
                Row(
                  children: [
                    Expanded(
                      child: _buildExportButton(
                        label: 'Export PDF',
                        icon: Icons.picture_as_pdf_rounded,
                        color: Colors.redAccent,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mengekspor PDF...')));
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildExportButton(
                        label: 'Export Excel',
                        icon: Icons.table_chart_rounded,
                        color: Colors.green,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mengekspor Excel...')));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SummaryMonthCard(
                  income: income,
                  expense: expense,
                  balance: balance,
                  title: periodTitle,
                ),
                const SizedBox(height: AppSpacing.lg),
                
                ReusableCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      const Text(
                        'PENGELUARAN PER KATEGORI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DonutChartWidget(
                        data: transactionProvider.categoryExpenseSummaries,
                        total: expense,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                _buildCategoryList(),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildCategoryList() {
    final summaries = transactionProvider.categoryExpenseSummaries;
    if (summaries.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text('Kategori Terbesar', style: AppTextStyles.title),
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: summaries.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final category = summaries.keys.elementAt(index);
            final amount = summaries.values.elementAt(index);
            final color = CategoryHelper.getCategoryColor(category);
            final totalExpense = transactionProvider.monthlyExpense;
            final percent = totalExpense > 0 ? (amount / totalExpense) * 100 : 0.0;

            return ReusableCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(CategoryHelper.getCategoryIcon(category), color: color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${percent.toStringAsFixed(1)}% dari pengeluaran', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatterHelper.formatRupiah(amount),
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExportButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppColors.softShadow,
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
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
