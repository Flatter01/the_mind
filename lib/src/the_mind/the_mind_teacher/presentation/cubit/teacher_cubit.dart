import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/teacher_repository.dart';
import 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  final TeacherRepository repository;

  TeacherCubit({required this.repository}) : super(TeacherInitial());

  Future<void> getTeachers() async {
    if (isClosed) return;
    emit(TeacherLoading());
    try {
      final teachers = await repository.getTeachers();
      if (isClosed) return;
      emit(TeacherLoaded(teachers));
    } catch (e) {
      if (isClosed) return;
      emit(TeacherError(e.toString()));
    }
  }
}