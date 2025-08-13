import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskaia/core/managers/app_dialog.dart';
import 'package:taskaia/core/theme/app_strings.dart';
import 'package:taskaia/core/routing/app_routes.dart';
import 'package:taskaia/presentation/features/home/view/home_screen.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/auth_token_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _showSignupInstructions(BuildContext context) {
    AppDialog.showInstructionDialog(
      context,
      title: AppStrings.signupInstructions,
      content: AppStrings.signupInstructionsBody,
      buttonText: AppStrings.gotIt,
      onPressed: () {
        Navigator.of(context).pop(); // Close dialog
        // Navigate to signup with slide transition
        AppRoutes.navigateToSignup(
          context,
          transition: TransitionType.slideFromRight,
        );
      },
    );
  }

  Future<void> _continueAsGuest(BuildContext context) async {
    // Navigate to home as guest with fade transition
    AppRoutes.navigateWithTransition(
      context,
      const HomeScreen(),
      transition: TransitionType.fade,
      duration: const Duration(
        milliseconds: AppDimensions.animationVerySlow,
      ),
      clearStack: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenPadding = ResponsiveUtils.getScreenPadding(context);

    return ResponsiveScaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      useSafeArea: true,
      body: Center(
        child: SingleChildScrollView(
          padding: screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.welcomeBack,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontDisplay,
                  ),
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.textPrimary,
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  AppDimensions.spacing8,
                ),
              ),
              Text(
                AppStrings.signInToPlan,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontLarge,
                  ),
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  AppDimensions.spacing32,
                ),
              ),
              const LoginForm(),
              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  AppDimensions.spacing24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.dontHaveAccount,
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
                  TextButton(
                    onPressed: () => _showSignupInstructions(context),
                    child: Text(
                      AppStrings.createOne,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          AppDimensions.fontMedium,
                        ),
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
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
              Center(
                child: TextButton(
                  onPressed: () => _continueAsGuest(context),
                  child: Text(
                    AppStrings.exploreAsGuest,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        AppDimensions.fontMedium,
                      ),
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  AppDimensions.spacing16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
