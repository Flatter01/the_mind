import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';

class AuthApiService {
  final dio = DioConfig.client;

  Future<Response> login(String username, String password) async {
    final body = jsonEncode({
      "username": username.trim(),
      "password": password.trim(),
    });

    return await dio.post(
      '/token/',
      data: body,
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }
}