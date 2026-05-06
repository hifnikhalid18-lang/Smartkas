import 'package:flutter/material.dart';
import '../providers/debt_provider.dart';
import '../models/debt.dart';
import '../utils/app_styles.dart';
import '../utils/currency_formatter.dart';
import '../widgets/debt_summary_card.dart';
import '../widgets/debt_form_modal.dart';
import '../widgets/reusable_card.dart';
import '../widgets/status_widgets.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hutang & Piutang'),
      ),
      body: ListenableBuilder(
        listenable: debtProvider,
        builder: (context, _) {
          final filteredDebts = debtProvider.debts.where((d) {
            return d.personName.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          // Split active and paid
          final activeDebts = filteredDebts.where((d) => !d.isPaid).toList();
          final paidDebts = filteredDebts.where((d) => d.isPaid).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: DebtSummaryCard(
                  totalHutang: debtProvider.totalHutang,
                  totalPiutang: debtProvider.totalPiutang,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari nama orang...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: SafeDataWrapper(
                  isLoading: debtProvider.isLoading,
                  isEmpty: filteredDebts.isEmpty,
                  emptyMessage: 'Belum ada catatan hutang piutang',
                  emptyIcon: Icons.people_outline_rounded,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    children: [
                      if (activeDebts.isNotEmpty) ...[
                        _buildSectionHeader('BELUM LUNAS (${activeDebts.length})'),
                        ...activeDebts.map((d) => _buildDebtItem(context, d)),
                      ],
                      if (paidDebts.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _buildSectionHeader('SUDAH LUNAS'),
                        ...paidDebts.map((d) => _buildDebtItem(context, d)),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Catatan'),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.sm),
      child: Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
    );
  }

  Widget _buildDebtItem(BuildContext context, DebtModel debt) {
    final isPiutang = debt.type == DebtType.piutang;
    final color = isPiutang ? AppColors.success : AppColors.error;

    return ReusableCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      onTap: () => _showForm(context, debt: debt),
      child: Opacity(
        opacity: debt.isPaid ? 0.6 : 1.0,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPiutang ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(debt.personName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    debt.date.toString().split(' ')[0],
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatterHelper.formatRupiah(debt.amount),
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                TextButton(
                  onPressed: () => debtProvider.togglePaidStatus(debt.id),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    debt.isPaid ? 'Batal Lunas' : 'Tandai Lunas',
                    style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showForm(BuildContext context, {DebtModel? debt}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebtFormModal(debtToEdit: debt),
    );
  }
}
