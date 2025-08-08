import 'package:flutter/material.dart';
import 'package:taskaia/core/managers/app_toast.dart';
import 'package:taskaia/core/theme/app_strings.dart';
import 'package:taskaia/core/routing/app_routes.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../controller/auth_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authController.login(
          _emailController.text,
          _passwordController.text,
        );

        // Show success toast
        if (mounted) {
          AppToast.showSuccess(
            context,
            AppStrings.welcomeToFamily,
            subtitle: AppStrings.loginSuccess,
          );

          // Navigate to home after a short delay with slide and fade transition
          Future.delayed(
            const Duration(milliseconds: AppDimensions.animationVerySlow),
            () {
              if (mounted) {
                AppRoutes.navigateToHome(
                  context,
                  clearStack: true,
                  transition: TransitionType.slideFade,
                );
              }
            },
          );
        }
      } catch (e) {
        // Handle error if needed
        debugPrint('Login error: $e');
        if (mounted) {
          AppToast.showSuccess(context, AppStrings.loginError);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            label: AppStrings.email,
            hint: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            prefixIcon: Icon(
              Icons.email_outlined,
              size: ResponsiveUtils.getResponsiveIconSize(
                context,
                AppDimensions.iconMedium,
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(
              context,
              AppDimensions.spacing16,
            ),
          ),
          AppTextField(
            label: AppStrings.password,
            hint: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            isRequired: true,
            prefixIcon: Icon(
              Icons.lock_outlined,
              size: ResponsiveUtils.getResponsiveIconSize(
                context,
                AppDimensions.iconMedium,
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(
              context,
              AppDimensions.spacing24,
            ),
          ),
          AppButton(
            label: AppStrings.login,
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
            isFullWidth: true,
            icon: Icons.login,
          ),
        ],
      ),
    );
  }
}
