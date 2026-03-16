import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_record_model.dart';
import 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  final StudentRepository repository;

  JournalCubit({required this.repository}) : super(JournalInitial());

  Future<void> loadJournal({
    required int groupId,
    required String lessonDate,
    required String teacherId,
  }) async {
    emit(JournalLoading());
    try {
      final journal = await repository.getJournal(
        groupId: groupId,
        lessonDate: lessonDate,
        teacherId: teacherId,
      );
      // Копируем записи для локального редактирования
      emit(JournalLoaded(
        journal: journal,
        records: List.from(journal.studentRecords),
      ));
    } catch (e) {
      emit(JournalError(message: e.toString()));
    }
  }

  /// Обновить оценку/посещаемость локально (без запроса)
  void updateRecord(StudentRecordModel updated) {
    final state = this.state;
    if (state is! JournalLoaded) return;

    final newRecords = state.records.map((r) {
      return r.studentId == updated.studentId ? updated : r;
    }).toList();

    emit(state.copyWithRecords(newRecords));
  }

  /// Сохранить журнал на сервере
  Future<void> saveJournal({
    required int groupId,
    required String lessonDate,
    required String teacherId,
  }) async {
    final state = this.state;
    if (state is! JournalLoaded) return;

    emit(JournalSaving());
    try {
      await repository.saveJournal(
        groupId: groupId,
        lessonDate: lessonDate,
        teacherId: teacherId,
        records: state.records,
      );
      emit(JournalSaved());
    } catch (e) {
      emit(JournalError(message: e.toString()));
    }
  }
}