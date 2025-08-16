import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/services/auth_token_store.dart';
import 'core/theme/theme_manager.dart';
import 'core/routing/app_routes.dart';
import 'core/hive/hive_setup.dart';

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

  // Initialize Firebase (web uses provided options)
  print('🔥 Initializing Firebase...');
  if (kIsWeb) {
    const options = FirebaseOptions(
      apiKey: "AIzaSyDl-Yw_cjM8J2ACmxqnHrvAnkKrOshQyuA",
      authDomain: "ecommerce-taskaia.firebaseapp.com",
      projectId: "ecommerce-taskaia",
      storageBucket: "ecommerce-taskaia.firebasestorage.app",
      messagingSenderId: "702700187745",
      appId: "1:702700187745:web:51793671ff8bcaa292fa20",
      measurementId: "G-81CYYEK68G",
    );
    await Firebase.initializeApp(options: options);
  } else {
    // Android/iOS/macOS/windows/linux use google-services files and native config
    await Firebase.initializeApp();
  }
  print('✅ Firebase initialized');

  // Initialize Hive boxes
  print('📦 Initializing local cache (Hive)...');
  await HiveSetup.init();
  print('✅ Hive initialized');

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
