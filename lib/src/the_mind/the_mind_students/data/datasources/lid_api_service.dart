import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_models.dart';

class LidApiService {
  final Dio _dio = DioConfig.client;

  // ── GET /student/leads/ ───────────────────────────────────────────────────
  Future<List<LidModel>> getLeads() async {
    try {
      final response = await _dio.get('/student/leads/');
      final data = response.data;

      List<dynamic> list;
      if (data is List) {
        list = data;
      } else if (data is Map && data['results'] is List) {
        list = data['results'] as List;
      } else {
        return [];
      }

      // ✅ Принтим первый лид чтобы видеть реальные статусы
      print('=== ALL LEADS STATUS ===');

      for (var e in list) {
        print('ID: ${e['id']}');
        print('status (API): ${e['status']}');
        print('status_display: ${e['status_display']}');
        print('-------------------------');
      }

      print('=========================');

      return list
          .map((e) => LidModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Ошибка загрузки лидов: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ── POST /student/leads/ ──────────────────────────────────────────────────
  Future<LidModel> createLead({
    required String firstName,
    required String phone,
    String status = 'new',
    int? interestedCourse,
    String? source,
    String? comment,
  }) async {
    try {
      final body = <String, dynamic>{
        'first_name': firstName,
        'phone': phone,
        'status': status,
        if (interestedCourse != null) 'interested_course': interestedCourse,
        if (source != null) 'source': source,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      };

      print('=== CREATE LEAD BODY ===');
      print(body);
      print('========================');

      final response = await _dio.post('/student/leads/', data: body);
      return LidModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('=== CREATE LEAD ERROR ===');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('=========================');
      throw Exception('Ошибка создания лида: ${e.response?.data ?? e.message}');
    }
  }

  // ── PUT /student/leads/{id}/ ──────────────────────────────────────────────
  Future<LidModel> updateLead({
    required int id,
    required String firstName,
    String? phone,
    String? date,
    int? branch,
    String? destination,
    String? source,
    String? gender,
    int? course,
    bool giveBook = false,
    String? comment,
    String? status,
  }) async {
    try {
      final body = <String, dynamic>{
        'first_name': firstName,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (date != null && date.isNotEmpty) 'date': date,
        if (branch != null) 'branch': branch,
        if (destination != null) 'destination': destination,
        if (source != null) 'source': source,
        if (gender != null) 'gender': gender,
        if (course != null) 'course': course,
        'give_book': giveBook,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
        if (status != null) 'status': status,
      };

      print('=== UPDATE LEAD #$id ===');
      print(body);
      print('========================');

      final response = await _dio.put('/student/leads/$id/', data: body);
      return LidModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('=== UPDATE LEAD ERROR ===');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('=========================');
      throw Exception(
        'Ошибка обновления лида: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ── PATCH — только статус ─────────────────────────────────────────────────
  Future<void> updateStatus({
    required int id,
    required String status, // API значение
  }) async {
    try {
      print('=== UPDATE STATUS id=$id status=$status ===');
      await _dio.patch('/student/leads/$id/', data: {'status': status});
      print('=== UPDATE STATUS SUCCESS ===');
    } on DioException catch (e) {
      print('=== UPDATE STATUS ERROR ===');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Message: ${e.message}');
      print('==========================');
      throw Exception(
        'Ошибка обновления статуса: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────────
  Future<void> deleteLead(int id) async {
    try {
      await _dio.delete('/student/leads/$id/');
    } on DioException catch (e) {
      throw Exception('Ошибка удаления лида: ${e.response?.data ?? e.message}');
    }
  }
}