import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupModel> groups;

  GroupLoaded(this.groups);
}

class GroupSuccess extends GroupState {}

class GroupError extends GroupState {
  final String message;

  GroupError(this.message);
}