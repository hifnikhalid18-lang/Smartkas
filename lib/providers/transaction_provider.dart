import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];

  TransactionProvider() {
    _initializeData();
  }

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  // Menghitung saldo total menggunakan metode fold untuk efisiensi
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
      // Data dummy awal agar aplikasi tidak terlihat kosong saat pertama kali dibuka
      _transactions = [
        TransactionModel(
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
}

// Global instance untuk mempermudah akses state di seluruh aplikasi
final transactionProvider = TransactionProvider();
