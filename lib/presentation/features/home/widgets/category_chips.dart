import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../product/widgets/category_chip.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    print(
        'CategoryChips build - Categories: $categories, Selected: $selectedCategory');

    if (categories.isEmpty) {
      print('CategoryChips: No categories available');
      return Container(
        height: ResponsiveUtils.getResponsiveSpacing(context, 80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
              SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              Text(
                'Loading categories...',
                style: TextStyle(
                  fontSize: AppDimensions.fontMedium,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: ResponsiveUtils.getHorizontalPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontTitle,
                  ),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${categories.length} categories',
                style: TextStyle(
                  fontSize: AppDimensions.fontSmall,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(
              context,
              AppDimensions.spacing16,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 50),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                print(
                    'Building category chip: $category, isSelected: $isSelected');

                return CategoryChip(
                  label: _formatCategoryName(category),
                  isSelected: isSelected,
                  onTap: () {
                    print('Category chip tapped: $category');
                    onCategorySelected(category);
                  },
                );
              },
            ),
          ),
          // Debug info
          if (categories.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                  top: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              child: Text(
                'Debug: Selected: "$selectedCategory" | Available: ${categories.join(", ")}',
                style: TextStyle(
                  fontSize: AppDimensions.fontSmall,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatCategoryName(String category) {
    if (category == 'all') return 'All';

    // Capitalize first letter of each word
    return category
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }
}
