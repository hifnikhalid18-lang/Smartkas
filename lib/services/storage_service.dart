import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import '../models/savings_goal.dart';

class StorageService {
  static const String _transactionsPrefix = 'transactions_';
  static const String _walletsKey = 'app_wallets';
  static const String _savingsKey = 'app_savings_goals';

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
}
