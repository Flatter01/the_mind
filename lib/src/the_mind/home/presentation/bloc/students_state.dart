import 'package:equatable/equatable.dart';
import 'package:srm/src/the_mind/home/data/models/build_debtors_table_models.dart';

abstract class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object?> get props => [];
}

class StudentsInitial extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {

  final List<BuildDebtorsTableModels> students;

  const StudentsLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentsError extends StudentsState {

  final String message;

  const StudentsError(this.message);

  @override
  List<Object?> get props => [message];
}
