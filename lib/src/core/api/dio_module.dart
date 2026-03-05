import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {

  @lazySingleton
  Dio dio() {

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.humanspace.uz/api/v1',
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          options.headers['Accept'] = 'application/json';

          return handler.next(options);
        },
      ),
    );

    return dio;
  }
}
