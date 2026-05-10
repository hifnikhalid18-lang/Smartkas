import 'package:flutter/material.dart';
import '../providers/wallet_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_styles.dart';
import 'create_wallet_modal.dart';
import '../screens/wallet_management_screen.dart';

class WalletSelector extends StatelessWidget {
  const WalletSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          const Text('Pilih Kas / Dompet', style: AppTextStyles.title),
          const SizedBox(height: 16),
          Flexible(
            child: ListenableBuilder(
              listenable: walletProvider,
              builder: (context, _) => ListView.builder(
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
                    title: Text(
                      wallet.name,
                      style: AppTextStyles.body.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.accent) : null,
                    onTap: () {
                      walletProvider.setActiveWallet(wallet);
                      transactionProvider.loadTransactions(wallet.id);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_circle_outline_rounded, color: AppColors.accent),
            title: const Text('Tambah Kas Cepat', style: AppTextStyles.body),
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
          ListTile(
            leading: const Icon(Icons.settings_suggest_rounded, color: AppColors.secondaryText),
            title: const Text('Kelola Semua Kas', style: AppTextStyles.body),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletManagementScreen()));
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // DEPRECATED: showModalBottomSheet(context: context, builder: (context) => const WalletSelector())
  void _showWalletPicker(BuildContext context) {
    // This is now handled by the build method itself when used as a widget in a sheet
  }
}
