import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';

class StudentRepository {
  final Dio _dio = DioConfig.client;

  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await _dio.get("/student/students/");
      final List data = response.data as List;
      // data.forEach((user){
      //   print('user teacher name ${user}');
      // });
      return data
          .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        "Ошибка загрузки студентов: ${e.response?.data ?? e.message}",
      );
    }
  }

  Future<void> createStudent({
  required String firstName,
  required String lastName,
  required String phone,
  String? parentPhone,
  required String status,
  required String birthDate,
  required String gender,
  required int district,
  required String groupName,
  required String teacherName,
  required String source,
  String? notes,
  String? groupId,
}) async {
  // print('📤 createStudent called');
  // print('   firstName: $firstName');
  // print('   lastName: $lastName');
  // print('   phone: $phone');
  // print('   parentPhone: $parentPhone');
  // print('   status: $status');
  // print('   birthDate: $birthDate');
  // print('   gender: $gender');
  // print('   district: $district');
  // print('   groupName: $groupName');
  // print('   teacherName: $teacherName');
  // print('   source: $source');
  // print('   notes: $notes');
  // print('   groupId: $groupId');

  final body = {
    "first_name": firstName,
    "group_name": groupName,
    "teacher_name": teacherName,
    "last_name": lastName,
    "phone": phone,
    if (parentPhone != null) "parent_phone": parentPhone,
    "status": status,
    "birth_date": birthDate,
    "gender": gender,
    "district": district,
    "source": source,
    if (notes != null) "notes": notes,
    if (groupId != null) "group_id": groupId,
  };

  print('📦 Request body: $body');

  try {
    // print('🚀 Sending POST to /student/students/');
    final response = await _dio.post("/student/students/", data: body);

    // print('✅ Response status: ${response.statusCode}');
    // print('✅ Response data: ${response.data}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      // print('❌ Unexpected status: ${response.statusCode}');
      throw Exception("Неожиданный статус: ${response.statusCode}");
    }

    print('🎉 Student created successfully');
  } on DioException catch (e) {
    // print('❌ DioException caught');
    // print('   Status code: ${e.response?.statusCode}');
    // print('   Response data: ${e.response?.data}');
    // print('   Message: ${e.message}');
    final errorData = e.response?.data;
    throw Exception("Ошибка создания студента: $errorData");
  }
}

  Future<void> updateStudent(
    String studentId,
    Map<String, dynamic> fields,
  ) async {
    try {
      await _dio.patch("/student/students/$studentId/", data: fields);
    } on DioException catch (e) {
      throw Exception("Ошибка обновления студента: ${e.response?.data}");
    }
  }

  Future<void> deleteStudent(int studentId) async {
    try {
      await _dio.delete("/student/students/$studentId/");
    } on DioException catch (e) {
      throw Exception("Ошибка удаления студента: ${e.response?.data}");
    }
  }
}
