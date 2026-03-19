import 'package:srm/src/the_mind/the_mind_teacher/data/model/teacher_model.dart';

abstract class TeacherState {}
 
class TeacherInitial extends TeacherState {}
 
class TeacherLoading extends TeacherState {}
 
class TeacherLoaded extends TeacherState {
  final List<TeacherModel> teachers;
  final TeacherDashboardModel? dashboard;
  final TeacherJournalModel? journal;
 
  TeacherLoaded({
    required this.teachers,
    this.dashboard,
    this.journal,
  });
 
  TeacherLoaded copyWith({
    List<TeacherModel>? teachers,
    TeacherDashboardModel? dashboard,
    TeacherJournalModel? journal,
  }) {
    return TeacherLoaded(
      teachers: teachers ?? this.teachers,
      dashboard: dashboard ?? this.dashboard,
      journal: journal ?? this.journal,
    );
  }
}
 
class TeacherError extends TeacherState {
  final String message;
  TeacherError(this.message);
}
 
class TeacherJournalLoading extends TeacherState {
  final TeacherLoaded previous;
  TeacherJournalLoading(this.previous);
}
 