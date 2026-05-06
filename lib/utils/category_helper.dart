import 'package:flutter/material.dart';
import '../models/transaction.dart';

class CategoryHelper {
  static const List<String> expenseCategories = [
    'Makan',
    'Transportasi',
    'Belanja',
    'Tagihan',
    'Pendidikan',
    'Lainnya',
  ];

  static const List<String> incomeCategories = [
    'Gaji',
    'Bonus',
    'Jualan',
    'Kiriman',
    'Lainnya',
  ];

  static List<String> getCategoriesByType(TransactionType type) {
    return type == TransactionType.pengeluaran ? expenseCategories : incomeCategories;
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Makan': return Icons.restaurant_rounded;
      case 'Transportasi': return Icons.directions_car_rounded;
      case 'Belanja': return Icons.shopping_bag_rounded;
      case 'Tagihan': return Icons.receipt_long_rounded;
      case 'Pendidikan': return Icons.school_rounded;
      case 'Gaji': return Icons.payments_rounded;
      case 'Bonus': return Icons.card_giftcard_rounded;
      case 'Jualan': return Icons.storefront_rounded;
      case 'Kiriman': return Icons.send_rounded;
      default: return Icons.more_horiz_rounded;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Makan': return Colors.orange;
      case 'Transportasi': return Colors.blue;
      case 'Belanja': return Colors.purple;
      case 'Tagihan': return Colors.red;
      case 'Pendidikan': return Colors.indigo;
      case 'Gaji': return Colors.green;
      case 'Bonus': return Colors.amber;
      case 'Jualan': return Colors.teal;
      case 'Kiriman': return Colors.cyan;
      default: return Colors.grey;
    }
  }
}
