import 'package:flutter/material.dart';
import '../utils/category_helper.dart';
import '../utils/app_styles.dart';

class CategoryChip extends StatelessWidget {
  final String category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: CategoryHelper.getCategoryColor(category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CategoryHelper.getCategoryColor(category).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CategoryHelper.getCategoryIcon(category),
            size: 14,
            color: CategoryHelper.getCategoryColor(category),
          ),
          const SizedBox(width: 4),
          Text(
            category,
            style: AppTextStyles.caption.copyWith(
              color: CategoryHelper.getCategoryColor(category),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
