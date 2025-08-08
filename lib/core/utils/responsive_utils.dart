import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Screen Breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1024;

  // Get Screen Dimensions
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Device Type Detection
  static bool isMobile(BuildContext context) =>
      getScreenWidth(context) < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      getScreenWidth(context) >= mobileMaxWidth &&
      getScreenWidth(context) < tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      getScreenWidth(context) >= desktopMinWidth;

  // Responsive Padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < mobileMaxWidth) return const EdgeInsets.all(16);
    if (width < tabletMaxWidth) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < mobileMaxWidth)
      return const EdgeInsets.symmetric(horizontal: 16);
    if (width < tabletMaxWidth)
      return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 32);
  }

  // Responsive Content Width
  static double getContentMaxWidth(BuildContext context) {
    final width = getScreenWidth(context);
    if (width > 1200) return 800;
    return width * 0.9;
  }

  // Responsive Grid Properties
  static int getGridCrossAxisCount(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < mobileMaxWidth) return 2;
    if (width < tabletMaxWidth) return 3;
    return 4;
  }

  static double getGridChildAspectRatio(BuildContext context) {
    if (isMobile(context)) return 0.8;
    if (isTablet(context)) return 0.85;
    return 0.9;
  }

  // Responsive Font Sizes
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final width = getScreenWidth(context);
    if (width < mobileMaxWidth) return baseFontSize;
    if (width < tabletMaxWidth) return baseFontSize * 1.1;
    return baseFontSize * 1.2;
  }

  // Responsive Icon Sizes
  static double getResponsiveIconSize(
    BuildContext context,
    double baseIconSize,
  ) {
    final width = getScreenWidth(context);
    if (width < mobileMaxWidth) return baseIconSize;
    if (width < tabletMaxWidth) return baseIconSize * 1.1;
    return baseIconSize * 1.2;
  }

  // Responsive Button Height
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) return 48.0;
    if (isTablet(context)) return 50.0;
    return 52.0;
  }

  // Responsive Card Height
  static double getCardHeight(BuildContext context) {
    if (isMobile(context)) return 280.0;
    if (isTablet(context)) return 300.0;
    return 320.0;
  }

  // Safe Area Helper
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Orientation Helper
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Responsive Spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final width = getScreenWidth(context);
    if (width < mobileMaxWidth) return baseSpacing;
    if (width < tabletMaxWidth) return baseSpacing * 1.2;
    return baseSpacing * 1.4;
  }
}
