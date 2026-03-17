import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository repository;

  StudentCubit({required this.repository}) : super(StudentInitial());

  Future<void> getStudents() async {
    if (isClosed) return;
    emit(StudentLoading());
    try {
      final students = await repository.getStudents();
      if (isClosed) return;
      emit(StudentLoaded(students: students));
    } catch (e) {
      if (isClosed) return;
      emit(StudentError(message: e.toString()));
    }
  }

  Future<void> addStudent({
    required String firstName,
    required String lastName,
    required String phone,
    String? parentPhone,
    required String status,
    required String birthDate,
    required String gender,
    // required int district,
    required String groupName,
    required String teacherName,
    required String source,
    String? notes,
    int? groupIntId, // ← int id для /group/student-groups/
  }) async {
    if (isClosed) return;
    emit(StudentLoading());
    try {
      // 1. Создаём студента без group_id
      final studentId = await repository.createStudent(
        groupName: groupName,
        teacherName: teacherName,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        parentPhone: parentPhone,
        status: status,
        birthDate: birthDate,
        gender: gender,
        // district: district,
        source: source,
        notes: notes,
      );

      // 2. Назначаем группу отдельно если выбрана
      if (groupIntId != null) {
        await repository.assignGroupToStudent(
          studentId: studentId,
          groupId: groupIntId,
        );
      }

      if (isClosed) return;
      await getStudents();
    } catch (e) {
      if (isClosed) return;
      emit(StudentError(message: e.toString()));
    }
  }

  Future<void> deleteStudent(int studentId) async {
    if (isClosed) return;

    emit(StudentLoading());

    try {
      await repository.deleteStudent(studentId);

      if (isClosed) return;

      await getStudents(); // обновляем список после удаления
    } catch (e) {
      if (isClosed) return;
      emit(StudentError(message: e.toString()));
    }
  }

  Future<void> getJournalStudents({
    required int groupId,
    required String lessonDate,
    required String teacherId,
  }) async {
    if (isClosed) return;
    emit(StudentLoading());
    try {
      final journalStudents = await repository.getJournalStudents(
        groupId: groupId,
        lessonDate: lessonDate,
        teacherId: teacherId,
      );
      if (isClosed) return;
      emit(StudentJournalLoaded(journalStudents: journalStudents));
    } catch (e) {
      if (isClosed) return;
      emit(StudentError(message: e.toString()));
    }
  }
}