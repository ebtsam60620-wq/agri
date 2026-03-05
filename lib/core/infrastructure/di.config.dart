// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:agri/data/data_sources/localization_local_data_source.dart'
    as _i623;
import 'package:agri/data/data_sources/objectbox_localization_storage_impl.dart'
    as _i114;
import 'package:agri/data/data_sources/objectbox_user_storage_impl.dart'
    as _i820;
import 'package:agri/data/data_sources/user_local_data_source.dart' as _i311;
import 'package:agri/data/interfaces/abstract_http_data_source.dart' as _i651;
import 'package:agri/data/interfaces/dio_http_impl.dart' as _i581;
import 'package:agri/data/interfaces/soket_data_empl.dart' as _i168;
import 'package:agri/data/interfaces/soket_data_source.dart' as _i609;
import 'package:agri/modules/auth/data/data_source/auth_remote_data_source.dart'
    as _i103;
import 'package:agri/modules/auth/data/data_source/auth_remote_impl.dart'
    as _i831;
import 'package:agri/modules/auth/domain/repository/auth_repository.dart'
    as _i680;
import 'package:agri/modules/auth/domain/repository/auth_repository_impl.dart'
    as _i8;
import 'package:agri/modules/splash/data/data_source/auth_remote_impl.dart'
    as _i179;
import 'package:agri/modules/splash/data/data_source/splash_remote_data_source.dart'
    as _i170;
import 'package:agri/modules/splash/domain/repository/splash_repository.dart'
    as _i876;
import 'package:agri/modules/splash/domain/repository/splash_repository_impl.dart'
    as _i710;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i609.SocketDataSource>(
      () => _i168.SocketIoImpl()..init(),
    );
    await gh.lazySingletonAsync<_i311.UserLocalDataSource>(() {
      final i = _i820.ObjectboxUserStorageImpl();
      return i.init().then((_) => i);
    }, preResolve: true);
    await gh.lazySingletonAsync<_i623.LocalizationLocalDataSource>(() {
      final i = _i114.LocalizationStorageImpl();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.lazySingleton<_i651.HttpDataSource>(() => _i581.DioHttpImpl());
    gh.lazySingleton<_i103.AuthRemoteDataSource>(
      () => _i831.AuthRemoteDataSourceImpl(gh<_i651.HttpDataSource>()),
    );
    gh.lazySingleton<_i170.SpalshRemoteDataSource>(
      () => _i179.SplashRemoteDataSourceImpl(gh<_i651.HttpDataSource>()),
    );
    gh.lazySingleton<_i680.AuthRepo>(
      () => _i8.AuthRepositoryImpl(
        gh<_i103.AuthRemoteDataSource>(),
        gh<_i311.UserLocalDataSource>(),
      )..init(),
    );
    gh.lazySingleton<_i876.SplachRepo>(
      () => _i710.SplashRepositoryImpl(
        gh<_i170.SpalshRemoteDataSource>(),
        gh<_i311.UserLocalDataSource>(),
      )..init(),
    );
    return this;
  }
}
