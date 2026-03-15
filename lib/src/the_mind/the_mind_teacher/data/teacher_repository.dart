import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/model/teacher_model.dart';


class TeacherRepository {
  final Dio _dio = DioConfig.client;

  Future<List<TeacherModel>> getTeachers() async {
    try {
      final response = await _dio.get("/teacher/teachers/");
      final List data = response.data as List;
      return data
          .map((e) => TeacherModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Ошибка загрузки учителей: ${e.response?.data ?? e.message}");
    }
  }
}