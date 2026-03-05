import 'package:equatable/equatable.dart';

abstract class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object?> get props => [];
}

/// загрузить студентов
class LoadStudents extends StudentsEvent {}
