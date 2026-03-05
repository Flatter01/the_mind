import 'package:dio/dio.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';
import 'exam_dio_client.dart';

class ExamApiService {
  final Dio _dio = ExamDioClient().dio; // ✅ использует токен из интерсептора

  // GET
  Future<List<ExamModel>> getRequest(String path,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      final List data = response.data;
      return data.map((e) => ExamModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST
  Future<ExamModel> postRequest(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return ExamModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT
  Future<ExamModel> putRequest(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data); // исправил POST → PUT
      return ExamModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE
  Future<void> deleteRequest(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return 'Server error: ${e.response?.statusCode}';
    } else {
      return 'Network error';
    }
  }
}