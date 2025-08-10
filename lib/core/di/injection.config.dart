// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:taskaia/core/di/injection.dart' as _i598;
import 'package:taskaia/data/datasources/api_client.dart' as _i167;
import 'package:taskaia/core/services/auth_token_store.dart' as _i999;
import 'package:taskaia/core/services/local_user_store.dart' as _i777;
import 'package:taskaia/data/repositories/cart_repository.dart' as _i923;
import 'package:taskaia/data/repositories/product_repository.dart' as _i31;
import 'package:taskaia/presentation/features/home/controller/home_controller.dart'
    as _i357;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i361.Dio>(() => registerModule.dio);
    gh.singleton<_i167.ApiClient>(
        () => registerModule.apiClient(gh<_i361.Dio>()));
    gh.singleton<_i999.AuthTokenStore>(() => registerModule.authTokenStore);
    gh.singleton<_i777.LocalUserStore>(() => registerModule.localUserStore);
    gh.factory<_i923.CartRepository>(
        () => _i923.ApiCartRepository(gh<_i167.ApiClient>()));
    gh.factory<_i31.ProductRepository>(
        () => _i31.ApiProductRepository(gh<_i167.ApiClient>()));
    gh.factory<_i357.HomeController>(
        () => _i357.HomeController(gh<_i31.ProductRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i598.RegisterModule {}
