import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/api_client.dart';
// import '../../data/repositories/product_repository.dart';
// import 'package:taskaia/presentation/features/home/controller/home_controller.dart';
import '../services/auth_token_store.dart';
import '../services/local_user_store.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  Dio get dio {
    final dio = Dio();
    // Network can be slow on some devices/emulators; give generous timeouts
    dio.options.connectTimeout = const Duration(seconds: 90);
    dio.options.receiveTimeout = const Duration(seconds: 90);
    dio.options.sendTimeout = const Duration(seconds: 90);
    dio.options.baseUrl = 'https://fakestoreapi.com';

    // Add logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );

    // Attach token if available
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        final token = getIt.isRegistered<AuthTokenStore>()
            ? getIt<AuthTokenStore>().token
            : null;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      }),
    );

    return dio;
  }

  @singleton
  ApiClient apiClient(Dio dio) => ApiClient(dio);

  @singleton
  AuthTokenStore get authTokenStore => AuthTokenStore();

  @singleton
  LocalUserStore get localUserStore => LocalUserStore();
}
