import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/datasources/exam_api_service.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamApiService api;

  ExamCubit(this.api) : super(ExamInitial());

  Future<void> getExams() async {
    if (isClosed) return;

    emit(ExamLoading());

    try {
      final exams = await api.getExams();

      if (isClosed) return;

      emit(ExamLoaded(exams));
    } catch (e) {
      if (isClosed) return;

      emit(ExamError(e.toString()));
    }
  }

  Future<void> addExam({
    required String title,
    required String date,
    required int group,
  }) async {
    if (isClosed) return;

    try {
      await api.createExam(
        title: title,
        date: date,
        group: group,
      );

      await getExams();
    } catch (e) {
      if (isClosed) return;

      emit(ExamError(e.toString()));
    }
  }

  Future<void> deleteExam(int id) async {
    if (isClosed) return;

    try {
      await api.deleteExam(id);

      await getExams();
    } catch (e) {
      if (isClosed) return;

      emit(ExamError(e.toString()));
    }
  }
}