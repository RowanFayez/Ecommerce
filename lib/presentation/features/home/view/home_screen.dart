import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/animation/page_transitions.dart';
import 'package:taskaia/core/managers/app_bottom_sheet.dart';
import 'package:taskaia/core/managers/app_dialog.dart';
import 'package:taskaia/core/routing/app_routes.dart';
import 'package:taskaia/core/theme/theme_manager.dart';
import 'package:taskaia/core/di/injection.dart';
import 'package:taskaia/core/services/auth_token_store.dart';
import 'package:taskaia/presentation/features/product/screens/product_details_screen.dart';
import '../controller/home_controller.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../widgets/home_header.dart';
import '../widgets/category_chips.dart';
import '../widgets/staggered_products_grid.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/search_bar_widget.dart';
import '../../cart/cart_screen.dart';
import '../../user/user_screen.dart';
import '../../auth/controller/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeManager _themeManager = ThemeManager();
  late HomeController _homeController;
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeController = getIt<HomeController>();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _homeController.loadCategories();
    await _homeController.loadProducts();
  }

  void _showLoginRequiredDialog() {
    AppDialog.showInstructionDialog(
      context,
      title: 'Login Required',
      content:
          'You need to log in to access this feature. Please sign in to continue.',
      buttonText: 'Login Now',
      onPressed: () {
        Navigator.of(context).pop(); // Close dialog
        AppRoutes.navigateToLogin(
          context,
          clearStack: true,
          transition: TransitionType.slideFromLeft,
        );
      },
    );
  }

  void _handleCartAccess() {
    final authTokenStore = getIt<AuthTokenStore>();
    if (authTokenStore.isAuthenticated) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const CartScreen()));
    } else {
      _showLoginRequiredDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider.value(
      value: _homeController,
      child: Consumer<AuthTokenStore>(
        builder: (context, authTokenStore, child) {
          return Scaffold(
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.background,
            appBar: AppBar(
              backgroundColor:
                  isDark ? AppColors.darkBackground : AppColors.background,
              elevation: 0,
              leading: Icon(
                Icons.menu,
                size: ResponsiveUtils.getResponsiveIconSize(
                  context,
                  AppDimensions.iconMedium,
                ),
                color: isDark ? AppColors.darkText : AppColors.black,
              ),
              title: !authTokenStore.isAuthenticated
                  ? Text(
                      'Guest Mode',
                      style: TextStyle(
                        fontSize: AppDimensions.fontMedium,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    size: ResponsiveUtils.getResponsiveIconSize(
                      context,
                      AppDimensions.iconMedium,
                    ),
                    color: isDark ? AppColors.darkText : AppColors.black,
                  ),
                  tooltip: 'Cart',
                  onPressed: _handleCartAccess,
                ),
                IconButton(
                  icon: Icon(
                    Icons.person,
                    size: ResponsiveUtils.getResponsiveIconSize(
                      context,
                      AppDimensions.iconMedium,
                    ),
                    color: isDark ? AppColors.darkText : AppColors.black,
                  ),
                  tooltip: 'Users',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const UserScreen()));
                  },
                ),
                Switch(
                  value: _themeManager.isDarkMode,
                  onChanged: (value) {
                    _themeManager.toggleTheme();
                    setState(() {});
                  },
                  activeColor: AppColors.primary,
                ),
                IconButton(
                  icon: Icon(
                    !authTokenStore.isAuthenticated
                        ? Icons.login
                        : Icons.logout,
                    size: ResponsiveUtils.getResponsiveIconSize(
                      context,
                      AppDimensions.iconMedium,
                    ),
                    color: isDark ? AppColors.darkText : AppColors.black,
                  ),
                  onPressed: !authTokenStore.isAuthenticated
                      ? () => _showLoginRequiredDialog()
                      : _showLogoutConfirmation,
                  tooltip: !authTokenStore.isAuthenticated
                      ? 'Login'
                      : AppStrings.logout,
                ),
              ],
            ),
            body: Consumer<HomeController>(
              builder: (context, controller, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),

                      // Search Bar
                      SearchBarWidget(
                        controller: _searchController,
                        onSearch: (query) {
                          // TODO: Implement search functionality
                          print('Searching for: $query');
                        },
                      ),

                      SizedBox(
                        height: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          AppDimensions.spacing20,
                        ),
                      ),

                      // Promotional Banner
                      const PromotionalBanner(),

                      SizedBox(
                        height: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          AppDimensions.spacing20,
                        ),
                      ),

                      // Category Chips
                      CategoryChips(
                        categories: controller.categories,
                        selectedCategory: controller.selectedCategory,
                        onCategorySelected: controller.selectCategory,
                      ),

                      SizedBox(
                        height: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          AppDimensions.spacing20,
                        ),
                      ),

                      // Products Grid with Loading/Error States
                      _buildProductsContent(controller),

                      // Bottom spacing for navigation bar
                      SizedBox(
                        height: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          AppDimensions.spacing32,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: AppDimensions.blurRadiusSmall,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        ResponsiveUtils.getResponsiveSpacing(context, 20),
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.home, 'Home', isDark),
                      _buildNavItem(
                          1, Icons.favorite_border, 'Favorites', isDark),
                      _buildNavItem(
                          2, Icons.notifications_none, 'Notifications', isDark),
                      _buildNavItem(3, Icons.person_outline, 'Profile', isDark),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? icon : icon,
            size: ResponsiveUtils.getResponsiveIconSize(
              context,
              AppDimensions.iconMedium,
            ),
            color: isSelected
                ? AppColors.primary
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
          Text(
            label,
            style: TextStyle(
              fontSize: AppDimensions.fontSmall,
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsContent(HomeController controller) {
    if (controller.isLoading) {
      return Container(
        height: 400,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (controller.error != null) {
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.warningRed,
              ),
              SizedBox(height: AppDimensions.spacing16),
              Text(
                'Failed to load products',
                style: TextStyle(
                  fontSize: AppDimensions.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.spacing8),
              Text(
                controller.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.fontMedium,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.spacing24),
              ElevatedButton(
                onPressed: controller.retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.products.isEmpty) {
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppColors.textLight,
              ),
              SizedBox(height: AppDimensions.spacing16),
              Text(
                'No products found',
                style: TextStyle(
                  fontSize: AppDimensions.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return StaggeredProductsGrid(
      products: controller.products,
      onProductTap: (product) {
        AppRoutes.navigateWithTransition(
          context,
          ProductDetailsScreen(product: product),
          transition: TransitionType.slideFromRight,
          duration: const Duration(
            milliseconds: AppDimensions.animationVerySlow,
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    AppBottomSheet.showConfirmationSheet(
      context,
      title: AppStrings.logoutConfirmation,
      message: AppStrings.logoutWarning,
      confirmText: AppStrings.confirmLogout,
      cancelText: AppStrings.cancel,
      confirmColor: AppColors.warningRed,
      onConfirm: () async {
        Navigator.of(context).pop();

        // Logout using AuthController
        final authController = AuthController();
        await authController.logout();

        // Navigate back to login
        AppRoutes.navigateToLogin(
          context,
          clearStack: true,
          transition: TransitionType.slideFromLeft,
        );
      },
    );
  }
}
