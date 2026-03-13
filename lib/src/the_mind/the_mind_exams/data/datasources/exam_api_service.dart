import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';

class ExamApiService {
  final Dio _dio = DioConfig.client;
  Future<List<ExamModel>> getExams() async {
    try {
      final response = await _dio.get("/exam/exams");

      final data = response.data;

      if (data is List) {
        return data
            .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data is Map && data["results"] is List) {
        return (data["results"] as List)
            .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("Unknown API format: $data");
    } catch (e) {
      throw Exception("Exam GET error: $e");
    }
  }

  /// POST EXAM
  Future<void> createExam({
    required String title,
    required String date,
    required int group,
  }) async {
    try {
      final response = await _dio.post(
        "/exam/exams/",
        data: {"title": title, "date": date, "group": group},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Ошибка создания экзамена");
      }
    } catch (e) {
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      }

      throw Exception("Exam POST error: $e");
    }
  }

  /// DELETE EXAM
  Future<void> deleteExam(int id) async {
    try {
      final response = await _dio.delete("/exam/$id/");

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Ошибка удаления экзамена");
      }
    } catch (e) {
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      }

      throw Exception("Exam DELETE error: $e");
    }
  }
}
