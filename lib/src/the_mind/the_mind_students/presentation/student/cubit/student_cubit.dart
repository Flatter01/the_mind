// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
// import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';


// abstract class StudentState {}
// class StudentInitial extends StudentState {}
// class StudentLoading extends StudentState {}
// class StudentLoaded extends StudentState {
//   final List<StudentModel> students;
//   StudentLoaded(this.students);
// }
// class StudentError extends StudentState {
//   final String message;
//   StudentError(this.message);
// }

// class StudentCubit extends Cubit<StudentState> {
//   final StudentApiService apiService;
//   StudentCubit(this.apiService) : super(StudentInitial());

//   Future<void> fetchStudents() async {
//     emit(StudentLoading());
//     try {
//       final students = await apiService.fetchStudents();
//       emit(StudentLoaded(students));
//     } catch (e) {
//       emit(StudentError(e.toString()));
//     }
//   }

//   Future<void> createStudent(StudentModel student) async {
//     emit(StudentLoading());
//     try {
//       await apiService.createStudent(student);
//       await fetchStudents(); // после добавления сразу обновляем список
//     } catch (e) {
//       emit(StudentError(e.toString()));
//     }
//   }
// }