import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/model/teacher_model.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/teacher_repository.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  final TeacherRepository repository;
 
  TeacherCubit({required this.repository}) : super(TeacherInitial());
 
  // ── Учителей + дашборд юклаш ─────────────────────────────────────────────
  Future<void> getTeachers() async {
    if (isClosed) return;
    emit(TeacherLoading());
    try {
      final results = await Future.wait([
        repository.getTeachers(),
        repository.getDashboard(),
      ]);
 
      if (isClosed) return;
      emit(TeacherLoaded(
        teachers: results[0] as List<TeacherModel>,
        dashboard: results[1] as TeacherDashboardModel,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(TeacherError(e.toString()));
    }
  }
 
  // ── Группа журналини юклаш ────────────────────────────────────────────────
  Future<void> getJournal(int groupId) async {
    if (isClosed) return;
    final previous = state is TeacherLoaded ? state as TeacherLoaded : null;
    if (previous != null) emit(TeacherJournalLoading(previous));
 
    try {
      final journal = await repository.getGroupJournal(groupId);
      if (isClosed) return;
      if (previous != null) {
        emit(previous.copyWith(journal: journal));
      } else {
        emit(TeacherLoaded(teachers: const [], journal: journal));
      }
    } catch (e) {
      if (isClosed) return;
      if (previous != null) {
        emit(previous);
      } else {
        emit(TeacherError(e.toString()));
      }
    }
  }
}
 