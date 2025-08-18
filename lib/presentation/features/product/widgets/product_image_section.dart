import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:taskaia/data/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'notched_bottom_clipper.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../../../core/services/auth_token_store.dart';
import '../../../../core/di/injection.dart';

class ProductImageSection extends StatelessWidget {
  final Product product;
  final VoidCallback? onCartPressed;

  const ProductImageSection({
    super.key,
    required this.product,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notchRadius = ResponsiveUtils.getResponsiveSpacing(context, 28);
    final cartInnerSize = ResponsiveUtils.getResponsiveSpacing(context, 32);
    final cornerRadius =
        ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.radiusLarge);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: NotchedBottomClipper(
            cornerRadius: cornerRadius,
            notchRadius: notchRadius,
            notchVerticalOverflow:
                ResponsiveUtils.getResponsiveSpacing(context, 10),
            horizontalRadiusFactor: 1.4,
          ),
          child: SizedBox.expand(
            child: Hero(
              tag: 'product-image-${product.id}',
              child: _buildCachedImage(context, isDark),
            ),
          ),
        ),

        // Favorite Button (Top Right)
        Positioned(
          top: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing12),
          right: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing12),
          child: _FavoriteButton(product: product, isDark: isDark),
        ),

        // Small dark cart icon centered at notch
        Positioned(
          bottom: -ResponsiveUtils.getResponsiveSpacing(
              context, (cartInnerSize / 2) - 2),
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: onCartPressed ?? () => _handleAddToCart(context),
              child: Container(
                width: cartInnerSize,
                height: cartInnerSize,
                decoration: BoxDecoration(
                  color: AppColors.cartButtonBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withOpacity(0.35),
                      blurRadius:
                          ResponsiveUtils.getResponsiveSpacing(context, 8),
                      offset:
                          Offset(0, ResponsiveUtils.getResponsiveSpacing(context, 3)),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.white,
                  size: ResponsiveUtils.getResponsiveSpacing(
                      context, cartInnerSize * 0.45),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCachedImage(BuildContext context, bool isDark) {
    final manager = DefaultCacheManager();
    final url = product.image;

    bool isValidHttpUrl(String u) {
      if (u.isEmpty) return false;
      final uri = Uri.tryParse(u);
      return uri != null && (uri.isScheme('http') || uri.isScheme('https')) && uri.host.isNotEmpty;
    }

  if (!isValidHttpUrl(url)) {
      return _errorPlaceholder(context, isDark);
    }

    return FutureBuilder<FileInfo?>(
      future: manager.getFileFromCache(url),
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (!kIsWeb && info != null && info.file.existsSync()) {
          return Image.file(info.file, fit: BoxFit.cover);
        }
        if (kIsWeb) {
          // On web, prefer browser caching with Image.network
          return Image.network(url, fit: BoxFit.cover);
        }
        // Not cached: stream and show progress or errors
  return StreamBuilder<FileResponse>(
          stream: manager.getFileStream(url, withProgress: true),
          builder: (context, snap) {
            final event = snap.data;
            if (event is FileInfo) {
              return kIsWeb
                  ? Image.network(url, fit: BoxFit.cover)
                  : Image.file(event.file, fit: BoxFit.cover);
            }
            if (event is DownloadProgress) {
              return _loadingPlaceholder(context, isDark);
            }
            if (snap.hasError) {
              return _errorPlaceholder(context, isDark);
            }
            return _loadingPlaceholder(context, isDark);
          },
        );
      },
    );
  }

  Widget _loadingPlaceholder(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.productImagePlaceholder,
      child: Center(
        child: SizedBox(
          width: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.iconMedium),
          height: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.iconMedium),
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _errorPlaceholder(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.productImagePlaceholder,
      child: Icon(
        Icons.image_not_supported_outlined,
        size:
            ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.iconXLarge),
        color: isDark ? AppColors.darkTextSecondary : AppColors.textLight,
      ),
    );
  }

  void _handleAddToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(
              width: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing8),
            ),
            Expanded(
              child: Text(
                '${product.title} added to cart!',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontMedium,
                  ),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveSpacing(
                context, AppDimensions.radiusMedium),
          ),
        ),
        margin: EdgeInsets.all(
          ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final Product product;
  final bool isDark;
  const _FavoriteButton({required this.product, required this.isDark});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _toggling = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavoritesCubit?>();
    final favState = context.watch<FavoritesCubit?>()?.state;
    final isFav = favState?.ids.contains(widget.product.id) ?? false;

    return GestureDetector(
      onTap: cubit == null || _toggling
          ? null
          : () async {
              final user = fb.FirebaseAuth.instance.currentUser;
              final tokenStore = getIt<AuthTokenStore>();
              final allowed = user != null || tokenStore.isAuthenticated;
              final tokenKey = (tokenStore.token ?? 'api_user');
              final uid = user?.uid ?? 'api_${tokenKey.hashCode}';
              if (!allowed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login to save favorites')),
                );
                return;
              }
              setState(() => _toggling = true);
              await cubit.toggle(uid, widget.product);
              if (mounted) setState(() => _toggling = false);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: ResponsiveUtils.getResponsiveSpacing(context, 36),
        height: ResponsiveUtils.getResponsiveSpacing(context, 36),
        decoration: BoxDecoration(
          color: (widget.isDark ? AppColors.darkCard : AppColors.white)
              .withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.2),
              blurRadius: ResponsiveUtils.getResponsiveSpacing(context, 8),
              offset: Offset(0, ResponsiveUtils.getResponsiveSpacing(context, 2)),
            ),
          ],
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_outline,
          size: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.iconSmall),
          color: isFav
              ? Colors.red
              : (widget.isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary),
        ),
      ),
    );
  }
}
