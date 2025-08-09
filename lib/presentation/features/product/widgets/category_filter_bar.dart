import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'category_chip.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final Map<String, IconData>? categoryIcons;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categoryIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveUtils.getResponsiveSpacing(context, 60),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing16),
        ),
        children: [
          // "All" category chip
          CategoryChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onTap: () => onCategorySelected(null),
            icon: Icons.apps,
          ),

          // Category chips
          ...categories.map((category) {
            return CategoryChip(
              label: _formatCategoryName(category),
              isSelected: selectedCategory == category,
              onTap: () => onCategorySelected(category),
              icon: categoryIcons?[category],
            );
          }),
        ],
      ),
    );
  }

  String _formatCategoryName(String category) {
    // Capitalize first letter and format category names
    return category.split(' ').map((word) {
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : word;
    }).join(' ');
  }
}

