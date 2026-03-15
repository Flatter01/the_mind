import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/payment_model.dart';

class StudentApiPaymentService {
  final Dio _dio = DioConfig.client;

  Future<List<PaymentModel>> getPayments() async {
    try {
      final response = await _dio.get("/student/payments/");
      final List data = response.data as List;
      return data
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Ошибка загрузки платежей: ${e.response?.data ?? e.message}");
    }
  }

  Future<void> createPayment({
    required int student,
    required String group,        // ← UUID String
    required String administrator, // ← UUID String
    required String amount,
    required String payWith,
    required String paymentMonth,  // ← "2026-03-14"
    required bool checkGiven,
  }) async {
    try {
      final response = await _dio.post(
        "/student/payments/",
        data: {
          "student": student,
          "group": group,
          "administrator": administrator,
          "amount": amount,
          "pay_with": payWith,
          "payment_month": paymentMonth,
          "check_given": checkGiven,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Неожиданный статус: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Ошибка создания платежа: ${e.response?.data}");
    }
  }
}