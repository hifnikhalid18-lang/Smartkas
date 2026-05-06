import 'package:flutter/material.dart';
import '../utils/category_helper.dart';
import '../models/transaction.dart';
import '../utils/app_styles.dart';

class CategoryDropdown extends StatelessWidget {
  final TransactionType type;
  final String selectedCategory;
  final Function(String?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.type,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = CategoryHelper.getCategoriesByType(type);
    
    // Ensure selectedCategory is in the current categories list
    final currentCategory = categories.contains(selectedCategory) 
        ? selectedCategory 
        : categories.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentCategory,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accent),
          onChanged: onChanged,
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  Icon(
                    CategoryHelper.getCategoryIcon(category),
                    size: 20,
                    color: CategoryHelper.getCategoryColor(category),
                  ),
                  const SizedBox(width: 12),
                  Text(category, style: AppTextStyles.body),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
