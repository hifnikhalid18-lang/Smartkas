import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import '../models/savings_goal.dart';
import '../models/debt.dart';

class StorageService {
  static const String _transactionsPrefix = 'transactions_';
  static const String _walletsKey = 'app_wallets';
  static const String _savingsKey = 'app_savings_goals';
  static const String _debtKey = 'app_debts';

  static Future<List<TransactionModel>> loadTransactions(String walletId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString('$_transactionsPrefix$walletId');
      
      if (data == null) return [];
      
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTransactions(String walletId, List<TransactionModel> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String data = jsonEncode(
        transactions.map((transaction) => transaction.toJson()).toList(),
      );
      await prefs.setString('$_transactionsPrefix$walletId', data);
    } catch (e) {
      // Handle error
    }
  }

  static Future<List<WalletModel>> loadWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_walletsKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => WalletModel.fromJson(json)).toList();
  }

  static Future<void> saveWallets(List<WalletModel> wallets) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(wallets.map((w) => w.toJson()).toList());
    await prefs.setString(_walletsKey, data);
  }

  static Future<List<SavingsGoalModel>> loadSavingsGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_savingsKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => SavingsGoalModel.fromJson(json)).toList();
  }

  static Future<void> saveSavingsGoals(List<SavingsGoalModel> goals) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(goals.map((g) => g.toJson()).toList());
    await prefs.setString(_savingsKey, data);
  }

  static Future<List<DebtModel>> loadDebts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_debtKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => DebtModel.fromJson(json)).toList();
  }

  static Future<void> saveDebts(List<DebtModel> debts) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(debts.map((d) => d.toJson()).toList());
    await prefs.setString(_debtKey, data);
  }

  // MASTER BACKUP HELPER
  static Future<Map<String, dynamic>> getAllAppData() async {
    final prefs = await SharedPreferences.getInstance();
    final allData = <String, dynamic>{};
    
    // Wallets
    allData['wallets'] = prefs.getString(_walletsKey);
    allData['savings'] = prefs.getString(_savingsKey);
    allData['debts'] = prefs.getString(_debtKey);
    
    // Transactions for each wallet
    final wallets = await loadWallets();
    final txData = <String, String?>{};
    for (var w in wallets) {
      txData[w.id] = prefs.getString('$_transactionsPrefix${w.id}');
    }
    allData['transactions'] = txData;
    
    return allData;
  }

  static Future<void> restoreAllAppData(Map<String, dynamic> masterData) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (masterData.containsKey('wallets') && masterData['wallets'] != null) {
      await prefs.setString(_walletsKey, masterData['wallets']);
    }
    if (masterData.containsKey('savings') && masterData['savings'] != null) {
      await prefs.setString(_savingsKey, masterData['savings']);
    }
    if (masterData.containsKey('debts') && masterData['debts'] != null) {
      await prefs.setString(_debtKey, masterData['debts']);
    }
    
    if (masterData.containsKey('transactions')) {
      final txMap = masterData['transactions'] as Map<String, dynamic>;
      for (var entry in txMap.entries) {
        if (entry.value != null) {
          await prefs.setString('$_transactionsPrefix${entry.key}', entry.value.toString());
        }
      }
    }
  }
}
