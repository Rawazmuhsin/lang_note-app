import 'package:flutter/material.dart';
import 'package:langnote/utils/category_helper.dart';
import 'package:langnote/constants/theme_colors.dart';

class CategoryFilterChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = CategoryHelper.getAllCategories();

    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CategoryHelper.getEmoji(category),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  category,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) => onCategoryChanged(category),
            backgroundColor: Colors.white,
            selectedColor: ThemeColors.primaryPurple,
            checkmarkColor: Colors.white,
            elevation: isSelected ? 4 : 2,
            shadowColor:
                isSelected
                    ? ThemeColors.primaryPurple.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
            side: BorderSide(
              color:
                  isSelected ? ThemeColors.primaryPurple : Colors.grey.shade200,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
          );
        },
      ),
    );
  }
}
