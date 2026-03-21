import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_state.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/analytic/analytic_item.dart'
    show AnalyticItem;
import 'package:srm/src/the_mind/the_mind_students/data/model/students/ui_summary_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/dashboard/dashboard_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/dashboard/dashboard_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_payment/add_payment_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/analytic/analytic_item.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/filter/filters_card.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/shimmer_student_loading_widget.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/students_table.dart';

class TheMindStudentsPage extends StatefulWidget {
  const TheMindStudentsPage({super.key});

  @override
  State<TheMindStudentsPage> createState() => _TheMindStudentsPageState();
}

class _TheMindStudentsPageState extends State<TheMindStudentsPage> {
  String _search = '';
  String? _selectedDayType;
  String? _selectedTeacher;
  String? _selectedCourse;
  String? _selectedStatus;
  int _currentPage = 1;
  final int _perPage = 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<StudentCubit>().getStudents();
  }

  List<AnalyticItem> _buildAnalytics(DashboardModel dashboard) {
    final cards = dashboard.cards;
    return [
      AnalyticItem(
        title: 'Лиды',
        value: cards.activeLeads.toString(),
        sub: 'Активные лиды',
        subPositive: null,
        icon: Icons.people_alt_outlined,
        iconColor: const Color(0xFF6B7FD4),
      ),
      AnalyticItem(
        title: 'Студенты',
        value: cards.activeStudents.toString(),
        sub: 'Всего активных',
        subPositive: null,
        icon: Icons.school_outlined,
        iconColor: const Color(0xFF2ECC8A),
      ),
      AnalyticItem(
        title: 'Должники',
        value: cards.debtors.toString(),
        sub: 'Текущие должники',
        subPositive: false,
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFED6A2E),
      ),
      AnalyticItem(
        title: 'Сумма долга',
        value: cards.totalDebt,
        sub: 'К получению',
        subPositive: null,
        icon: Icons.account_balance_wallet_outlined,
        iconColor: const Color(0xFF8A9BB8),
      ),
      AnalyticItem(
        title: 'Группы',
        value: cards.groups.toString(),
        sub: 'Активные группы',
        subPositive: null,
        icon: Icons.groups_outlined,
        iconColor: const Color(0xFF1A2233),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final groupState = context.watch<GroupCubit>().state;
    final groups = groupState is GroupLoaded
        ? groupState.groups
        : <GroupModel>[];

    final groupNames = groups
        .map((g) => g.name ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    final teacherNames = groups
        .map((g) => g.teacherName ?? '')
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();

    final courseNames = groups
        .map((g) => g.levelDisplay ?? g.level ?? '')
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();

    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        if (state is StudentLoading) {
          return TheMindStudentsPageShimmer();
        }
        if (state is StudentError) {
          return Center(child: Text(state.message));
        }
        if (state is StudentLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<DashboardCubit>().computeFromStudents(
              students: state.students,
              groupsCount: groups.length,
            );
          });

          final students = state.students;

          // Map groupId → weekDays для фильтра по дням
          final groupWeekDays = {
            for (final g in groups)
              if (g.id != null) g.id.toString(): g.weekDays ?? '',
          };

          final filtered = students.where((s) {
            final q = _search.toLowerCase();

            final matchSearch =
                _search.isEmpty ||
                (s.firstName ?? '').toLowerCase().contains(q) ||
                (s.lastName ?? '').toLowerCase().contains(q) ||
                (s.phone ?? '').toLowerCase().contains(q) ||
                (s.groupName ?? '').toLowerCase().contains(q);

            final matchTeacher =
                _selectedTeacher == null ||
                (s.teacherName ?? '') == _selectedTeacher;

            final matchCourse =
                _selectedCourse == null ||
                (s.groupName ?? '').toLowerCase().contains(
                  _selectedCourse!.toLowerCase(),
                );

            final matchStatus = _selectedStatus == null || () {
              final st = s.status.toLowerCase();
              switch (_selectedStatus) {
                case 'active':   return st == 'active';
                case 'inactive': return st == 'inactive';
                case 'trial':    return st == 'trial';
                case 'frozen':   return st == 'frozen';
                case 'debtor':   return (double.tryParse(s.balance) ?? 0) < 0;
                default:         return true;
              }
            }();

            // ✅ Фильтр по чётным/нечётным дням
            bool matchDayType = true;
            if (_selectedDayType != null) {
              final days = (groupWeekDays[s.groupId ?? ''] ?? '').toLowerCase();
              // Чётные = пн/ср/пт (Monday, Wednesday, Friday, 1, 3, 5)
              final isEven = days.contains('mon') ||
                  days.contains('wed') ||
                  days.contains('fri') ||
                  days.contains('пн') ||
                  days.contains('ср') ||
                  days.contains('пт') ||
                  RegExp(r'\b[135]\b').hasMatch(days);
              // Нечётные = вт/чт/сб (Tuesday, Thursday, Saturday, 2, 4, 6)
              final isOdd = days.contains('tue') ||
                  days.contains('thu') ||
                  days.contains('sat') ||
                  days.contains('вт') ||
                  days.contains('чт') ||
                  days.contains('сб') ||
                  RegExp(r'\b[246]\b').hasMatch(days);
              if (_selectedDayType == 'even') matchDayType = isEven;
              if (_selectedDayType == 'odd') matchDayType = isOdd;
            }

            return matchSearch && matchTeacher && matchCourse && matchStatus && matchDayType;
          }).toList();

          final totalPages = (filtered.length / _perPage).ceil().clamp(1, 999);
          final pageStudents = filtered
              .skip((_currentPage - 1) * _perPage)
              .take(_perPage)
              .toList();

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              children: [
                // ── Заголовок + кнопки ──
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Справочник студентов',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A2233),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Управление базой данных и отслеживание оплат',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () {
                        final paymentCubit = context.read<PaymentCubit>();
                        final studentCubit = context.read<StudentCubit>();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => BlocProvider.value(
                            value: paymentCubit,
                            child: AddPaymentDialogResponsive(
                              students: students,
                              onPaymentSuccess: () {
                                studentCubit.getStudents();
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.credit_card_outlined, size: 18),
                      label: const Text('Добавить платеж'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final studentCubit = context.read<StudentCubit>();
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => BlocProvider.value(
                            value: studentCubit,
                            child: AddStudentDialogResponsive(
                              courses: courseNames.isEmpty
                                  ? ['IELTS', 'General English', 'Math']
                                  : courseNames,
                              groups: groupNames.isEmpty
                                  ? ['Guruh topilmadi']
                                  : groupNames,
                              groupModels: groups,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.person_add_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Добавить студента',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED6A2E),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Аналитика ──
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, dashState) {
                    if (dashState is DashboardInitial ||
                        dashState is DashboardLoading) {
                      return const SizedBox(
                        height: 130,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (dashState is DashboardError) {
                      return SizedBox(
                        height: 130,
                        child: Center(
                          child: Text(
                            dashState.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }
                    final analytics = dashState is DashboardLoaded
                        ? _buildAnalytics(dashState.dashboard)
                        : <AnalyticItem>[];
                    return SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: analytics.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) =>
                            AnalyticCard(item: analytics[index]),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── Фильтры ──
                // ✅ Передаём русские лейблы статусов в фильтр
                FiltersCard(
                  search: _search,
                  selectedDayType: _selectedDayType,
                  selectedTeacher: _selectedTeacher,
                  selectedCourse: _selectedCourse,
                  selectedStatus: _selectedStatus,
                  teachers: teacherNames,
                  courses: courseNames,
                  // ← statuses: убрать, оно не нужно
                  onSearchChanged: (v) => setState(() {
                    _search = v;
                    _currentPage = 1;
                  }),
                  onDayTypeChanged: (v) => setState(() {
                    _selectedDayType = v;
                    _currentPage = 1;
                  }),
                  onTeacherChanged: (v) => setState(() {
                    _selectedTeacher = v;
                    _currentPage = 1;
                  }),
                  onCourseChanged: (v) => setState(() {
                    _selectedCourse = v;
                    _currentPage = 1;
                  }),
                  onStatusChanged: (v) => setState(() {
                    _selectedStatus = v;
                    _currentPage = 1;
                  }),
                  onReset: () => setState(() {
                    _search = '';
                    _selectedDayType = null;
                    _selectedTeacher = null;
                    _selectedCourse = null;
                    _selectedStatus = null;
                    _currentPage = 1;
                  }),
                ),
                const SizedBox(height: 20),

                // ── Таблица студентов ──
                StudentsTable(
                  students: pageStudents,
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  totalCount: filtered.length,
                  perPage: _perPage,
                  onPageChanged: (p) => setState(() => _currentPage = p),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
