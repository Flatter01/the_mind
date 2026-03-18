import 'package:equatable/equatable.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_models.dart';

abstract class LidState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LidInitial extends LidState {}

class LidLoading extends LidState {}

class LidLoaded extends LidState {
  final List<LidModel> leads;
  LidLoaded(this.leads);

  @override
  List<Object?> get props => [leads];
}

class LidError extends LidState {
  final String message;
  LidError(this.message);

  @override
  List<Object?> get props => [message];
}

class LidCreating extends LidState {}
class LidUpdating extends LidState {}