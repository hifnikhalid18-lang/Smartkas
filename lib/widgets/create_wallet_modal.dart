import 'package:flutter/material.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_styles.dart';

class CreateWalletModal extends StatefulWidget {
  const CreateWalletModal({super.key});

  @override
  State<CreateWalletModal> createState() => _CreateWalletModalState();
}

class _CreateWalletModalState extends State<CreateWalletModal> {
  final _nameController = TextEditingController();
  IconData _selectedIcon = Icons.account_balance_wallet_rounded;

  final List<IconData> _icons = [
    Icons.account_balance_wallet_rounded,
    Icons.savings_rounded,
    Icons.payments_rounded,
    Icons.shopping_bag_rounded,
    Icons.home_rounded,
    Icons.school_rounded,
    Icons.group_rounded,
    Icons.work_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Kas Baru', style: AppTextStyles.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Nama Kas / Dompet',
              hintText: 'Contoh: Kas Kelas',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.edit_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Pilih Ikon', style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                final icon = _icons[index];
                final isSelected = icon == _selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
                      border: Border.all(color: isSelected ? AppColors.accent : AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: isSelected ? AppColors.accent : AppColors.secondaryText),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                walletProvider.addWallet(_nameController.text, _selectedIcon);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Simpan Kas', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
