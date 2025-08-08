import 'package:flutter/material.dart';
import '../../presentation/features/auth/screens/login_screen.dart';
import '../../presentation/features/auth/screens/signup_screen.dart';
import '../../presentation/features/home/view/home_screen.dart';
import '../animation/page_transitions.dart';

class AppRoutes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String productDetails = '/product-details';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    home: (context) => const HomeScreen(),
  };

  // Enhanced navigation methods with transitions
  static Future<T?> navigateWithTransition<T extends Object?>(
    BuildContext context,
    Widget page, {
    TransitionType transition = TransitionType.slideFromRight,
    Duration? duration,
    bool replace = false,
    bool clearStack = false,
  }) {
    Route<T> route;

    switch (transition) {
      case TransitionType.slideFromRight:
        route = PageTransitions.slideFromRight<T>(
          page,
          duration: duration ?? const Duration(milliseconds: 300),
        );
        break;
      case TransitionType.slideFromLeft:
        route = PageTransitions.slideFromLeft<T>(
          page,
          duration: duration ?? const Duration(milliseconds: 300),
        );
        break;
      case TransitionType.slideFromBottom:
        route = PageTransitions.slideFromBottom<T>(
          page,
          duration: duration ?? const Duration(milliseconds: 300),
        );
        break;
      case TransitionType.fade:
        route = PageTransitions.fadeTransition<T>(
          page,
          duration: duration ?? const Duration(milliseconds: 300),
        );
        break;
      case TransitionType.scale:
        route = PageTransitions.scaleTransition<T>(
          page,
          duration: duration ?? const Duration(milliseconds: 300),
        );
        break;
      case TransitionType.slideFade:
        route = PageTransitions.slideFadeTransition<T>(
          page,
          duration: duration ?? const Duration(milliseconds: 400),
        );
        break;
      case TransitionType.none:
        route = PageTransitions.noTransition<T>(page);
        break;
    }

    if (clearStack) {
      return Navigator.pushAndRemoveUntil<T>(context, route, (route) => false);
    } else if (replace) {
      return Navigator.pushReplacement<T, Object?>(context, route);
    } else {
      return Navigator.push<T>(context, route);
    }
  }

  // Specific navigation methods for common routes
  static Future<void> navigateToLogin(
    BuildContext context, {
    bool clearStack = true,
    TransitionType transition = TransitionType.slideFromLeft,
  }) {
    return navigateWithTransition(
      context,
      const LoginScreen(),
      transition: transition,
      clearStack: clearStack,
    );
  }

  static Future<void> navigateToSignup(
    BuildContext context, {
    TransitionType transition = TransitionType.slideFromRight,
  }) {
    return navigateWithTransition(
      context,
      const SignUpScreen(),
      transition: transition,
    );
  }

  static Future<void> navigateToHome(
    BuildContext context, {
    bool clearStack = true,
    TransitionType transition = TransitionType.slideFade,
  }) {
    return navigateWithTransition(
      context,
      const HomeScreen(),
      transition: transition,
      clearStack: clearStack,
    );
  }

  // Navigate to named route with transition
  static Future<T?> navigateToNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    TransitionType transition = TransitionType.slideFromRight,
    Duration? duration,
    bool replace = false,
    bool clearStack = false,
    Object? arguments,
  }) {
    final routeBuilder = routes[routeName];
    if (routeBuilder == null) {
      throw ArgumentError('Route $routeName not found');
    }

    final page = routeBuilder(context);
    return navigateWithTransition<T>(
      context,
      page,
      transition: transition,
      duration: duration,
      replace: replace,
      clearStack: clearStack,
    );
  }
}

enum TransitionType {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  fade,
  scale,
  slideFade,
  none,
}
