import 'package:flutter/material.dart';
import 'package:taskaia/core/theme/app_strings.dart';
import 'package:taskaia/core/theme/app_dimensions.dart';
import 'package:taskaia/core/utils/responsive_utils.dart';
import 'package:taskaia/core/widgets/responsive_scaffold.dart';
import 'package:taskaia/core/animation/slide_transition_wrapper.dart';
import '../widgets/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideTransitionWrapper(
      child: ResponsiveScaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: ResponsiveUtils.getResponsiveIconSize(
                context,
                AppDimensions.iconMedium,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(
            context,
            AppDimensions.spacing24,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.signUp,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontHeading,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                context,
                AppDimensions.spacing8,
              )),
              const SignUpForm(),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                context,
                AppDimensions.spacing16,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.alreadyHaveAccount),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppStrings.login),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}