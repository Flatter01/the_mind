import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/model/teacher_model.dart';

class TeacherRepository {
  final Dio _dio = DioConfig.client;

  // ── GET /teacher/teachers/ ────────────────────────────────────────────────
  Future<List<TeacherModel>> getTeachers() async {
    try {
      final response = await _dio.get("/teacher/teachers/");
      final List data = response.data as List;
      return data
          .map((e) => TeacherModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          "Ошибка загрузки учителей: ${e.response?.data ?? e.message}");
    }
  }

  // ── GET /teacher/dashboard/ ───────────────────────────────────────────────
  Future<TeacherDashboardModel> getDashboard() async {
    try {
      final response = await _dio.get("/teacher/dashboard/");
      return TeacherDashboardModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
          "Ошибка загрузки дашборда: ${e.response?.data ?? e.message}");
    }
  }

  // ── GET /teacher/groups/{group_id}/journal/ ───────────────────────────────
  Future<TeacherJournalModel> getGroupJournal(int groupId) async {
    try {
      final response =
          await _dio.get("/teacher/groups/$groupId/journal/");
      return TeacherJournalModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
          "Ошибка загрузки журнала: ${e.response?.data ?? e.message}");
    }
  }
}