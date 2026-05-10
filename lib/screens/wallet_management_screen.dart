import 'package:flutter/material.dart';
import '../providers/wallet_provider.dart';
import '../models/wallet.dart';
import '../utils/app_styles.dart';
import '../widgets/startup_background.dart';

class WalletManagementScreen extends StatelessWidget {
  const WalletManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Kelola Kas', style: AppTextStyles.title.copyWith(fontSize: 17)),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddWalletDialog(context),
            icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.accent),
            label: Text('Tambah', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: StartupBackground(
        child: ListenableBuilder(
          listenable: walletProvider,
        builder: (context, _) {
          final wallets = walletProvider.wallets;
          return CustomScrollView(
            slivers: [
              // Horizontal wallet carousel
              SliverToBoxAdapter(child: _buildCarousel(wallets)),
              // Section header
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(AppSpacing.md, 24, AppSpacing.md, 8),
                  child: Text('Semua Kas', style: AppTextStyles.subtitle),
                ),
              ),
              // List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final wallet = wallets[i];
                      final isActive = walletProvider.activeWallet?.id == wallet.id;
                      final isLast = i == wallets.length - 1;
                      return _buildWalletRow(ctx, wallet, isActive, isLast, wallets.length);
                    },
                    childCount: wallets.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
      ),
    );
  }

  // ── Horizontal Carousel ───────────────────────────────────────────────────
  Widget _buildCarousel(List<WalletModel> wallets) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, 8),
        itemCount: wallets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final w = wallets[index];
          final isActive = walletProvider.activeWallet?.id == w.id;
          return _buildCarouselCard(context, w, isActive);
        },
      ),
    );
  }

  Widget _buildCarouselCard(BuildContext context, WalletModel wallet, bool isActive) {
    return GestureDetector(
      onTap: () => walletProvider.setActiveWallet(wallet),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isActive ? AppGradients.accentSubtle : null,
          color: isActive ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: isActive ? AppColors.cardShadow : AppColors.softShadow,
          border: isActive ? null : Border.all(color: AppColors.border.withOpacity(0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  wallet.icon,
                  color: isActive ? Colors.white : AppColors.accent,
                  size: 18,
                ),
                const Spacer(),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('● Aktif', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              wallet.name,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.primaryText,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Wallet Row ────────────────────────────────────────────────────────────
  Widget _buildWalletRow(
    BuildContext context,
    WalletModel wallet,
    bool isActive,
    bool isLast,
    int total,
  ) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          ListTile(
            onTap: () => walletProvider.setActiveWallet(wallet),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive ? AppColors.accentLight : AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(wallet.icon, color: isActive ? AppColors.accent : AppColors.muted, size: 20),
            ),
            title: Text(
              wallet.name,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.accent : AppColors.primaryText,
              ),
            ),
            subtitle: Text(
              isActive ? '● Sedang digunakan' : 'Ketuk untuk beralih',
              style: AppTextStyles.micro.copyWith(color: isActive ? AppColors.accent : AppColors.muted),
            ),
            trailing: total > 1
                ? IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.muted),
                    onPressed: () => _confirmDelete(context, wallet),
                  )
                : null,
          ),
          if (!isLast) const Divider(height: 1, indent: 72, color: AppColors.hairline),
        ],
      ),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────
  void _confirmDelete(BuildContext context, WalletModel wallet) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Kas?'),
        content: Text('Hapus "${wallet.name}"? Semua transaksinya juga akan terhapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              walletProvider.deleteWallet(wallet);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Tambah Buku Kas', style: AppTextStyles.title.copyWith(fontSize: 16)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Contoh: Kas Organisasi',
            filled: true,
            fillColor: AppColors.cardBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                walletProvider.addWallet(ctrl.text.trim(), Icons.account_balance_wallet_rounded);
                Navigator.pop(ctx);
              }
            },
            child: Text('Simpan', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
