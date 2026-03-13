import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository repository;

  StudentCubit({required this.repository}) : super(StudentInitial());

  Future<void> getStudents() async {
    if (isClosed) return; // защита на случай, если Cubit уже закрыт
    emit(StudentLoading());

    try {
      final students = await repository.getStudents();

      if (isClosed) return; // защита после await
      emit(StudentLoaded(students: students));
    } catch (e) {
      if (isClosed) return; // защита на случай ошибки
      emit(StudentError(message: e.toString()));
    }
  }

  Future<void> addStudent({
    int id = 0,
    required String firstName,
    required String lastName,
    required String phone,
    String? parentPhone,
    required String status,
    required String birthDate,
    required String gender,
    required int district,
    required String source,
    String? notes,
    String? groupId,
  }) async {
    if (isClosed) return;

    emit(StudentLoading());

    try {
      await repository.sendPost(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        parentPhone: parentPhone,
        status: status,
        birthDate: birthDate,
        gender: gender,
        district: district,
        source: source,
        notes: notes,
        groupId: groupId,
      );

      if (isClosed) return;
      final students = await repository.getStudents();

      if (isClosed) return;
      emit(StudentLoaded(students: students));
    } catch (e) {
      if (isClosed) return;
      emit(StudentError(message: e.toString()));
    }
  }
}
