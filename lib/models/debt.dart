enum DebtType { hutang, piutang }

class DebtModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final DateTime? dueDate;
  final DebtType type;
  final bool isPaid;

  DebtModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.dueDate,
    required this.type,
    this.isPaid = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'type': type.index,
      'isPaid': isPaid,
    };
  }

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      type: DebtType.values[json['type']],
      isPaid: json['isPaid'] ?? false,
    );
  }

  DebtModel copyWith({
    String? title,
    double? amount,
    DateTime? dueDate,
    bool? isPaid,
  }) {
    return DebtModel(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date,
      dueDate: dueDate ?? this.dueDate,
      type: type,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
