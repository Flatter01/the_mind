import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/main_the_mind/data/models/room_model.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';

class GroupRepository {
  final Dio _dio = DioConfig.client;

  Future<List<GroupModel>> getGroups() async {
    try {
      final response = await _dio.get("/group/groups/");
      final List data = response.data as List;
      return data
          .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        "Ошибка загрузки групп: ${e.response?.data ?? e.message}",
      );
    }
  }

  Future<Map<String, dynamic>> getGroupById(int groupId) async {
    try {
      final response = await _dio.get("/group/groups/$groupId/");
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception("Ошибка загрузки группы: ${e.response?.data}");
    }
  }

  Future<List<Map<String, dynamic>>> getGroupStudents(int groupId) async {
    try {
      final response = await _dio.get(
        "/group/student-groups/",
        queryParameters: {"group": groupId}, // ← фильтр по группе
      );
      final data = response.data;
      if (data is List) return data.cast<Map<String, dynamic>>();
      // если pagination: {"results": [...]}
      if (data is Map && data['results'] != null) {
        return (data['results'] as List).cast<Map<String, dynamic>>();
      }
      return [];
    } on DioException catch (e) {
      throw Exception("Ошибка загрузки студентов: ${e.response?.data}");
    }
  }

Future<List<Map<String, dynamic>>> getGroupAttendance(int groupId) async {
  try {
    final response = await _dio.get(
      "/student/attendances/",
      queryParameters: {"group": groupId}, // ← фильтр
    );
    final data = response.data;
    if (data is List) return data.cast<Map<String, dynamic>>();
    if (data is Map && data['results'] != null) {
      return (data['results'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  } on DioException catch (e) {
    throw Exception("Ошибка загрузки посещаемости: ${e.response?.data}");
  }
}

  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await _dio.get("/group/rooms/");
      final List data = response.data as List;
      return data
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Ошибка загрузки комнат: ${e.response?.data}");
    }
  }

  Future<void> createGroup({
    required String name,
    required String level,
    required String teacher, // UUID
    required int? room,
    required String price,
    required String startDate,
    required String endDate,
    required String startTime, // "HH:mm:ss"
    required String endTime, // "HH:mm:ss"
    required bool isActive,
  }) async {
    try {
      final response = await _dio.post(
        "/group/groups/",
        data: {
          "name": name,
          "level": level,
          "teacher": teacher,
          if (room != null && room != 0) "room": room, // ← 0 бўлса юборма
          "price": price,
          "start_date": startDate,
          "end_date": endDate,
          "start_time": startTime,
          "end_time": endTime,
          "is_active": isActive,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Неожиданный статус: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Ошибка создания группы: ${e.response?.data}");
    }
  }
}
