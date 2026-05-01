import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  // Inisialisasi dengan data dummy sesuai permintaan
  final List<TransactionModel> _transactions = [
    TransactionModel(
      title: 'Gaji Bulanan',
      amount: 10000,
      date: DateTime.now(),
      type: TransactionType.pemasukan,
    ),
    TransactionModel(
      title: 'Beli Kopi',
      amount: 5000,
      date: DateTime.now(),
      type: TransactionType.pengeluaran,
    ),
  ];

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

  void addTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }
}

final transactionProvider = TransactionProvider();
