import 'package:flutter/material.dart';
import '../models/debt.dart';
import '../services/storage_service.dart';

class DebtProvider extends ChangeNotifier {
  List<DebtModel> _debts = [];
  bool _isLoading = true;

  DebtProvider() {
    loadDebts();
  }

  List<DebtModel> get debts => List.unmodifiable(_debts);
  bool get isLoading => _isLoading;

  double get totalHutang {
    return _debts
        .where((d) => d.type == DebtType.hutang && !d.isPaid)
        .fold(0.0, (sum, d) => sum + d.amount);
  }

  double get totalPiutang {
    return _debts
        .where((d) => d.type == DebtType.piutang && !d.isPaid)
        .fold(0.0, (sum, d) => sum + d.amount);
  }

  Future<void> loadDebts() async {
    _isLoading = true;
    notifyListeners();
    _debts = await StorageService.loadDebts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDebt(DebtModel debt) async {
    _debts.add(debt);
    await StorageService.saveDebts(_debts);
    notifyListeners();
  }

  Future<void> updateDebt(DebtModel debt) async {
    final index = _debts.indexWhere((d) => d.id == debt.id);
    if (index != -1) {
      _debts[index] = debt;
      await StorageService.saveDebts(_debts);
      notifyListeners();
    }
  }

  Future<void> togglePaidStatus(String id) async {
    final index = _debts.indexWhere((d) => d.id == id);
    if (index != -1) {
      _debts[index].isPaid = !_debts[index].isPaid;
      await StorageService.saveDebts(_debts);
      notifyListeners();
    }
  }

  Future<void> deleteDebt(String id) async {
    _debts.removeWhere((d) => d.id == id);
    await StorageService.saveDebts(_debts);
    notifyListeners();
  }
}

final debtProvider = DebtProvider();
