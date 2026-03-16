import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/history_model.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final StudentRepository repository;

  HistoryCubit({required this.repository}) : super(HistoryInitial());

  Future<void> getHistory(String studentId) async {
    if (isClosed) return;
    emit(HistoryLoading());
    try {
      final history = await repository.getStudentHistory(studentId);
      if (isClosed) return;
      emit(HistoryLoaded(history: history));
    } catch (e) {
      if (isClosed) return;
      emit(HistoryError(message: e.toString()));
    }
  }
}