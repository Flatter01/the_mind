import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_state.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/analytic/analytic_item.dart'
    show AnalyticItem;
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

  final List<AnalyticItem> analytics = const [
    AnalyticItem(
      title: 'Лиды',
      value: '124',
      sub: '+12% за месяц',
      subPositive: true,
      icon: Icons.people_alt_outlined,
      iconColor: Color(0xFF6B7FD4),
    ),
    AnalyticItem(
      title: 'Студенты',
      value: '850',
      sub: 'Всего активных',
      subPositive: null,
      icon: Icons.school_outlined,
      iconColor: Color(0xFF2ECC8A),
    ),
    AnalyticItem(
      title: 'Должники',
      value: '42',
      sub: '5% от общего числа',
      subPositive: false,
      icon: Icons.warning_amber_rounded,
      iconColor: Color(0xFFED6A2E),
    ),
    AnalyticItem(
      title: 'Сумма долга',
      value: '450,000 Сум',
      sub: 'К получению',
      subPositive: null,
      icon: Icons.account_balance_wallet_outlined,
      iconColor: Color(0xFF8A9BB8),
    ),
    AnalyticItem(
      title: 'Группы',
      value: '36',
      sub: '8 направлений',
      subPositive: null,
      icon: Icons.groups_outlined,
      iconColor: Color(0xFF1A2233),
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<StudentCubit>().getStudents();
  }

  @override
  Widget build(BuildContext context) {
    // ← GroupCubit'дан гуруҳларни оламиз
    final groupState = context.watch<GroupCubit>().state;
    final groups = groupState is GroupLoaded
        ? groupState.groups
        : <GroupModel>[];

    // Гуруҳ номлари → AddStudentDialog'га
    final groupNames = groups
        .map((g) => g.name ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    // Ўқитувчи номлари → FiltersCard'га
    final teacherNames = groups
        .map((g) => g.teacherName ?? '')
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();

    // Курс номлари → FiltersCard'га
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
          print(state.message);
          return Center(child: Text(state.message));
        }
        if (state is StudentLoaded) {
          final students = state.students;

          final filtered = students.where((s) {
            final q = _search.toLowerCase();
            final matchSearch =
                (s.firstName ?? '').toLowerCase().contains(q) ||
                (s.lastName ?? '').toLowerCase().contains(q) ||
                (s.phone ?? '').toLowerCase().contains(q) ||
                (s.groupName ?? '').toLowerCase().contains(q);
            final matchTeacher =
                _selectedTeacher == null ||
                (s.teacherName ?? '') == _selectedTeacher;
            final matchCourse =
                _selectedCourse == null ||
                (s.groupName ?? '').contains(_selectedCourse!);
            final matchStatus =
                _selectedStatus == null ||
                s.status.toLowerCase() == _selectedStatus!.toLowerCase();
            return matchSearch && matchTeacher && matchCourse && matchStatus;
          }).toList();

          final totalPages = (filtered.length / _perPage).ceil();
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

                    // Добавить платеж
                    OutlinedButton.icon(
                      onPressed: () async {
                        final paymentCubit = context.read<PaymentCubit>();
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => BlocProvider.value(
                            value: paymentCubit,
                            child: BlocBuilder<StudentCubit, StudentState>(
                              builder: (context, state) {
                                if (state is StudentLoaded) {
                                  return AddPaymentDialogResponsive(
                                    students: state.students,
                                  );
                                }
                                return const SizedBox();
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

                    // Добавить студента — гуруҳлар API'дан ←
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
                              groupModels:
                                  groups, // ← GroupModel рўйхати қўшилди
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
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: analytics.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) =>
                        AnalyticCard(item: analytics[index]),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Фильтры — API'дан ←
                FiltersCard(
                  search: _search,
                  selectedDayType: _selectedDayType,
                  selectedTeacher: _selectedTeacher,
                  selectedCourse: _selectedCourse,
                  selectedStatus: _selectedStatus,
                  teachers: teacherNames, // ← API'дан
                  courses: courseNames, // ← API'дан
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
