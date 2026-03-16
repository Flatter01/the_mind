// dashboard_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/ui_summary_model.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  void computeFromStudents({
    required List<StudentModel> students,
    required int groupsCount,
  }) {
    if (isClosed) return;

    final activeLeads = students
        .where((s) => s.status.toLowerCase() == 'lead')
        .length;
    final activeStudents = students
        .where((s) => s.status.toLowerCase() == 'active')
        .length;
    final debtors = students
        .where((s) => s.status.toLowerCase() == 'debtor')
        .length;

    final dashboard = DashboardModel(
      month: '',
      cards: Cards(
        activeLeads: activeLeads,
        activeStudents: activeStudents,
        debtors: debtors,
        totalDebt: '—',
        groups: groupsCount,
      ),
    );

    emit(DashboardLoaded(dashboard: dashboard));
  }
}