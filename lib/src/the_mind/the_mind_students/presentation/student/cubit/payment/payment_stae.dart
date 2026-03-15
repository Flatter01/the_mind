import 'package:equatable/equatable.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/payment_model.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentModel> payments;
  PaymentLoaded({required this.payments});

  @override
  List<Object?> get props => [payments];
}

class PaymentSuccess extends PaymentState {} // ← POST муваффақиятли

class PaymentError extends PaymentState {
  final String message;
  PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}