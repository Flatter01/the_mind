import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/data/datasources/group_api_service.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/payment/group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupApiService api;

  GroupCubit(this.api) : super(GroupInitial());

  List<GroupModel> groups = [];

  // Получение списка групп
  Future<void> getGroups() async {
    emit(GroupLoading());

    try {
      groups = await api.getGroup();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  // Создание новой группы
  Future<void> createGroup({
    required String name,
    required String level,
    required String teacher,
    int? room,
    required String price,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    bool? isActive,
  }) async {
    emit(GroupLoading());

    try {
      await api.sendPostGroup(
        name: name,
        level: level,
        teacher: teacher,
        room: room,
        price: price,
        start_date: startDate,
        end_date: endDate,
        start_time: startTime,
        end_time: endTime,
        is_active: isActive,
      );

      // Обновляем список после создания
      await getGroups();
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}