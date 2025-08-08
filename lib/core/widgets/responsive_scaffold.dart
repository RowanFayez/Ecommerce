import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_colors.dart';
import 'safe_area_wrapper.dart';

class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool useSafeArea;
  final EdgeInsets? customPadding;
  final bool includeTop;
  final bool includeBottom;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.useSafeArea = true,
    this.customPadding,
    this.includeTop = true,
    this.includeBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget scaffoldBody = body ?? const SizedBox.shrink();

    if (useSafeArea) {
      scaffoldBody = SafeAreaWrapper(
        includeTop: includeTop,
        includeBottom: includeBottom,
        customPadding: customPadding,
        child: scaffoldBody,
      );
    } else if (customPadding != null) {
      scaffoldBody = Padding(padding: customPadding!, child: scaffoldBody);
    }

    return Scaffold(
      appBar: appBar,
      body: scaffoldBody,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor ?? AppColors.background,
    );
  }
}
