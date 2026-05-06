import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;

  TransactionProvider() {
    loadTransactions();
  }

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  bool get isLoading => _isLoading;

  double get totalBalance {
    return _transactions.fold(0.0, (sum, transaction) {
      if (transaction.type == TransactionType.pemasukan) {
        return sum + transaction.amount;
      }
      return sum - transaction.amount;
    });
  }

  double get totalIncome {
    return _transactions.fold(0.0, (sum, transaction) {
      if (transaction.type == TransactionType.pemasukan) {
        return sum + transaction.amount;
      }
      return sum;
    });
  }

  double get totalExpense {
    return _transactions.fold(0.0, (sum, transaction) {
      if (transaction.type == TransactionType.pengeluaran) {
        return sum + transaction.amount;
      }
      return sum;
    });
  }

  // Monthly Statistics
  List<TransactionModel> get _monthlyTransactions {
    final now = DateTime.now();
    return _transactions.where((tx) => 
      tx.date.month == now.month && tx.date.year == now.year
    ).toList();
  }

  double get monthlyIncome {
    return _monthlyTransactions.fold(0.0, (sum, tx) => 
      tx.type == TransactionType.pemasukan ? sum + tx.amount : sum
    );
  }

  double get monthlyExpense {
    return _monthlyTransactions.fold(0.0, (sum, tx) => 
      tx.type == TransactionType.pengeluaran ? sum + tx.amount : sum
    );
  }

  double get monthlyBalance => monthlyIncome - monthlyExpense;

  double get expensePercentage {
    if (monthlyIncome == 0) return 0;
    return (monthlyExpense / monthlyIncome) * 100;
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();
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
    
    _isLoading = false;
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

  void clearAllTransactions() {
    _transactions.clear();
    StorageService.saveTransactions(_transactions);
    notifyListeners();
  }
}

final transactionProvider = TransactionProvider();
