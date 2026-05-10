import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import 'wallet_provider.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _currentWalletId;
  String _statPeriod = 'Bulan Ini'; // Bulan Ini, Bulan Lalu, Semua

  TransactionProvider() {
    // Initial load will be triggered by the UI or when active wallet is ready
  }

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  bool get isLoading => _isLoading;
  String get statPeriod => _statPeriod;

  void setStatPeriod(String period) {
    _statPeriod = period;
    notifyListeners();
  }

  // Total Statistics
  double get totalBalance {
    return _transactions.fold(0.0, (sum, transaction) {
      return transaction.type == TransactionType.pemasukan 
          ? sum + transaction.amount 
          : sum - transaction.amount;
    });
  }

  double get totalIncome {
    return _transactions.fold(0.0, (sum, tx) => 
      tx.type == TransactionType.pemasukan ? sum + tx.amount : sum
    );
  }

  double get totalExpense {
    return _transactions.fold(0.0, (sum, tx) => 
      tx.type == TransactionType.pengeluaran ? sum + tx.amount : sum
    );
  }

  // Filtered Statistics based on period
  List<TransactionModel> get filteredTransactions {
    final now = DateTime.now();
    
    switch (_statPeriod) {
      case 'Harian':
        return _transactions.where((tx) => 
          tx.date.day == now.day && tx.date.month == now.month && tx.date.year == now.year
        ).toList();
      case 'Mingguan':
        final lastWeek = now.subtract(const Duration(days: 7));
        return _transactions.where((tx) => tx.date.isAfter(lastWeek)).toList();
      case 'Bulanan':
      case 'Bulan Ini':
        return _transactions.where((tx) => 
          tx.date.month == now.month && tx.date.year == now.year
        ).toList();
      case 'Tahunan':
        return _transactions.where((tx) => tx.date.year == now.year).toList();
      case 'Bulan Lalu':
        int prevMonth = now.month - 1;
        int year = now.year;
        if (prevMonth == 0) {
          prevMonth = 12;
          year -= 1;
        }
        return _transactions.where((tx) => 
          tx.date.month == prevMonth && tx.date.year == year
        ).toList();
      default:
        return _transactions;
    }
  }

  double get monthlyIncome {
    return filteredTransactions.fold(0.0, (sum, tx) => 
      tx.type == TransactionType.pemasukan ? sum + tx.amount : sum
    );
  }

  double get monthlyExpense {
    return filteredTransactions.fold(0.0, (sum, tx) => 
      tx.type == TransactionType.pengeluaran ? sum + tx.amount : sum
    );
  }

  double get monthlyBalance => monthlyIncome - monthlyExpense;

  double get expensePercentage {
    if (monthlyIncome == 0) return 0;
    return (monthlyExpense / monthlyIncome) * 100;
  }

  Map<String, double> get categoryExpenseSummaries {
    final summaries = <String, double>{};
    final expenses = filteredTransactions.where((tx) => tx.type == TransactionType.pengeluaran);
    
    for (var tx in expenses) {
      summaries[tx.category] = (summaries[tx.category] ?? 0.0) + tx.amount;
    }
    
    // Sort by amount descending
    final sortedEntries = summaries.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      
    return Map.fromEntries(sortedEntries);
  }

  Future<void> loadTransactions(String walletId) async {
    // Avoid redundant loading if already loaded for this wallet
    if (_currentWalletId == walletId && !_isLoading) {
      return;
    }

    _currentWalletId = walletId;
    _isLoading = true;
    notifyListeners();
    
    _transactions = await StorageService.loadTransactions(walletId);
    
    _isLoading = false;
    notifyListeners();
  }

  void addTransaction(TransactionModel transaction) {
    if (_currentWalletId == null) return;
    _transactions.insert(0, transaction);
    StorageService.saveTransactions(_currentWalletId!, _transactions);
    notifyListeners();
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    if (_currentWalletId == null) return;
    final index = _transactions.indexWhere((tx) => tx.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      StorageService.saveTransactions(_currentWalletId!, _transactions);
      notifyListeners();
    }
  }

  void deleteTransaction(TransactionModel transaction) {
    if (_currentWalletId == null) return;
    _transactions.removeWhere((tx) => tx.id == transaction.id);
    StorageService.saveTransactions(_currentWalletId!, _transactions);
    notifyListeners();
  }

  void clearAllTransactions() {
    if (_currentWalletId == null) return;
    _transactions.clear();
    StorageService.saveTransactions(_currentWalletId!, _transactions);
    notifyListeners();
  }
}

final transactionProvider = TransactionProvider();
