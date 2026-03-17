import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_workers/data/models/admin_model.dart';

class AdminApiService {
  final Dio _dio = DioConfig.client;

  // ── GET /admin/admins/ ────────────────────────────────────────────────────
  Future<List<AdminModel>> getAdmins() async {
    try {
      final response = await _dio.get('/group/weekdays/');
      final List data = response.data as List;
      return data
          .map((e) => AdminModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Ошибка загрузки администраторов: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ── POST /admin/admins/ ───────────────────────────────────────────────────
  Future<AdminModel> createAdmin({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String role,
    String? phoneNumber,
    bool isActive = true,
  }) async {
    try {
      final response = await _dio.post(
        '/group/weekdays/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'password': password,
          'role': role,
          'is_active': isActive,
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            'phone_number': phoneNumber,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Неожиданный статус: ${response.statusCode}');
      }
      return AdminModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Ошибка создания администратора: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ── DELETE /admin/admins/{id}/ ────────────────────────────────────────────
  Future<void> deleteAdmin(String id) async {
    try {
      await _dio.delete('/group/weekdays//$id/');
    } on DioException catch (e) {
      throw Exception('Ошибка удаления: ${e.response?.data ?? e.message}');
    }
  }
}
