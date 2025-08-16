import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
          child: _CachedImage(
            url: imageUrl,
            fit: fit,
            width: width,
            height: height,
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

class _CachedImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const _CachedImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final manager = DefaultCacheManager();
    bool isValidHttpUrl(String u) {
      if (u.isEmpty) return false;
      final uri = Uri.tryParse(u);
      return uri != null &&
          (uri.isScheme('http') || uri.isScheme('https')) &&
          uri.host.isNotEmpty;
    }

    if (!isValidHttpUrl(url)) {
      return Container(
        color: AppColors.productImagePlaceholder,
        child: Icon(
          Icons.image_not_supported,
          size: AppDimensions.iconXLarge,
          color: AppColors.textLight,
        ),
      );
    }
    if (kIsWeb) {
      // Use browser caching on web
      return Image.network(
        url,
        fit: fit,
        width: width,
        height: height,
      );
    }
    return FutureBuilder<FileInfo?>(
      future: manager.getFileFromCache(url),
      builder: (context, snapshot) {
        final cached = snapshot.data;
        if (cached != null && cached.file.existsSync()) {
          return Image.file(
            cached.file,
            fit: fit,
            width: width,
            height: height,
          );
        }
        return StreamBuilder<FileResponse>(
          stream: manager.getFileStream(url, withProgress: true),
          builder: (context, snap) {
            final event = snap.data;
            if (event is FileInfo) {
              return Image.file(
                event.file,
                fit: fit,
                width: width,
                height: height,
              );
            }
            if (event is DownloadProgress) {
              return Center(
                child: CircularProgressIndicator(
                  value: event.totalSize != null && event.totalSize! > 0
                      ? event.downloaded / event.totalSize!
                      : null,
                  color: AppColors.primary,
                ),
              );
            }
            if (snap.hasError) {
              return Container(
                color: AppColors.productImagePlaceholder,
                child: Icon(
                  Icons.image_not_supported,
                  size: AppDimensions.iconXLarge,
                  color: AppColors.textLight,
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
        );
      },
    );
  }
}
