// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:srm/src/core/api/dio_module.dart' as _i184;
import 'package:srm/src/the_mind/home/data/datasources/api_service.dart'
    as _i270;
import 'package:srm/src/the_mind/home/presentation/bloc/students_bloc.dart'
    as _i1005;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.factory<_i270.ApiService>(() => _i270.ApiService(gh<_i361.Dio>()));
    gh.factory<_i1005.StudentsBloc>(
      () => _i1005.StudentsBloc(gh<_i270.ApiService>()),
    );
    return this;
  }
}

class _$DioModule extends _i184.DioModule {}
