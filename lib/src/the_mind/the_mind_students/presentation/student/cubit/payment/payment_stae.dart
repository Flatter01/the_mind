import 'package:srm/src/the_mind/the_mind_students/data/model/students/payment_model.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentModel> payments;

  PaymentLoaded(this.payments);
}

class PaymentSuccess extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}