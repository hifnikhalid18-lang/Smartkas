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
import '../widgets/startup_background.dart';

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
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            drawer: const AppDrawer(),
            body: StartupBackground(
              child: ListenableBuilder(
              listenable: transactionProvider,
              builder: (context, _) {
                final balance      = transactionProvider.totalBalance;
                final income       = transactionProvider.totalIncome;
                final expense      = transactionProvider.totalExpense;
                final transactions = transactionProvider.filteredTransactions;

                return CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(child: _buildBalanceCard(balance, income, expense)),
                    SliverToBoxAdapter(child: _buildFilterBar()),
                    SliverToBoxAdapter(child: _buildListHeader(transactions.length)),
                    _buildTransactionList(transactions),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              },
            ),
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
      backgroundColor: Colors.transparent,
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
              style: AppTextStyles.sectionLabel.copyWith(
                color: AppColors.accent,
                fontSize: 9,
                letterSpacing: 1.8,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  walletProvider.activeWallet?.name ?? 'Kas Utama',
                  style: AppTextStyles.title.copyWith(fontSize: 17),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.muted, size: 18),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.primaryText, size: 22),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Balance Card — PREMIUM GRADIENT ───────────────────────────────────────
  Widget _buildBalanceCard(double balance, double income, double expense) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 4, AppSpacing.md, 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.balanceCard,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          boxShadow: AppColors.balanceShadow,
        ),
        child: Stack(
          children: [
            // Decorative circles untuk depth
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: 60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 70,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              walletProvider.activeWallet?.name ?? 'Kas Utama',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Balance label
                  Text('Total Saldo', style: AppTextStyles.balanceLabel),
                  const SizedBox(height: 4),

                  // Balance amount
                  Text(
                    CurrencyFormatterHelper.formatRupiah(balance),
                    style: AppTextStyles.balance,
                  ),

                  const SizedBox(height: 20),

                  // Divider tipis
                  Container(height: 1, color: Colors.white.withValues(alpha: 0.15)),

                  const SizedBox(height: 16),

                  // Income / Expense row
                  Row(
                    children: [
                      Expanded(child: _buildCardStat(
                        label: 'Pemasukan',
                        amount: income,
                        icon: Icons.arrow_downward_rounded,
                        isIncome: true,
                      )),
                      Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.15)),
                      Expanded(child: _buildCardStat(
                        label: 'Pengeluaran',
                        amount: expense,
                        icon: Icons.arrow_upward_rounded,
                        isIncome: false,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStat({
    required String label,
    required double amount,
    required IconData icon,
    required bool isIncome,
  }) {
    final color = isIncome ? AppColors.success : AppColors.error;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.balanceLabel.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatterHelper.formatRupiah(amount),
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
            final label    = f['label'] as String;
            final icon     = f['icon']  as IconData;
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
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: isActive ? 14 : 10, vertical: 0),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : AppColors.surface,
            borderRadius: BorderRadius.circular(40),
            boxShadow: isActive ? [] : AppColors.softShadow,
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 16, AppSpacing.md, 8),
      child: Row(
        children: [
          Text(
            'Transaksi',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count item',
              style: TextStyle(
                color: AppColors.accentDark,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long_outlined, size: 30, color: AppColors.accent),
              ),
              const SizedBox(height: 14),
              Text('Belum ada transaksi', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Tambahkan pemasukan atau pengeluaran', style: AppTextStyles.caption),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final tx     = transactions[index];
            final isLast = index == transactions.length - 1;
            return _buildTransactionCard(tx, isLast);
          },
          childCount: transactions.length,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel tx, bool isLast) {
    final isIncome  = tx.type == TransactionType.pemasukan;
    final catColor  = CategoryHelper.getCategoryColor(tx.category);
    final catIcon   = CategoryHelper.getCategoryIcon(tx.category);
    final amtColor  = isIncome ? AppColors.success : AppColors.error;

    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE4E4),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
      ),
      confirmDismiss: (_) => _confirmDelete(tx),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            // Square icon — rounded corners, tinted bg
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(catIcon, color: catColor, size: 19),
            ),
            const SizedBox(width: 12),
            // Center
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
                  if (tx.title.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      tx.title,
                      style: AppTextStyles.micro.copyWith(color: AppColors.secondaryText, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '−'} ${CurrencyFormatterHelper.formatRupiah(tx.amount)}',
                  style: AppTextStyles.amount.copyWith(color: amtColor, fontSize: 14),
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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildBottomBtn(
              label: '+ Pemasukan',
              gradient: AppGradients.primaryCTA,
              textColor: Colors.white,
              onTap: () => _navigateToInput('Pemasukan'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildBottomBtn(
              label: '− Pengeluaran',
              bg: const Color(0xFFFFF0F0),
              textColor: AppColors.error,
              onTap: () => _navigateToInput('Pengeluaran'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBtn({
    required String label,
    LinearGradient? gradient,
    Color? bg,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: gradient,
          color: bg,
          borderRadius: BorderRadius.circular(40),
          boxShadow: gradient != null ? AppColors.balanceShadow.map((s) => BoxShadow(
            color: s.color.withValues(alpha: 0.15),
            blurRadius: s.blurRadius / 2,
            offset: s.offset / 2,
          )).toList() : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 13),
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
