import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];

  TransactionProvider() {
    _initializeData();
  }

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  double get totalBalance {
    return _transactions.fold(0.0, (sum, transaction) {
      if (transaction.type == TransactionType.pemasukan) {
        return sum + transaction.amount;
      }
      return sum - transaction.amount;
    });
  }

  Future<void> _initializeData() async {
    final loadedTransactions = await StorageService.loadTransactions();
    
    if (loadedTransactions.isEmpty) {
      _transactions = [
        TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Saldo Awal',
          amount: 50000,
          date: DateTime.now(),
          type: TransactionType.pemasukan,
        ),
      ];
      await StorageService.saveTransactions(_transactions);
    } else {
      _transactions = loadedTransactions;
    }
    
    notifyListeners();
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
    StorageService.saveTransactions(_transactions);
    notifyListeners();
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    final index = _transactions.indexWhere((tx) => tx.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      StorageService.saveTransactions(_transactions);
      notifyListeners();
    }
  }

  void deleteTransaction(TransactionModel transaction) {
    _transactions.removeWhere((tx) => tx.id == transaction.id);
    StorageService.saveTransactions(_transactions);
    notifyListeners();
  }
}

final transactionProvider = TransactionProvider();
