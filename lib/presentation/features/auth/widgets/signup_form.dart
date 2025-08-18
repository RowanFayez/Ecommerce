import 'package:flutter/material.dart';
import 'package:taskaia/core/managers/app_toast.dart';
import 'package:taskaia/core/theme/app_strings.dart';
import 'package:taskaia/core/validators/form_validator.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../controller/auth_controller.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/local_user_store.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = AuthController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _authController.signup(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
          _phoneController.text.trim(),
        );

        if (mounted) {
          if (result['success']) {
            // Show success toast
            AppToast.showSuccess(
              context,
              'Account Created',
              subtitle: result['message'],
            );

            // Persist locally (defensive) to ensure Users screen sees it
            final user = result['user'];
            if (user != null && getIt.isRegistered<LocalUserStore>()) {
              try {
                getIt<LocalUserStore>().add(user);
              } catch (_) {}
            }

            // Navigate back to login after a short delay
            Future.delayed(
              const Duration(milliseconds: AppDimensions.animationVerySlow),
              () {
                if (mounted) {
                  Navigator.pop(context);
                }
              },
            );
          } else {
            // Show error toast
            AppToast.showError(
              context,
              'Signup Failed',
              subtitle: result['message'],
            );
          }
        }
      } catch (e) {
        // Handle unexpected error
        debugPrint('Signup error: $e');
        if (mounted) {
          AppToast.showError(
            context,
            'Signup Error',
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
          // First Name
          AppTextField(
            label: 'First Name',
            hint: 'Enter your first name',
            controller: _firstNameController,
            isRequired: true,
            validator: FormValidator.validateName,
            prefixIcon: Icon(
              Icons.person_outline,
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
          // Last Name
          AppTextField(
            label: 'Last Name',
            hint: 'Enter your last name',
            controller: _lastNameController,
            isRequired: true,
            validator: FormValidator.validateName,
            prefixIcon: Icon(
              Icons.person_outline,
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
          // Email
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
          // Phone
          AppTextField(
            label: AppStrings.phone,
            hint: 'Enter your phone number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            isRequired: true,
            validator: FormValidator.validatePhone,
            prefixIcon: Icon(
              Icons.phone_outlined,
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
          // Password
          AppTextField(
            label: AppStrings.password,
            hint: 'Enter your password',
            controller: _passwordController,
            obscureText: _obscurePassword,
            isRequired: true,
            validator: FormValidator.validateSignupPassword,
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
              AppDimensions.spacing16,
            ),
          ),
          // Confirm Password
          AppTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            isRequired: true,
            validator: _validateConfirmPassword,
            prefixIcon: Icon(
              Icons.lock_outlined,
              size: ResponsiveUtils.getResponsiveIconSize(
                context,
                AppDimensions.iconMedium,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                size: ResponsiveUtils.getResponsiveIconSize(
                  context,
                  AppDimensions.iconMedium,
                ),
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
            label: AppStrings.signUp,
            onPressed: _isLoading ? null : _handleSignup,
            isLoading: _isLoading,
            isFullWidth: true,
            icon: Icons.person_add,
          ),
        ],
      ),
    );
  }
}
