import 'package:srm/src/the_mind/the_mind_students/data/model/students/ui_summary_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel dashboard;
  DashboardLoaded({required this.dashboard});
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError({required this.message});
}