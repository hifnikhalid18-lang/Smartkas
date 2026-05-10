import 'package:flutter/material.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/donut_chart_widget.dart';
import '../widgets/startup_background.dart';
import '../utils/category_helper.dart';
import '../utils/currency_formatter.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Laporan', style: AppTextStyles.title.copyWith(fontSize: 17)),
        actions: [
          _ExportMenu(),
          const SizedBox(width: 4),
        ],
      ),
      body: StartupBackground(
        child: ListenableBuilder(
          listenable: transactionProvider,
        builder: (context, _) {
          final income   = transactionProvider.monthlyIncome;
          final expense  = transactionProvider.monthlyExpense;
          final balance  = transactionProvider.monthlyBalance;
          final summaries = transactionProvider.categoryExpenseSummaries;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildPeriodFilter()),
              SliverToBoxAdapter(child: _buildSummaryStrip(income, expense, balance)),
              if (summaries.isNotEmpty) ...[
                SliverToBoxAdapter(child: _buildChartSection(summaries, expense)),
                SliverToBoxAdapter(child: _buildCategoryHeader()),
                _buildCategorySliver(summaries, expense),
              ] else ...[
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('Belum ada pengeluaran di periode ini.', style: AppTextStyles.caption),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
      ),
    );
  }

  // ── Period Filter ─────────────────────────────────────────────────────────
  Widget _buildPeriodFilter() {
    final periods = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 16),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: periods.map((p) {
            return _PeriodTab(period: p);
          }).toList(),
        ),
      ),
    );
  }

  // ── Summary Strip ─────────────────────────────────────────────────────────
  Widget _buildSummaryStrip(double income, double expense, double balance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            _SummaryItem(label: 'Pemasukan', amount: income, color: AppColors.success),
            Container(width: 1, height: 36, color: AppColors.hairline),
            _SummaryItem(label: 'Pengeluaran', amount: expense, color: AppColors.error),
            Container(width: 1, height: 36, color: AppColors.hairline),
            _SummaryItem(label: 'Saldo', amount: balance, color: AppColors.primaryText),
          ],
        ),
      ),
    );
  }

  // ── Chart Section ─────────────────────────────────────────────────────────
  Widget _buildChartSection(Map<String, double> summaries, double totalExpense) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 20, AppSpacing.md, 0),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Pengeluaran per Kategori', style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryText, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            DonutChartWidget(data: summaries, total: totalExpense),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, 24, AppSpacing.md, 8),
      child: Text('Terbesar', style: AppTextStyles.subtitle),
    );
  }

  // ── Category List ─────────────────────────────────────────────────────────
  Widget _buildCategorySliver(Map<String, double> summaries, double totalExpense) {
    final entries = summaries.entries.toList();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final cat    = entries[index].key;
            final amount = entries[index].value;
            final color  = CategoryHelper.getCategoryColor(cat);
            final pct    = totalExpense > 0 ? (amount / totalExpense * 100) : 0.0;
            final isLast = index == entries.length - 1;

            return Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Color bar indicator
                      Container(width: 3, height: 36, color: color, margin: const EdgeInsets.only(right: 14)),
                      // Icon
                      Icon(CategoryHelper.getCategoryIcon(cat), color: color, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            Text('${pct.toStringAsFixed(1)}%', style: AppTextStyles.micro),
                          ],
                        ),
                      ),
                      Text(
                        CurrencyFormatterHelper.formatRupiah(amount),
                        style: AppTextStyles.amount.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  if (!isLast) const Divider(height: 1, thickness: 1, color: AppColors.hairline),
                ],
              ),
            );
          },
          childCount: entries.length,
        ),
      ),
    );
  }
}

// ── Stateful helper widgets ───────────────────────────────────────────────────

class _PeriodTab extends StatelessWidget {
  final String period;
  const _PeriodTab({required this.period});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: transactionProvider,
      builder: (_, __) {
        final isSelected = transactionProvider.statPeriod == period;
        return Expanded(
          child: GestureDetector(
            onTap: () => transactionProvider.setStatPeriod(period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
                boxShadow: isSelected ? AppColors.softShadow : [],
              ),
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryText : AppColors.muted,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const _SummaryItem({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.micro.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatterHelper.formatRupiah(amount),
            style: AppTextStyles.amount.copyWith(color: color, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ExportMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.ios_share_rounded, size: 20, color: AppColors.secondaryText),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'pdf',
          child: Row(children: [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 18),
            SizedBox(width: 10),
            Text('Export PDF'),
          ]),
        ),
        const PopupMenuItem(
          value: 'excel',
          child: Row(children: [
            Icon(Icons.table_chart_rounded, color: Colors.green, size: 18),
            SizedBox(width: 10),
            Text('Export Excel'),
          ]),
        ),
      ],
      onSelected: (val) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mengekspor ${val.toUpperCase()}...'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }
}
