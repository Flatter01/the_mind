import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';

class ExamApiService {
  final Dio _dio = DioConfig.client;

  Future<List<ExamModel>> getExams() async {
    try {
      final response = await _dio.get("/exam/exams/");
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

  Future<void> createExam({
    required String title,
    required String teacher,
    required int group,
    required String examDate,
    required String startTime,
    required String endTime,
    required int passScore,
    required bool isPercentage,
    required bool isActive,
    required String createdBy,
  }) async {
    try {
      final response = await _dio.post(
        "/exam/exams/",
        data: {
          "title": title,
          "group": group,
          "teacher": teacher,
          "exam_date": examDate,
          "start_time": startTime,
          "end_time": endTime,
          "pass_score": passScore,
          "is_percentage": isPercentage,
          "is_active": isActive,
          "created_by": createdBy,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Ошибка создания экзамена");
      }
    } on DioException catch (e) {
      throw Exception("Exam POST error: ${e.response?.data ?? e.message}");
    }
  }

  Future<void> saveExamResults({
    required String examId,
    required String status,
    required List<Map<String, dynamic>> results,
  }) async {
    try {
      await _dio.post(
        '/exam/exams/$examId/results/',
        data: {
          'status': status,
          'results': results,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        'Ошибка сохранения результатов: ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<void> deleteExam(String id) async {
    try {
      final response = await _dio.delete("/exam/exams/$id/");
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Ошибка удаления экзамена");
      }
    } on DioException catch (e) {
      throw Exception("Exam DELETE error: ${e.response?.data ?? e.message}");
    }
  }
}