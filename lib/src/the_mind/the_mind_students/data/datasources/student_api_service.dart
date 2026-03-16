import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_models.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/history_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_record_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/ui_summary_model.dart';

class StudentRepository {
  final Dio _dio = DioConfig.client;

  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await _dio.get("/student/students/");
      final List data = response.data as List;
      // data.forEach((user){
      //   print('user teacher name ${user}');
      // });
      // if (data.isNotEmpty) {
      //   print('🔍 First student raw: ${data.first}');
      // }
      return data
          .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        "Ошибка загрузки студентов: ${e.response?.data ?? e.message}",
      );
    }
  }

  Future<List<StudentRecordModel>> getJournalStudents({
    required int groupId,
    required String lessonDate,
    required String teacherId,
  }) async {
    try {
      final response = await _dio.get(
        "/teacher/groups/$groupId/journal",
        queryParameters: {"lesson_date": lessonDate, "teacher_id": teacherId},
      );

      final List data = response.data["student_records"];

      return data.map((e) => StudentRecordModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<DashboardModel> getDashboard() async {
    try {
      final response = await _dio.get("/student/students/ui-summary/");

      final data = response.data as Map<String, dynamic>;

      return DashboardModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        "Ошибка загрузки dashboard: ${e.response?.data ?? e.message}",
      );
    }
  }

  Future<StudentHistoryModel> getStudentHistory(String studentId) async {
    try {
      final response = await _dio.get("/student/students/$studentId/history/");
      final data = response.data as Map<String, dynamic>;
      return StudentHistoryModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        "Ошибка загрузки истории: ${e.response?.data ?? e.message}",
      );
    }
  }

  // createStudent теперь возвращает int (id созданного студента)
  Future<int> createStudent({
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
  }) async {
    final body = {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "status": status,
      "birth_date": birthDate,
      "gender": gender,
      "district": district,
      "source": source,
      if (parentPhone != null && parentPhone.isNotEmpty)
        "parent_phone": parentPhone,
      if (notes != null && notes.isNotEmpty) "notes": notes,
      // ← group_id НЕ отправляем, назначаем отдельно
    };

    // print('📦 Request body: $body');

    try {
      final response = await _dio.post("/student/students/", data: body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Неожиданный статус: ${response.statusCode}");
      }
      final studentId = response.data['id'] as int; // ✅ возвращаем id
      // print('🎉 Student created with id: $studentId');
      return studentId;
    } on DioException catch (e) {
      throw Exception("Ошибка создания студента: ${e.response?.data}");
    }
  }

  // ✅ Новый метод — назначить группу студенту
  Future<void> assignGroupToStudent({
    required int studentId,
    required int groupId,
  }) async {
    try {
      final response = await _dio.post(
        "/group/student-groups/",
        data: {"student": studentId, "group": groupId},
      );
      // print('✅ Group assigned: ${response.data}');
    } on DioException catch (e) {
      throw Exception("Ошибка назначения группы: ${e.response?.data}");
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
      final response = await _dio.delete("/student/students/$studentId/");

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 202) {
        throw Exception("Ошибка удаления. Status: ${response.statusCode}");
      }

      print("🗑 Student deleted: $studentId");
    } on DioException catch (e) {
      throw Exception(
        "Ошибка удаления студента: ${e.response?.data ?? e.message}",
      );
    }
  }

  Future<List<LidModels>> getLeads() async {
    try {
      final response = await _dio.get("/student/leads/");
      final List data = response.data as List;

      return data.map((e) {
        final map = e as Map<String, dynamic>;
        return LidModels(
          name: map['first_name'] ?? 'Без имени',
          phone: map['phone'] ?? '',
          group: '', // можно оставить пустым или заполнять позже
          date: '', // у лидов дата добавления нет, можно присвоить пустую
          status: _mapStatus(map['status']),
          gender: "",
          branch: "", // заполнять при необходимости
          tariff: "", // заполнять при необходимости
          day: "", // заполнять при необходимости
          reason: map['comment'] ?? "",
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception(
        "Ошибка загрузки лидов: ${e.response?.data ?? e.message}",
      );
    }
  }

  String _mapStatus(String? apiStatus) {
    switch (apiStatus) {
      case 'new':
        return 'Лиды';
      case 'waiting':
        return 'В ожидании';
      case 'came':
        return 'Пришёл';
      case 'not_came':
        return 'Не пришёл';
      case 'call':
        return 'Позвонить';
      case 'no_answer':
        return 'Не ответил';
      default:
        return 'Лиды';
    }
  }
  // В StudentRepository добавь эти методы:

  Future<JournalModel> getJournal({
    required int groupId,
    required String lessonDate,
    required String teacherId,
  }) async {
    try {
      final response = await _dio.get(
        "/teacher/groups/$groupId/journal",
        queryParameters: {"lesson_date": lessonDate, "teacher_id": teacherId},
      );
      return JournalModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Ошибка загрузки журнала: $e");
    }
  }

  Future<void> saveJournal({
    required int groupId,
    required String lessonDate,
    required String teacherId,
    required List<StudentRecordModel> records,
  }) async {
    try {
      await _dio.post(
        "/teacher/groups/$groupId/journal",
        data: {
          "lesson_date": lessonDate,
          "teacher_id": teacherId,
          "student_records": records.map((r) => r.toJson()).toList(),
        },
      );
    } on DioException catch (e) {
      throw Exception(
        "Ошибка сохранения журнала: ${e.response?.data ?? e.message}",
      );
    }
  }
}
