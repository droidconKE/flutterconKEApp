// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:fluttercon_2024/core/local_storage.dart' as _i5;
import 'package:fluttercon_2024/common/network/dio_client.dart' as _i6;
import 'package:fluttercon_2024/core/di/injectable.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> initGetIt({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i3.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    gh.singleton<_i4.Dio>(() => registerModule.dio());
    gh.singleton<_i5.LocalStorage>(
        () => _i5.LocalStorage(gh<_i3.SharedPreferences>()));
    gh.lazySingleton<_i6.DioClient>(() => _i6.DioClient(gh<_i4.Dio>()));
    return this;
  }
}

class _$RegisterModule extends _i7.RegisterModule {}
