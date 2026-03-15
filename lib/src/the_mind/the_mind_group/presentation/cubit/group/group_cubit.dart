import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/data/datasources/group_api_service.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository repository;

  GroupCubit({required this.repository}) : super(GroupInitial());

  Future<void> getGroups() async {
    if (isClosed) return;
    emit(GroupLoading());
    try {
      final groups = await repository.getGroups();
      if (isClosed) return;
      emit(GroupLoaded(groups));
    } catch (e) {
      if (isClosed) return;
      emit(GroupError(e.toString()));
    }
  }

  Future<void> getGroupDetails(int groupId) async {
    if (isClosed) return;
    emit(GroupLoading());
    try {
      final groupData = await repository.getGroupById(groupId);
      final group = GroupModel.fromJson(groupData);
      final students = await repository.getGroupStudents(groupId);
      final attendance = await repository.getGroupAttendance(groupId);
      if (isClosed) return;
      emit(GroupDetailsLoaded(
        group: group,
        students: students,
        attendance: attendance,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(GroupError(e.toString()));
    }
  }

  Future<void> createGroup({
    required String name,
    required String level,
    required String teacher,
    required int? room,
    required String price,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required bool isActive,
  }) async {
    if (isClosed) return;
    emit(GroupLoading());
    try {
      await repository.createGroup(
        name: name,
        level: level,
        teacher: teacher,
        room: room,
        price: price,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        isActive: isActive,
      );
      if (isClosed) return;
      await getGroups();
    } catch (e) {
      if (isClosed) return;
      emit(GroupError(e.toString()));
    }
  }
}