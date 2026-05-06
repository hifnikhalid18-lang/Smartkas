import 'package:flutter/material.dart';

class SavingsGoalModel {
  final String id;
  final String title;
  final double targetAmount;
  double currentAmount;
  final DateTime? deadline;
  final IconData icon;

  SavingsGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.deadline,
    this.icon = Icons.savings_rounded,
  });

  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0.0;
  bool get isReached => currentAmount >= targetAmount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline?.toIso8601String(),
      'icon_code': icon.codePoint,
    };
  }

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) {
    return SavingsGoalModel(
      id: json['id'],
      title: json['title'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      icon: IconData(json['icon_code'], fontFamily: 'MaterialIcons'),
    );
  }
}
