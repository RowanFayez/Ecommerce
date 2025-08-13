import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/services/auth_token_store.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'core/routing/app_routes.dart';

// Global key to get current context from anywhere
final GlobalKey<NavigatorState> appKey = GlobalKey<NavigatorState>();
BuildContext get appContext => appKey.currentContext!;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting AlexTramApp...');

  // Configure dependency injection
  print('🔧 Configuring dependencies...');
  configureDependencies();
  print('✅ Dependencies configured successfully');

  // Initialize token store
  print('🔐 Initializing token store...');
  final authTokenStore = getIt<AuthTokenStore>();
  await authTokenStore.initialize();
  print('✅ Token store initialized');

  print('🎨 Running app...');
  runApp(const AlexTramApp());
}

class AlexTramApp extends StatefulWidget {
  const AlexTramApp({super.key});

  @override
  State<AlexTramApp> createState() => _AlexTramAppState();
}

class _AlexTramAppState extends State<AlexTramApp> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    print('📱 AlexTramApp initialized');
    _themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _themeManager.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<AuthTokenStore>()),
        ChangeNotifierProvider.value(value: _themeManager),
      ],
      child: Consumer<AuthTokenStore>(
        builder: (context, authTokenStore, child) {
          return MaterialApp(
            navigatorKey: appKey,
            title: 'Shopping App',
            debugShowCheckedModeBanner: false,
            theme: _themeManager.lightTheme,
            darkTheme: _themeManager.darkTheme,
            themeMode:
                _themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: _getInitialRoute(authTokenStore),
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }

  String _getInitialRoute(AuthTokenStore authTokenStore) {
    if (authTokenStore.isAuthenticated) {
      print('✅ User authenticated, going to home');
      return AppRoutes.home; // User is logged in, go to home
    } else {
      print('🔑 No auth, showing login');
      return AppRoutes.login; // No auth, show login
    }
  }
}
