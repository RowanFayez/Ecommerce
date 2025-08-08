import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class ReusableProductImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final double? aspectRatio;
  final double? borderRadius;
  final BoxFit fit;
  final bool showShadow;
  final double? width;
  final double? height;

  const ReusableProductImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.aspectRatio,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.showShadow = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Hero(
      tag: heroTag,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.productImagePlaceholder,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: AppDimensions.blurRadiusMedium,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : BorderRadius.zero,
          child: Image.network(
            imageUrl,
            fit: fit,
            width: width,
            height: height,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: AppColors.productImagePlaceholder,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.productImagePlaceholder,
              child: Icon(
                Icons.image_not_supported,
                size: AppDimensions.iconXLarge,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
      ),
    );

    // If aspectRatio is provided, wrap with AspectRatio
    if (aspectRatio != null) {
      imageWidget = AspectRatio(
        aspectRatio: aspectRatio!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
