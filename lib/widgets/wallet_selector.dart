import 'package:flutter/material.dart';
import '../providers/wallet_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_styles.dart';
import 'create_wallet_modal.dart';
import 'package:provider/provider.dart';

class WalletSelector extends StatelessWidget {
  const WalletSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: walletProvider,
      builder: (context, _) {
        if (walletProvider.isLoading) {
          return const SizedBox(height: 40, width: 40, child: CircularProgressIndicator(strokeWidth: 2));
        }

        final activeWallet = walletProvider.activeWallet;
        final wallets = walletProvider.wallets;

        return InkWell(
          onTap: () => _showWalletPicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(activeWallet?.icon ?? Icons.account_balance_wallet_rounded, size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(
                  activeWallet?.name ?? 'Pilih Kas',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.accent),
                ),
                const Icon(Icons.arrow_drop_down_rounded, color: AppColors.accent),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWalletPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('Pilih Kas / Dompet', style: AppTextStyles.title),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: walletProvider.wallets.length,
                itemBuilder: (context, index) {
                  final wallet = walletProvider.wallets[index];
                  final isSelected = wallet.id == walletProvider.activeWallet?.id;
                  
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isSelected ? AppColors.accent : AppColors.secondaryText).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(wallet.icon, color: isSelected ? AppColors.accent : AppColors.secondaryText),
                    ),
                    title: Text(wallet.name, style: AppTextStyles.body.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.accent) : null,
                    onTap: () {
                      walletProvider.setActiveWallet(wallet);
                      context.read<TransactionProvider>().loadTransactions(wallet.id);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_circle_outline_rounded, color: AppColors.accent),
              title: const Text('Tambah Kas Baru', style: AppTextStyles.body),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CreateWalletModal(),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
