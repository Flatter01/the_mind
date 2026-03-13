import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';

class GroupApiService {
  final Dio _dio = DioConfig.client;

  // Получение списка групп
  Future<List<GroupModel>> getGroup() async {
    try {
      final response = await _dio.get("/group/groups/");
      final List data = response.data as List;

      return data
          .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Ошибка получения групп: $e");
    }
  }

  // Создание группы
  Future<void> sendPostGroup({
    required String name,
    required String level,
    required String teacher,
    int? room,
    required String price,
    required String start_date,
    required String end_date,
    required String start_time,
    required String end_time,
    bool? is_active,
  }) async {
    try {
      final response = await _dio.post(
        "/group/groups/",
        data: {
          "name": name,
          "level": level,
          "teacher": teacher,
          "room": room,
          "price": price,
          "start_date": start_date,
          "end_date": end_date,
          "start_time": start_time,
          "end_time": end_time,
          "is_active": is_active,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Ошибка отправки группы");
      }
    } on DioException catch (e) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      throw Exception("Ошибка POST группы: $e");
    }
  }
}