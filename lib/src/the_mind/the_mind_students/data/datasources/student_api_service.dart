import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';

class StudentRepository {
  final Dio _dio = DioConfig.client;

  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await _dio.get("/student/students/");

      final List data = response.data as List;

      return data
          .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Student error: $e");
    }
  }

  Future<void> sendPost({
    int id = 0,
    required String firstName,
    required String lastName,
    required String phone,
    String? parentPhone,
    required String status,
    required String birthDate,
    required String gender,
    required int district,
    required String source,
    String? notes,
    String? groupId,
  }) async {
    try {
      final response = await _dio.post(
        "/student/students/",
        data: {
          
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
          "parent_phone": parentPhone,
          "status": status,
          "birth_date": birthDate,
          "gender": gender,
          "district": district,
          "source": source,
          "notes": notes,
          "group_id": groupId,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Ошибка отправки студента");
      }
    } catch (e) {
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      }

      throw Exception("Post student error: $e");
    }
  }
}