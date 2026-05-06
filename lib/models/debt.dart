import 'package:flutter/material.dart';

enum DebtType { hutang, piutang }

class DebtModel {
  final String id;
  final String personName;
  final double amount;
  final DebtType type;
  final DateTime date;
  bool isPaid;

  DebtModel({
    required this.id,
    required this.personName,
    required this.amount,
    required this.type,
    required this.date,
    this.isPaid = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'amount': amount,
      'type': type.index,
      'date': date.toIso8601String(),
      'isPaid': isPaid,
    };
  }

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'],
      personName: json['personName'],
      amount: json['amount'],
      type: DebtType.values[json['type']],
      date: DateTime.parse(json['date']),
      isPaid: json['isPaid'],
    );
  }
}
