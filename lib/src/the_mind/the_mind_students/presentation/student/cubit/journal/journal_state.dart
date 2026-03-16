import 'package:equatable/equatable.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_record_model.dart';

abstract class JournalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JournalInitial extends JournalState {}

class JournalLoading extends JournalState {}

class JournalLoaded extends JournalState {
  final JournalModel journal;
  final List<StudentRecordModel> records; // локально редактируемые записи

  JournalLoaded({required this.journal, required this.records});

  JournalLoaded copyWithRecords(List<StudentRecordModel> newRecords) =>
      JournalLoaded(journal: journal, records: newRecords);

  @override
  List<Object?> get props => [journal, records];
}

class JournalSaving extends JournalState {}

class JournalSaved extends JournalState {}

class JournalError extends JournalState {
  final String message;
  JournalError({required this.message});

  @override
  List<Object?> get props => [message];
}