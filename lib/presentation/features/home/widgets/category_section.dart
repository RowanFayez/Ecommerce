import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../product/widgets/category_chip.dart';

class CategorySection extends StatelessWidget {
  final String categoryName;

  const CategorySection({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.getHorizontalPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontTitle,
              ),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(
              context,
              AppDimensions.spacing16,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 50),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryChip(label: 'All', isSelected: true, onTap: () {}),
                CategoryChip(label: 'Modern', isSelected: false, onTap: () {}),
                CategoryChip(label: 'Classic', isSelected: false, onTap: () {}),
                CategoryChip(label: 'Luxury', isSelected: false, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
