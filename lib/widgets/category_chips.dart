import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          final isSelected = selectedCategory == category;
          final color = category == 'all' 
              ? Colors.grey 
              : Helpers.getCategoryColor(category);
          
          return FilterChip(
            selected: isSelected,
            label: Text(AppConstants.getCategoryDisplayName(category)),
            avatar: category != 'all' 
                ? Icon(_getCategoryIcon(category), size: 18)
                : null,
            onSelected: (selected) {
              onCategorySelected(selected ? category : 'all');
            },
            backgroundColor: Colors.grey.shade100,
            selectedColor: color.withOpacity(0.2),
            checkmarkColor: color,
            labelStyle: TextStyle(
              color: isSelected ? color : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'children': return Icons.child_care;
      case 'horror': return Icons.heart_broken;
      case 'romance': return Icons.favorite;
      case 'drama': return Icons.theater_comedy;
      case 'fantasy': return Icons.stacked_bar_chart;
      default: return Icons.category;
    }
  }
}