import 'package:flutter/material.dart';
import '../models/savings_goal.dart';
import '../services/storage_service.dart';

class SavingsProvider extends ChangeNotifier {
  List<SavingsGoalModel> _goals = [];
  bool _isLoading = true;

  SavingsProvider() {
    loadGoals();
  }

  List<SavingsGoalModel> get goals => List.unmodifiable(_goals);
  bool get isLoading => _isLoading;

  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();
    _goals = await StorageService.loadSavingsGoals();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGoal(SavingsGoalModel goal) async {
    _goals.insert(0, goal);
    await StorageService.saveSavingsGoals(_goals);
    notifyListeners();
  }

  Future<void> updateGoal(SavingsGoalModel updatedGoal) async {
    final index = _goals.indexWhere((g) => g.id == updatedGoal.id);
    if (index != -1) {
      _goals[index] = updatedGoal;
      await StorageService.saveSavingsGoals(_goals);
      notifyListeners();
    }
  }

  Future<void> addDeposit(String id, double amount) async {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final updated = _goals[index].copyWith(
        currentAmount: _goals[index].currentAmount + amount,
      );
      // Check if completed
      if (updated.currentAmount >= updated.targetAmount) {
        _goals[index] = updated.copyWith(isCompleted: true);
      } else {
        _goals[index] = updated;
      }
      await StorageService.saveSavingsGoals(_goals);
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    await StorageService.saveSavingsGoals(_goals);
    notifyListeners();
  }
}

final savingsProvider = SavingsProvider();
