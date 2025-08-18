import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taskaia/core/managers/app_bottom_sheet.dart';
import 'package:taskaia/core/managers/app_dialog.dart';
import 'package:taskaia/core/routing/app_routes.dart';
import 'package:taskaia/core/theme/theme_manager.dart';
import 'package:taskaia/core/di/injection.dart';
import 'package:taskaia/core/services/auth_token_store.dart';
import 'package:taskaia/presentation/features/product/screens/product_details_screen.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../widgets/home_header.dart';
import '../widgets/category_chips.dart';
import '../widgets/staggered_products_grid.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/search_bar_widget.dart';
import '../../cart/cart_screen.dart';
import '../../user/user_screen.dart';
import '../../auth/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeManager _themeManager = ThemeManager();
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // No-op here; we'll dispatch init in BlocProvider's builder
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // No local load; Bloc handles initialization

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<AuthTokenStore>()),
      ],
      child: Consumer<AuthTokenStore>(
        builder: (context, authTokenStore, child) {
          return BlocProvider(
            create: (_) =>
                getIt<ProductBloc>()..add(const ProductsInitialized()),
            child: Scaffold(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UserScreen()));
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
              body: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (_currentIndex == 3) {
                    return _buildProfileTab(context, authTokenStore);
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeHeader(),
                        SearchBarWidget(
                          controller: _searchController,
                          onSearch: (query) {},
                        ),
                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            AppDimensions.spacing20,
                          ),
                        ),
                        const PromotionalBanner(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            AppDimensions.spacing20,
                          ),
                        ),
                        BlocBuilder<ProductBloc, ProductState>(
                          buildWhen: (p, c) =>
                              c is ProductLoadSuccess ||
                              c is ProductLoadInProgress ||
                              c is ProductLoadFailure,
                          builder: (context, state) {
                            if (state is ProductLoadSuccess) {
                              return CategoryChips(
                                categories: state.categories,
                                selectedCategory: state.selectedCategory,
                                onCategorySelected: (categ) => context
                                    .read<ProductBloc>()
                                    .add(CategorySelected(categ)),
                              );
                            }
                            return const SizedBox(
                                height: 80,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.primary))); 
                          },
                        ),
                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            AppDimensions.spacing20,
                          ),
                        ),
                        _buildProductsContent(state),
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
                      vertical:
                          ResponsiveUtils.getResponsiveSpacing(context, 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(0, Icons.home, 'Home', isDark),
                        _buildNavItem(
                            1, Icons.favorite_border, 'Favorites', isDark),
                        _buildNavItem(2, Icons.notifications_none,
                            'Notifications', isDark),
                        _buildNavItem(
                            3, Icons.person_outline, 'Profile', isDark),
                      ],
                    ),
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

  Widget _buildProductsContent(ProductState state) {
    if (state is ProductLoadInProgress) {
      return Container(
        height: 400,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (state is ProductLoadFailure) {
      final isOfflineNoCache =
          state.message.toLowerCase().contains('connect to wi');
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isOfflineNoCache ? Icons.wifi_off_rounded : Icons.error_outline,
                size: 64,
                color: isOfflineNoCache
                    ? AppColors.textSecondary
                    : AppColors.warningRed,
              ),
              SizedBox(height: AppDimensions.spacing16),
              Text(
                isOfflineNoCache
                    ? 'No internet connection'
                    : 'Failed to load products',
                style: TextStyle(
                  fontSize: AppDimensions.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.spacing8),
              Text(
                isOfflineNoCache ? 'Connect to Wi‑Fi please' : state.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.fontMedium,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.spacing24),
              ElevatedButton(
                onPressed: () => context
                    .read<ProductBloc>()
                    .add(const ProductsRetryRequested()),
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

    if (state is ProductLoadSuccess && state.products.isEmpty) {
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

    if (state is ProductLoadSuccess) {
      return StaggeredProductsGrid(
        products: state.products,
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

    return const SizedBox.shrink();
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

  Widget _buildProfileTab(BuildContext context, AuthTokenStore authTokenStore) {
    final fbUser = fb.FirebaseAuth.instance.currentUser;
    if (authTokenStore.isAuthenticated && fbUser != null) {
      // Google account profile
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    fbUser.photoURL != null ? NetworkImage(fbUser.photoURL!) : null,
                child: fbUser.photoURL == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(fbUser.displayName ?? 'Google User',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(fbUser.email ?? '', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    if (authTokenStore.isAuthenticated) {
      // Non-google auth: show API users list screen
      return const UserScreen();
    }

    // Guest
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 64, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text('You have no account yet'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AppRoutes.navigateToLogin(context);
                  },
                  child: const Text('Create account'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () async {
                    final result = await AuthController().loginWithGoogle();
                    if (result['success'] == true && mounted) {
                      setState(() {});
                    }
                  },
                  child: const Text('Sign in with Google'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
