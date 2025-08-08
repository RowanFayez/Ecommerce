import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_dimensions.dart';

class SafeAreaWrapper extends StatelessWidget {
  final Widget child;
  final bool includeTop;
  final bool includeBottom;
  final EdgeInsets? customPadding;

  const SafeAreaWrapper({
    super.key,
    required this.child,
    this.includeTop = true,
    this.includeBottom = true,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: includeTop,
      bottom: includeBottom,
      child: Padding(
        padding: customPadding ?? ResponsiveUtils.getScreenPadding(context),
        child: child,
      ),
    );
  }
}
