import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class StorageService {
  static const String _storageKey = 'transactions';

  static Future<List<TransactionModel>> loadTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_storageKey);
      
      if (data == null) return [];
      
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTransactions(List<TransactionModel> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String data = jsonEncode(
        transactions.map((transaction) => transaction.toJson()).toList(),
      );
      await prefs.setString(_storageKey, data);
    } catch (e) {
      // Handle error if necessary
    }
  }
}
