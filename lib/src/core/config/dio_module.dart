import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DioConfig extends Interceptor {
  static final Dio client = Dio(
    BaseOptions(
      baseUrl: 'https://shokhchoriev.pythonanywhere.com/api',
      sendTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 2),
      connectTimeout: const Duration(minutes: 2),
    ),
  )..interceptors.add(DioConfig());

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = GetStorage().read('accessToken');

    // НЕ добавляем токен для login и refresh
    if (token != null &&
        !options.path.contains('/token/') &&
        !options.path.contains('/token/refresh/')) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // access token устарел → пробуем обновить
      try {
        final newToken = await refresh();
        if (newToken != null) {
          GetStorage().write('accessToken', newToken);

          // повторяем запрос с новым токеном
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          final cloneReq = await client.fetch(opts);
          return handler.resolve(cloneReq);
        }
      } catch (_) {
        return handler.next(err);
      }
    } else {
      return handler.next(err);
    }
  }

  Future<String?> refresh() async {
    try {
      final refreshToken = GetStorage().read('refreshToken');
      if (refreshToken == null) return null;

      final res = await client.post(
        '/token/refresh/',
        data: {"refresh": refreshToken},
      );

      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300) {
        return res.data['access'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
