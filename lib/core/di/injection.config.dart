// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:taskaia/core/di/injection.dart' as _i598;
import 'package:taskaia/core/hive/product_local_cache.dart' as _i942;
import 'package:taskaia/core/network/network_info.dart' as _i250;
import 'package:taskaia/core/services/auth_token_store.dart' as _i742;
import 'package:taskaia/core/services/local_user_store.dart' as _i341;
import 'package:taskaia/data/datasources/api_client.dart' as _i167;
import 'package:taskaia/data/repositories/cached_product_repository.dart'
    as _i508;
import 'package:taskaia/data/repositories/cart_repository.dart' as _i923;
import 'package:taskaia/data/repositories/product_repository.dart' as _i31;
import 'package:taskaia/presentation/features/home/bloc/product_bloc.dart'
    as _i104;
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
    gh.singleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.singleton<_i942.ProductLocalCache>(
        () => registerModule.productLocalCache);
    gh.singleton<_i742.AuthTokenStore>(() => registerModule.authTokenStore);
    gh.singleton<_i341.LocalUserStore>(() => registerModule.localUserStore);
    gh.singleton<_i250.INetworkInfo>(
        () => registerModule.networkInfo(gh<_i895.Connectivity>()));
    gh.singleton<_i167.ApiClient>(
        () => registerModule.apiClient(gh<_i361.Dio>()));
    gh.factory<_i923.CartRepository>(
        () => _i923.ApiCartRepository(gh<_i167.ApiClient>()));
    gh.lazySingleton<_i31.ProductRepository>(
        () => _i508.CachedProductRepository(
              gh<_i167.ApiClient>(),
              gh<_i250.INetworkInfo>(),
              gh<_i942.ProductLocalCache>(),
            ));
    gh.factory<_i31.ApiProductRepository>(
        () => _i31.ApiProductRepository(gh<_i167.ApiClient>()));
    gh.factory<_i104.ProductBloc>(
        () => _i104.ProductBloc(gh<_i31.ProductRepository>()));
    gh.factory<_i357.HomeController>(
        () => _i357.HomeController(gh<_i31.ProductRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i598.RegisterModule {}
