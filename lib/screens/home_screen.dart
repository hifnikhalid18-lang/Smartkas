import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_drawer.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_selector.dart';
import 'input_screen.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../utils/currency_formatter.dart';
import '../utils/app_styles.dart';
import '../utils/category_helper.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    walletProvider.addListener(_onWalletProviderChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    walletProvider.removeListener(_onWalletProviderChanged);
    super.dispose();
  }

  void _onWalletProviderChanged() {
    if (mounted && walletProvider.activeWallet != null) _loadData();
  }

  void _loadData() {
    if (walletProvider.activeWallet != null) {
      transactionProvider.loadTransactions(walletProvider.activeWallet!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: ListenableBuilder(
        listenable: walletProvider,
        builder: (context, _) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            drawer: const AppDrawer(),
            body: ListenableBuilder(
              listenable: transactionProvider,
              builder: (context, _) {
                final balance = transactionProvider.totalBalance;
                final income = transactionProvider.totalIncome;
                final expense = transactionProvider.totalExpense;
                final transactions = transactionProvider.filteredTransactions;

                return CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(child: _buildBalanceSection(balance, income, expense)),
                    SliverToBoxAdapter(child: _buildFilterBar()),
                    SliverToBoxAdapter(child: _buildListHeader(transactions.length)),
                    _buildTransactionList(transactions),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              },
            ),
            bottomNavigationBar: _buildBottomBar(),
          );
        },
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      floating: true,
      pinned: false,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: AppSpacing.md,
      title: GestureDetector(
        onTap: () => _showWalletPicker(context),
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SMARTKAS',
              style: AppTextStyles.sectionLabel.copyWith(color: AppColors.accent, fontSize: 9),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  walletProvider.activeWallet?.name ?? 'Kas Utama',
                  style: AppTextStyles.title.copyWith(fontSize: 17),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.unfold_more_rounded, color: AppColors.muted, size: 16),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.segment_rounded, color: AppColors.primaryText, size: 22),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          tooltip: 'Menu',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Balance Section ───────────────────────────────────────────────────────
  Widget _buildBalanceSection(double balance, double income, double expense) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 4, AppSpacing.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Saldo',
            style: AppTextStyles.micro.copyWith(fontSize: 11, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatterHelper.formatRupiah(balance),
            style: AppTextStyles.balance,
          ),
          const SizedBox(height: 16),
          // Inline income/expense chips
          Row(
            children: [
              _buildStatPill(
                label: 'Masuk',
                amount: income,
                icon: Icons.arrow_downward_rounded,
                color: AppColors.success,
              ),
              const SizedBox(width: 10),
              _buildStatPill(
                label: 'Keluar',
                amount: expense,
                icon: Icons.arrow_upward_rounded,
                color: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, thickness: 1, color: AppColors.hairline),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 12),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.micro.copyWith(color: AppColors.secondaryText)),
              Text(
                CurrencyFormatterHelper.formatRupiah(amount),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Filter Bar ────────────────────────────────────────────────────────────
  Widget _buildFilterBar() {
    final filters = [
      {'label': 'Semua',    'icon': Icons.all_inclusive_rounded},
      {'label': 'Harian',   'icon': Icons.today_rounded},
      {'label': 'Mingguan', 'icon': Icons.view_week_rounded},
      {'label': 'Bulanan',  'icon': Icons.calendar_month_rounded},
      {'label': 'Tahunan',  'icon': Icons.event_note_rounded},
    ];

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          ...filters.map((f) {
            final label = f['label'] as String;
            final icon  = f['icon']  as IconData;
            final isActive = transactionProvider.statPeriod == label;
            return _buildFilterPill(label: label, icon: icon, isActive: isActive);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterPill({required String label, required IconData icon, required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => transactionProvider.setStatPeriod(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: isActive ? 14 : 10, vertical: 0),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.cardBg,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: isActive ? Colors.white : AppColors.muted),
              if (isActive) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── List Header ───────────────────────────────────────────────────────────
  Widget _buildListHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 20, AppSpacing.md, 8),
      child: Row(
        children: [
          Text('Transaksi', style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryText, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('$count item', style: AppTextStyles.micro),
        ],
      ),
    );
  }

  // ── Transaction List ──────────────────────────────────────────────────────
  Widget _buildTransactionList(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, size: 52, color: AppColors.border),
              const SizedBox(height: 12),
              Text('Belum ada transaksi.', style: AppTextStyles.caption),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final tx = transactions[index];
          final isLast = index == transactions.length - 1;
          return _buildTransactionRow(tx, isLast);
        },
        childCount: transactions.length,
      ),
    );
  }

  Widget _buildTransactionRow(TransactionModel tx, bool isLast) {
    final isIncome = tx.type == TransactionType.pemasukan;
    final catColor = CategoryHelper.getCategoryColor(tx.category);
    final catIcon  = CategoryHelper.getCategoryIcon(tx.category);

    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error.withOpacity(0.1),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      confirmDismiss: (_) => _confirmDelete(tx),
      child: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        child: Row(
          children: [
            // Square category icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(catIcon, color: catColor, size: 18),
            ),
            const SizedBox(width: 12),
            // Center text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.category,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (tx.title.isNotEmpty)
                    Text(
                      tx.title,
                      style: AppTextStyles.micro.copyWith(color: AppColors.secondaryText, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right side
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'} ${CurrencyFormatterHelper.formatRupiah(tx.amount)}',
                  style: AppTextStyles.amount.copyWith(
                    color: isIncome ? AppColors.success : AppColors.error,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM').format(tx.date),
                  style: AppTextStyles.micro,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildBottomButton(
              label: '+ Pemasukan',
              bg: AppColors.accentLight,
              fg: AppColors.accentDark,
              onTap: () => _navigateToInput('Pemasukan'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildBottomButton(
              label: '− Pengeluaran',
              bg: const Color(0xFFFFF1F2),
              fg: AppColors.error,
              onTap: () => _navigateToInput('Pengeluaran'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required String label,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(40)),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _navigateToInput(String type) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => InputScreen(type: type)));
  }

  void _showWalletPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const WalletSelector(),
    );
  }

  Future<bool> _confirmDelete(TransactionModel tx) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Transaksi?'),
        content: const Text('Data yang dihapus tidak bisa dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              transactionProvider.deleteTransaction(tx);
              Navigator.pop(ctx, true);
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
