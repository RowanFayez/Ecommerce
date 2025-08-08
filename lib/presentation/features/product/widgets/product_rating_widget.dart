import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';

class ProductRatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const ProductRatingWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Star Rating
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating.floor()
                  ? Icons.star
                  : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
              color: AppColors.ratingYellow, // Changed from Colors.amber
              size: 20,
            );
          }),
        ),

        const SizedBox(width: 8),

        // Rating Number
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.textPrimary,
          ),
        ),

        const SizedBox(width: 8),

        // Review Count
        Text(
          '($reviewCount ${AppStrings.reviews})', // Added from AppStrings
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
