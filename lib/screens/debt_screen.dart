import 'package:flutter/material.dart';
import '../providers/debt_provider.dart';
import '../models/debt.dart';
import '../utils/app_styles.dart';
import '../utils/currency_formatter.dart';
import 'package:intl/intl.dart';
import '../widgets/startup_background.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StartupBackground(
        child: ListenableBuilder(
          listenable: debtProvider,
          builder: (context, _) {
            final all = debtProvider.debts;
            final hutang = all.where((d) => d.type == DebtType.hutang).toList();
            final piutang = all.where((d) => d.type == DebtType.piutang).toList();

            return Column(
              children: [
                _buildSummaryStrip(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDebtList(hutang, 'hutang'),
                      _buildDebtList(piutang, 'piutang'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('Hutang & Piutang', style: AppTextStyles.title.copyWith(fontSize: 17)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 12),
          child: _buildTabBar(),
        ),
      ),
    );
  }

  // ── Summary Strip ─────────────────────────────────────────────────────────
  Widget _buildSummaryStrip() {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStripItem(
              label: 'Hutang Saya',
              amount: debtProvider.totalHutang,
              color: AppColors.error,
              icon: Icons.trending_down_rounded,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.hairline),
          Expanded(
            child: _buildStripItem(
              label: 'Piutang Saya',
              amount: debtProvider.totalPiutang,
              color: AppColors.success,
              icon: Icons.trending_up_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStripItem({
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.micro.copyWith(color: AppColors.secondaryText, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatterHelper.formatRupiah(amount),
          style: AppTextStyles.amount.copyWith(color: color),
        ),
      ],
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(40),
          boxShadow: AppColors.softShadow,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.primaryText,
        unselectedLabelColor: AppColors.muted,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: const [
          Tab(text: 'Hutang'),
          Tab(text: 'Piutang'),
        ],
      ),
    );
  }

  // ── List ──────────────────────────────────────────────────────────────────
  Widget _buildDebtList(List<DebtModel> items, String type) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'hutang' ? Icons.trending_down_rounded : Icons.trending_up_rounded,
              size: 48,
              color: AppColors.border,
            ),
            const SizedBox(height: 12),
            Text(
              type == 'hutang' ? 'Tidak ada hutang aktif' : 'Tidak ada piutang aktif',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 100),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildDebtCard(items[index]),
    );
  }

  Widget _buildDebtCard(DebtModel debt) {
    final isHutang = debt.type == DebtType.hutang;
    final color    = isHutang ? AppColors.error : AppColors.success;
    final fmt      = DateFormat('dd MMM yyyy');
    final now      = DateTime.now();
    final isOverdue = debt.dueDate != null && !debt.isPaid && debt.dueDate!.isBefore(now);

    // Auto-generate avatar color from title hash
    final avatarColor = _colorFromString(debt.title);
    final initials = debt.title.trim().isEmpty
        ? '?'
        : debt.title.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join();

    return Dismissible(
      key: Key(debt.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      confirmDismiss: (_) => _confirmDelete(debt),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            // Avatar with initials
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: avatarColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    debt.title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: debt.isPaid ? TextDecoration.lineThrough : null,
                      color: debt.isPaid ? AppColors.muted : AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    fmt.format(debt.date),
                    style: AppTextStyles.micro,
                  ),
                  if (debt.dueDate != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 10,
                          color: isOverdue ? AppColors.error : AppColors.muted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Jatuh tempo: ${fmt.format(debt.dueDate!)}',
                          style: AppTextStyles.micro.copyWith(
                            color: isOverdue ? AppColors.error : AppColors.muted,
                            fontWeight: isOverdue ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Amount + Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatterHelper.formatRupiah(debt.amount),
                  style: AppTextStyles.amount.copyWith(
                    color: debt.isPaid ? AppColors.muted : color,
                  ),
                ),
                const SizedBox(height: 6),
                _buildStatusBadge(debt, isOverdue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(DebtModel debt, bool isOverdue) {
    final Color bg;
    final Color fg;
    final String text;
    final IconData icon;

    if (debt.isPaid) {
      bg = AppColors.accentLight;
      fg = AppColors.accentDark;
      text = 'Lunas';
      icon = Icons.check_circle_outline_rounded;
    } else if (isOverdue) {
      bg = const Color(0xFFFFF1F2);
      fg = AppColors.error;
      text = 'Overdue';
      icon = Icons.warning_amber_rounded;
    } else {
      bg = const Color(0xFFFFFBEB);
      fg = const Color(0xFFB45309); // Amber 700
      text = 'Belum';
      icon = Icons.access_time_rounded;
    }

    return GestureDetector(
      onTap: () => debtProvider.togglePaid(debt.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: fg),
            const SizedBox(width: 4),
            Text(text, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  // ── FAB ───────────────────────────────────────────────────────────────────
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddDebtSheet(context),
      backgroundColor: AppColors.accent,
      elevation: 2,
      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
      label: const Text('Catat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Color _colorFromString(String s) {
    final colors = [
      const Color(0xFF6366F1), const Color(0xFFF59E0B), const Color(0xFF10B981),
      const Color(0xFFEF4444), const Color(0xFF8B5CF6), const Color(0xFF0EA5E9),
      const Color(0xFFF97316), const Color(0xFF14B8A6),
    ];
    if (s.isEmpty) return colors[0];
    int hash = 0;
    for (final c in s.codeUnits) { hash = hash ^ c; }
    return colors[hash.abs() % colors.length];
  }

  Future<bool> _confirmDelete(DebtModel debt) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Data?'),
        content: Text('Hapus catatan "${debt.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              debtProvider.deleteDebt(debt.id);
              Navigator.pop(ctx, true);
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showAddDebtSheet(BuildContext context) {
    final titleCtrl  = TextEditingController();
    final amountCtrl = TextEditingController();
    DebtType selectedType = DebtType.hutang;
    DateTime? dueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            top: 20, left: 20, right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Catat Hutang / Piutang', style: AppTextStyles.title.copyWith(fontSize: 16)),
              const SizedBox(height: 16),
              // Type switcher
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(40)),
                child: Row(
                  children: [
                    _typeOption('Hutang', selectedType == DebtType.hutang, AppColors.error,
                        () => setModal(() => selectedType = DebtType.hutang)),
                    _typeOption('Piutang', selectedType == DebtType.piutang, AppColors.success,
                        () => setModal(() => selectedType = DebtType.piutang)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _inputField(titleCtrl, 'Nama / Keterangan', 'Contoh: Budi', TextInputType.text),
              const SizedBox(height: 12),
              _inputField(amountCtrl, 'Nominal', '0', TextInputType.number, prefix: 'Rp '),
              const SizedBox(height: 12),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_rounded, color: AppColors.accent, size: 20),
                title: Text(
                  dueDate == null ? 'Atur Jatuh Tempo (Opsional)' : DateFormat('dd/MM/yyyy').format(dueDate!),
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
                trailing: dueDate != null
                    ? IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () => setModal(() => dueDate = null))
                    : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) setModal(() => dueDate = picked);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.isEmpty || amountCtrl.text.isEmpty) return;
                  debtProvider.addDebt(DebtModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleCtrl.text.trim(),
                    amount: double.tryParse(amountCtrl.text) ?? 0,
                    date: DateTime.now(),
                    dueDate: dueDate,
                    type: selectedType,
                  ));
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  elevation: 0,
                ),
                child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeOption(String label, bool selected, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.muted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController ctrl,
    String label,
    String hint,
    TextInputType type, {
    String? prefix,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix,
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
