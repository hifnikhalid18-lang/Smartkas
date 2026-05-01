enum TransactionType { pemasukan, pengeluaran }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.index,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: TransactionType.values[json['type']],
    );
  }
}
