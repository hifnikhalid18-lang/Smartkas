import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletProvider extends ChangeNotifier {
  List<WalletModel> _wallets = [];
  WalletModel? _activeWallet;
  bool _isLoading = true;

  WalletProvider() {
    loadWallets();
  }

  List<WalletModel> get wallets => List.unmodifiable(_wallets);
  WalletModel? get activeWallet => _activeWallet;
  bool get isLoading => _isLoading;

  Future<void> loadWallets() async {
    _isLoading = true;
    notifyListeners();

    _wallets = await StorageService.loadWallets();
    
    // Create default wallet if none exists
    if (_wallets.isEmpty) {
      final defaultWallet = WalletModel(
        id: 'default_kas',
        name: 'Dompet Utama',
        icon: Icons.account_balance_wallet_rounded,
      );
      _wallets = [defaultWallet];
      await StorageService.saveWallets(_wallets);
    }

    final prefs = await SharedPreferences.getInstance();
    final activeId = prefs.getString('active_wallet_id') ?? _wallets.first.id;
    
    _activeWallet = _wallets.firstWhere((w) => w.id == activeId, orElse: () => _wallets.first);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setActiveWallet(WalletModel wallet) async {
    _activeWallet = wallet;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_wallet_id', wallet.id);
    notifyListeners();
  }

  Future<void> addWallet(String name, IconData icon) async {
    final newWallet = WalletModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: icon,
    );
    _wallets.add(newWallet);
    await StorageService.saveWallets(_wallets);
    notifyListeners();
  }

  Future<void> deleteWallet(WalletModel wallet) async {
    if (_wallets.length <= 1) return; // Cannot delete last wallet
    
    _wallets.removeWhere((w) => w.id == wallet.id);
    await StorageService.saveWallets(_wallets);
    
    if (_activeWallet?.id == wallet.id) {
      setActiveWallet(_wallets.first);
    } else {
      notifyListeners();
    }
  }
}

final walletProvider = WalletProvider();
