import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_payment_servise.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/payment_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_stae.dart';


class PaymentCubit extends Cubit<PaymentState> {
  final StudentApiPaymentServise api;

  PaymentCubit(this.api) : super(PaymentInitial());

  List<PaymentModel> payments = [];

  Future<void> getPayments() async {
    emit(PaymentLoading());

    try {
      payments = await api.getPayments();

      emit(PaymentLoaded(payments));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> createPayment({
    required int student,
    required int group,
    required String administrator,
    String? amount,
    required String payWith,
    required String paymentMonth,
    required bool checkGiven,
  }) async {
    emit(PaymentLoading());

    try {
      await api.sendPostPayment(
        student: student,
        group: group,
        administrator: administrator,
        amount: amount,
        payWith: payWith,
        paymentMonth: paymentMonth,
        checkGiven: checkGiven,
      );

      await getPayments();

      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}