import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/datasources/exam_api_service.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/create_exam_request.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';
part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamApiService api;

  ExamCubit(this.api) : super(ExamInitial());

  Future<void> getExams() async {
    if (isClosed) return;

    emit(ExamLoading());

    try {
      final exams = await api.getRequest('exams/');

      if (isClosed) return;
      emit(ExamLoaded(exams));
    } catch (e) {
      if (isClosed) return;
      emit(ExamError(e.toString()));
    }
  }

  Future<void> postAddExam(CreateExamRequest request) async {
    if (isClosed) return;

    try {
      final newExam = await api.postRequest('exams/', data: request.toJson());
      final currentExams = state is ExamLoaded
          ? (state as ExamLoaded).exams
          : [];
      emit(ExamLoaded([...currentExams, newExam]));
    } catch (e) {
      if (isClosed) return;
      emit(ExamError(e.toString()));
    }
  }
}
