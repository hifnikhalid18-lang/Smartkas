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
    _goals.add(goal);
    await StorageService.saveSavingsGoals(_goals);
    notifyListeners();
  }

  Future<void> updateGoal(SavingsGoalModel goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      await StorageService.saveSavingsGoals(_goals);
      notifyListeners();
    }
  }

  Future<void> addFunds(String goalId, double amount) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index].currentAmount += amount;
      await StorageService.saveSavingsGoals(_goals);
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((g) => g.id == goalId);
    await StorageService.saveSavingsGoals(_goals);
    notifyListeners();
  }
}

final savingsProvider = SavingsProvider();
