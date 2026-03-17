import 'package:dio/dio.dart';
import 'package:srm/src/core/config/dio_module.dart';
import 'package:srm/src/the_mind/the_mind_transactions/data/models/transaction_model.dart';

class TransactionApiService {
  final Dio _dio = DioConfig.client;

  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await _dio.get('/student/payments/');
      final data = response.data;

      List<dynamic> list;
      if (data is List) {
        list = data;
      } else if (data is Map && data['results'] is List) {
        list = data['results'] as List;
      } else {
        return [];
      }

      return list
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Ошибка загрузки транзакций: ${e.response?.data ?? e.message}',
      );
    }
  }
}