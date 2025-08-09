import 'package:flutter/material.dart';
import 'package:taskaia/core/managers/app_toast.dart';
import 'package:taskaia/core/theme/app_strings.dart';
import 'package:taskaia/core/routing/app_routes.dart';
import 'package:taskaia/core/validators/form_validator.dart';
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
  bool _obscurePassword = true;

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
        final result = await _authController.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted) {
          if (result['success']) {
            // Show success toast
            AppToast.showSuccess(
              context,
              AppStrings.welcomeToFamily,
              subtitle: result['message'],
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
          } else {
            // Show error toast
            AppToast.showError(
              context,
              'Login Failed',
              subtitle: result['message'],
            );
          }
        }
      } catch (e) {
        // Handle unexpected error
        debugPrint('Login error: $e');
        if (mounted) {
          AppToast.showError(
            context,
            'Login Error',
            subtitle: 'An unexpected error occurred. Please try again.',
          );
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
            validator: FormValidator.validateEmail,
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
            obscureText: _obscurePassword,
            isRequired: true,
            validator: FormValidator.validatePassword,
            prefixIcon: Icon(
              Icons.lock_outlined,
              size: ResponsiveUtils.getResponsiveIconSize(
                context,
                AppDimensions.iconMedium,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                size: ResponsiveUtils.getResponsiveIconSize(
                  context,
                  AppDimensions.iconMedium,
                ),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
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
