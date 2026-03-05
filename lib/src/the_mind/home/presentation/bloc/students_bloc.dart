import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:srm/src/the_mind/home/data/datasources/api_service.dart';

import 'students_event.dart';
import 'students_state.dart';

@injectable
class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {

  final ApiService apiService;

  StudentsBloc(this.apiService) : super(StudentsInitial()) {

    on<LoadStudents>(_loadStudents);

  }

  Future<void> _loadStudents(
    LoadStudents event,
    Emitter<StudentsState> emit,
  ) async {

    emit(StudentsLoading());

    try {

      final students = await apiService.getStudents();

      emit(StudentsLoaded(students));

    } catch(e){

      emit(StudentsError(e.toString()));

    }

  }

}
