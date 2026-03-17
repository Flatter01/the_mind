import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';

class GroupRepository {
  final Dio _dio = DioConfig.client;

  Future<List<GroupModel>> getGroups() async {
    try {
      final response = await _dio.get('/group/groups/');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (data is Map && data['results'] is List) {
        return (data['results'] as List)
            .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        'Ошибка загрузки групп: ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<Map<String, dynamic>> getGroupById(int groupId) async {
    try {
      final response = await _dio.get('/group/groups/$groupId/');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Ошибка загрузки группы: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ✅ Используем /group/student-groups/?group=ID
  Future<List<dynamic>> getGroupStudents(int groupId) async {
    try {
      final response = await _dio.get(
        '/group/student-groups/',
        queryParameters: {'group': groupId},
      );
      final data = response.data;

      // ✅ Принт реального ответа
      print('=== STUDENT-GROUPS RAW ===');
      print(data);
      print('==========================');

      if (data is List) return data;
      if (data is Map && data['results'] is List) {
        return data['results'] as List;
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        'Ошибка загрузки студентов: ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<List<dynamic>> getGroupAttendance(int groupId) async {
    try {
      final response = await _dio.get(
        '/group/student-groups/',
        queryParameters: {'group': groupId},
      );
      final data = response.data;
      if (data is List) return data;
      if (data is Map && data['results'] is List) {
        return data['results'] as List;
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        'Ошибка загрузки посещаемости: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ✅ week_days как List<int>
  Future<void> createGroup({
    required String name,
    required String level,
    required String teacher,
    required int? room,
    required List<int> weekDays,
    required String price,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required bool isActive,
  }) async {
    try {
      final body = <String, dynamic>{
        'name': name,
        'level': level,
        'teacher': teacher,
        'price': price,
        'start_time': startTime,
        'end_time': endTime,
        'is_active': isActive,
        'week_days': weekDays, // [1, 3, 5]
      };

      if (room != null && room > 0) body['room'] = room;
      if (startDate.isNotEmpty) body['start_date'] = startDate;
      if (endDate.isNotEmpty) body['end_date'] = endDate;

      print('=== CREATE GROUP BODY ===');
      print(body);
      print('========================');

      final response = await _dio.post('/group/groups/', data: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Неожиданный статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Ошибка создания группы: ${e.response?.data ?? e.message}',
      );
    }
  }
}
