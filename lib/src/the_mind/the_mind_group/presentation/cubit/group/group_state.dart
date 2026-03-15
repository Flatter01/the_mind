import 'package:equatable/equatable.dart';
import 'package:srm/src/the_mind/main_the_mind/data/models/room_model.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';

abstract class GroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}
class GroupLoading extends GroupState {}
class GroupSuccess extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupModel> groups;
  final List<RoomModel> rooms;

  GroupLoaded(this.groups, {this.rooms = const []});

  @override
  List<Object?> get props => [groups, rooms];
}

class GroupDetailsLoaded extends GroupState {
  final GroupModel group;
  final List<Map<String, dynamic>> students;
  final List<Map<String, dynamic>> attendance;

  GroupDetailsLoaded({
    required this.group,
    required this.students,
    required this.attendance,
  });

  @override
  List<Object?> get props => [group, students, attendance];
}

class GroupError extends GroupState {
  final String message;
  GroupError(this.message);

  @override
  List<Object?> get props => [message];
}