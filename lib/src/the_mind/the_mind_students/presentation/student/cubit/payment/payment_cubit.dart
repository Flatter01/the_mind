import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_payment_servise.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_stae.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final StudentApiPaymentService repository;

  PaymentCubit({required this.repository}) : super(PaymentInitial());

  Future<void> getPayments() async {
    if (isClosed) return;
    emit(PaymentLoading());
    try {
      final payments = await repository.getPayments();
      if (isClosed) return;
      emit(PaymentLoaded(payments: payments));
    } catch (e) {
      if (isClosed) return;
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> createPayment({
    required int student,
    required String group,
    required String administrator,
    required String amount,
    required String payWith,
    required String paymentMonth,
    required bool checkGiven,
  }) async {
    if (isClosed) return;
    emit(PaymentLoading());
    try {
      await repository.createPayment(
        student: student,
        group: group,
        administrator: administrator,
        amount: amount,
        payWith: payWith,
        paymentMonth: paymentMonth,
        checkGiven: checkGiven,
      );
      if (isClosed) return;
      emit(PaymentSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(PaymentError(message: e.toString()));
    }
  }
}