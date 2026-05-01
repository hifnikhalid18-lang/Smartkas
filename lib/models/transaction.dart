enum TransactionType { pemasukan, pengeluaran }

class TransactionModel {
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.index,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: TransactionType.values[json['type']],
    );
  }
}
