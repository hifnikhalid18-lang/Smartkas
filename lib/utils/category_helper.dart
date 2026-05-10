import 'package:flutter/material.dart';
import '../models/transaction.dart';

class CategoryHelper {
  static const List<String> expenseCategories = [
    'Makan & Minum',
    'Transportasi',
    'Belanja',
    'Tagihan',
    'Pendidikan',
    'Beli Buku',
    'Kebutuhan Rumah',
    'Kebutuhan Sekolah',
    'Hiburan',
    'Kesehatan',
    'Lainnya',
  ];

  static const List<String> incomeCategories = [
    'Gaji',
    'Jualan',
    'Bonus',
    'Pemberian',
    'Kiriman',
    'Hasil',
    'Investasi',
    'Lainnya',
  ];

  static List<String> getCategoriesByType(TransactionType type) {
    return type == TransactionType.pengeluaran ? expenseCategories : incomeCategories;
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      // Expenses
      case 'Makan & Minum': return Icons.restaurant_rounded;
      case 'Transportasi': return Icons.directions_car_rounded;
      case 'Belanja': return Icons.shopping_bag_rounded;
      case 'Tagihan': return Icons.receipt_long_rounded;
      case 'Pendidikan': return Icons.school_rounded;
      case 'Beli Buku': return Icons.menu_book_rounded;
      case 'Kebutuhan Rumah': return Icons.home_rounded;
      case 'Kebutuhan Sekolah': return Icons.backpack_rounded;
      case 'Hiburan': return Icons.movie_rounded;
      case 'Kesehatan': return Icons.medical_services_rounded;
      
      // Incomes
      case 'Gaji': return Icons.payments_rounded;
      case 'Jualan': return Icons.storefront_rounded;
      case 'Bonus': return Icons.card_giftcard_rounded;
      case 'Pemberian': return Icons.volunteer_activism_rounded;
      case 'Kiriman': return Icons.send_rounded;
      case 'Hasil': return Icons.trending_up_rounded;
      case 'Investasi': return Icons.show_chart_rounded;
      
      default: return Icons.more_horiz_rounded;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      // Expenses
      case 'Makan & Minum': return Colors.orange;
      case 'Transportasi': return Colors.blue;
      case 'Belanja': return Colors.purple;
      case 'Tagihan': return Colors.red;
      case 'Pendidikan': return Colors.indigo;
      case 'Beli Buku': return Colors.brown;
      case 'Kebutuhan Rumah': return Colors.teal;
      case 'Kebutuhan Sekolah': return Colors.blueGrey;
      case 'Hiburan': return Colors.pink;
      case 'Kesehatan': return Colors.green;
      
      // Incomes
      case 'Gaji': return const Color(0xFF22C55E); // Success green
      case 'Jualan': return const Color(0xFF0EA5E9); // Sky blue
      case 'Bonus': return const Color(0xFFF59E0B); // Amber
      case 'Pemberian': return const Color(0xFFEC4899); // Pink
      case 'Kiriman': return const Color(0xFF8B5CF6); // Violet
      case 'Hasil': return const Color(0xFF14B8A6); // Teal
      case 'Investasi': return const Color(0xFF6366F1); // Indigo
      
      default: return Colors.grey;
    }
  }
}
