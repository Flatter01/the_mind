import 'package:dio/dio.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';

class StudentRepository {
  String token =
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzcyNzEwNjI2LCJpYXQiOjE3NzI3MDk3MjYsImp0aSI6IjBiZDg4OTgzM2E3NzQ4MWVhZTgxODJkMTNjY2ZlYzQxIiwidXNlcl9pZCI6IjFhZTRkYjk2LTY5MTctNDA4Yi04YjFiLWI0OWI5OTgyNTUxZSJ9.WeFCwm4twLSJVVS3OM2d8B8ZtVxDmrDQinw8azBYPOU";

  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: "https://shokhchoriev.pythonanywhere.com/api/student",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json", "Authorization": token},
    ),
  );

  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await _dio.get("/students/");

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
        "/students/",
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
        throw Exception("Ошибка отправки");
      }
    } catch (e) {
  if (e is DioException) {
    print("STATUS: ${e.response?.statusCode}");
    print("DATA: ${e.response?.data}");
  }

      throw Exception("Post error: $e");
    }
  }
}
