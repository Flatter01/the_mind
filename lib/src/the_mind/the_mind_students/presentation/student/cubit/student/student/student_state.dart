import 'package:equatable/equatable.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_record_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_record_model.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<StudentModel> students;
  StudentLoaded({required this.students});

  @override
  List<Object?> get props => [students];
}

class StudentError extends StudentState {
  final String message;
  StudentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StudentJournalLoaded extends StudentState {
  final List<StudentRecordModel> journalStudents;
  StudentJournalLoaded({required this.journalStudents});

  @override
  List<Object?> get props => [journalStudents];
}
