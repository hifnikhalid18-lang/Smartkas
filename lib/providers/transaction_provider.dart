import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];

  TransactionProvider() {
    _loadData();
  }

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  double get totalBalance {
    double balance = 0;
    for (var tx in _transactions) {
      if (tx.type == TransactionType.pemasukan) {
        balance += tx.amount;
      } else {
        balance -= tx.amount;
      }
    }
    return balance;
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString('transactions');
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        _transactions = jsonList.map((j) => TransactionModel.fromJson(j)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String data = jsonEncode(_transactions.map((t) => t.toJson()).toList());
      await prefs.setString('transactions', data);
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
    _saveData();
    notifyListeners();
  }
}

final transactionProvider = TransactionProvider();
