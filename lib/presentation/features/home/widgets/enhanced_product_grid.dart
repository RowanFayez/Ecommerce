import 'package:flutter/material.dart';
import 'package:taskaia/presentation/features/product/widgets/category_chip.dart';
import 'package:taskaia/presentation/features/product/widgets/product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/product.dart';

class EnhancedProductGrid extends StatefulWidget {
  final List<Product> products;
  final List<String> categories;
  final Function(Product) onProductTap;
  final Function(Product)? onCartPressed;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const EnhancedProductGrid({
    super.key,
    required this.products,
    required this.categories,
    required this.onProductTap,
    this.onCartPressed,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  State<EnhancedProductGrid> createState() => _EnhancedProductGridState();
}

class _EnhancedProductGridState extends State<EnhancedProductGrid> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String _searchQuery = '';

  List<Product> get filteredProducts {
    return widget.products.where((product) {
      final matchesSearch =
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          product.category.toLowerCase() == _selectedCategory!.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        // App Bar Header
        SliverAppBar(
          expandedHeight: ResponsiveUtils.getResponsiveSpacing(context, 120),
          floating: false,
          pinned: true,
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.background,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(
              left: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing16),
              bottom: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing16),
            ),
            title: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          AppDimensions.fontMedium,
                        ),
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Falcon Thought',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          AppDimensions.fontXLarge,
                        ),
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.darkText : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.darkBackground,
                          AppColors.darkBackground.withOpacity(0.8),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background,
                          AppColors.background.withOpacity(0.8),
                        ],
                      ),
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                right: ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.spacing16),
              ),
              width: ResponsiveUtils.getResponsiveSpacing(context, 40),
              height: ResponsiveUtils.getResponsiveSpacing(context, 40),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow.withOpacity(0.1),
                    blurRadius:
                        ResponsiveUtils.getResponsiveSpacing(context, 8),
                    offset: Offset(
                        0, ResponsiveUtils.getResponsiveSpacing(context, 2)),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                size: ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.iconMedium),
              ),
            ),
          ],
        ),

        // Search Bar
        SliverToBoxAdapter(
          child: ProductSearchBar(
            controller: _searchController,
            hintText: 'What are you looking for...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onFilterPressed: () {
              // Handle filter action
            },
          ),
        ),

        // Promotion Banner
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing16),
              vertical: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.radiusLarge),
              ),
              child: Container(
                height: ResponsiveUtils.getResponsiveSpacing(context, 120),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: ResponsiveUtils.getResponsiveSpacing(context, 20),
                      top: ResponsiveUtils.getResponsiveSpacing(context, 10),
                      child: Container(
                        width:
                            ResponsiveUtils.getResponsiveSpacing(context, 100),
                        height:
                            ResponsiveUtils.getResponsiveSpacing(context, 100),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getResponsiveSpacing(
                                context, AppDimensions.radiusLarge),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.spacing20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Shop wit us!',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                AppDimensions.fontMedium,
                              ),
                              color: AppColors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Get 40% off for\nall items',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                AppDimensions.fontXLarge,
                              ),
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(
                              height: ResponsiveUtils.getResponsiveSpacing(
                                  context, AppDimensions.spacing8)),
                          Row(
                            children: [
                              Text(
                                'Shop Now',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                    context,
                                    AppDimensions.fontMedium,
                                  ),
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                  width: ResponsiveUtils.getResponsiveSpacing(
                                      context, AppDimensions.spacing8)),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.white,
                                size: ResponsiveUtils.getResponsiveSpacing(
                                    context, AppDimensions.iconSmall),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Category Filter
        SliverToBoxAdapter(
          child: CategoryFilterBar(
            categories: widget.categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
            categoryIcons: {
              'electronics': Icons.devices,
              'jewelery': Icons.diamond,
              'men\'s clothing': Icons.checkroom,
              'women\'s clothing': Icons.woman,
            },
          ),
        ),

        // Products Grid
        if (widget.isLoading)
          SliverToBoxAdapter(
            child: Container(
              height: ResponsiveUtils.getResponsiveSpacing(context, 300),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(
                          context, AppDimensions.iconXLarge),
                      height: ResponsiveUtils.getResponsiveSpacing(
                          context, AppDimensions.iconXLarge),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    SizedBox(
                        height: ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.spacing16)),
                    Text(
                      AppStrings.loading,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          AppDimensions.fontMedium,
                        ),
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (filteredProducts.isEmpty)
          SliverToBoxAdapter(
            child: Container(
              height: ResponsiveUtils.getResponsiveSpacing(context, 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: ResponsiveUtils.getResponsiveSpacing(context, 64),
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textLight,
                  ),
                  SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(
                          context, AppDimensions.spacing16)),
                  Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        AppDimensions.fontLarge,
                      ),
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.darkText : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(
                          context, AppDimensions.spacing8)),
                  Text(
                    'Try adjusting your search or filters',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        AppDimensions.fontMedium,
                      ),
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing16),
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
                childAspectRatio:
                    ResponsiveUtils.getGridChildAspectRatio(context) *
                        0.85, // Adjust for taller cards
                crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.spacing16),
                mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.spacing20),
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () => widget.onProductTap(product),
                    onCartPressed: widget.onCartPressed != null
                        ? () => widget.onCartPressed!(product)
                        : null,
                  );
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),

        // Bottom Spacing
        SliverToBoxAdapter(
          child: SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(
                context, AppDimensions.spacing32),
          ),
        ),
      ],
    );
  }
}
