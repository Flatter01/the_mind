import 'package:dio/dio.dart';

class ExamDioClient {
  static final ExamDioClient _instance = ExamDioClient._internal();
  factory ExamDioClient() => _instance;

  late Dio dio;

  ExamDioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl:
            'https://shokhchoriev.pythonanywhere.com/api/exam/', // поменяй на свой API
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] =
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzcyNjY0MTAxLCJpYXQiOjE3NzI2NjMyMDEsImp0aSI6IjQ5ZjVmMTJiMmY4MDQ2NmVhMTZiMTY4MmI4NjA4MDFkIiwidXNlcl9pZCI6IjFhZTRkYjk2LTY5MTctNDA4Yi04YjFiLWI0OWI5OTgyNTUxZSJ9.ryclC7VophgxYHDnm1wFs8O5AM99BcKQYHQ9QI-sXYA';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }
}
