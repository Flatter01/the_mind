
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';

abstract class StudentState {}

class StudentSuccess extends StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<StudentModel> students;

  StudentLoaded({required this.students});
}

class StudentError extends StudentState {
  final String message;

  StudentError({required this.message});
}