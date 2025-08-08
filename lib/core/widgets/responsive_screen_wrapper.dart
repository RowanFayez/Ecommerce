import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_dimensions.dart';
import 'safe_area_wrapper.dart';

class ResponsiveScreenWrapper extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final EdgeInsets? customPadding;
  final bool includeTop;
  final bool includeBottom;
  final Color? backgroundColor;

  const ResponsiveScreenWrapper({
    super.key,
    required this.child,
    this.useSafeArea = true,
    this.customPadding,
    this.includeTop = true,
    this.includeBottom = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (useSafeArea) {
      content = SafeAreaWrapper(
        includeTop: includeTop,
        includeBottom: includeBottom,
        customPadding: customPadding,
        child: content,
      );
    } else if (customPadding != null) {
      content = Padding(padding: customPadding!, child: content);
    }

    return Container(
      color: backgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: content,
    );
  }
}
