import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/payment_model.dart';

class StudentApiPaymentServise {
  final Dio _dio = DioConfig.client;

  Future<List<PaymentModel>> getPayments() async {
    try {
      final response = await _dio.get("/student/payments/");

      final List data = response.data as List;

      return data
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Student error: $e");
    }
  }

  Future<void> sendPostPayment({
    required int student,
    required int group,
    required String administrator,
    String? amount,
    required String payWith,
    required String paymentMonth,
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
        throw Exception("Ошибка отправки платежа");
      }
    } catch (e) {
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      }

      throw Exception("Post payment error: $e");
    }
  }
}