import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/datasources/exam_api_service.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/cubit/exam_cubit.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/widgets/add_exam_dialog.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/widgets/edit_exam_dialog.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_cubit.dart';

IconData _iconForDirection(String direction) {
  if (direction.toLowerCase().contains('math') ||
      direction.toLowerCase().contains('анал'))
    return Icons.functions_outlined;
  if (direction.toLowerCase().contains('prog') ||
      direction.toLowerCase().contains('код'))
    return Icons.code_outlined;
  if (direction.toLowerCase().contains('hist') ||
      direction.toLowerCase().contains('истор'))
    return Icons.history_edu_outlined;
  if (direction.toLowerCase().contains('chem') ||
      direction.toLowerCase().contains('хим'))
    return Icons.science_outlined;
  if (direction.toLowerCase().contains('lang') ||
      direction.toLowerCase().contains('англ'))
    return Icons.language_outlined;
  return Icons.article_outlined;
}

class TheMindExamsPage extends StatefulWidget {
  const TheMindExamsPage({super.key});

  @override
  State<TheMindExamsPage> createState() => _TheMindExamsPageState();
}

class _TheMindExamsPageState extends State<TheMindExamsPage> {
  String _search = '';
  String? _selectedGroup;
  String _statusFilter = 'all';
  int _currentPage = 1;
  final int _perPage = 4;

  List<ExamModel> _filtered(List<ExamModel> exams) => exams.where((e) {
    final matchSearch =
        e.title.toLowerCase().contains(_search.toLowerCase()) ||
        e.groupName.toLowerCase().contains(_search.toLowerCase()) ||
        e.teacherName.toLowerCase().contains(_search.toLowerCase());
    final matchGroup = _selectedGroup == null || e.groupName == _selectedGroup;
    final matchStatus = _statusFilter == 'all' || e.status == _statusFilter;
    return matchSearch && matchGroup && matchStatus;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExamCubit(ExamApiService())..getExams(),
      child: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          final exams = state is ExamLoaded ? state.exams : <ExamModel>[];
          final groups = exams.map((e) => e.groupName).toSet().toList();

          final filtered = _filtered(exams);
          final totalPages = (filtered.length / _perPage).ceil().clamp(1, 999);
          final pageItems = filtered
              .skip((_currentPage - 1) * _perPage)
              .take(_perPage)
              .toList();

          return Scaffold(
            backgroundColor: const Color(0xFFF2F5F7),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Заголовок ──
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Экзамены',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A2233),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Управление расписанием и результатами аттестации',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        // ✅ просто открываем диалог — он сам читает GroupCubit и TeacherCubit
                        onPressed: () => _addExam(context),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 17,
                        ),
                        label: const Text(
                          'Создать экзамен',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED6A2E),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Поиск + фильтры ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.15),
                            ),
                          ),
                          child: TextField(
                            onChanged: (v) => setState(() {
                              _search = v;
                              _currentPage = 1;
                            }),
                            decoration: InputDecoration(
                              hintText:
                                  'Поиск экзаменов по названию, группе или преподавателю...',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 18,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _filterChipBtn(
                              icon: Icons.group_outlined,
                              label: _selectedGroup ?? 'Группа',
                              onTap: () => _showGroupPicker(context, groups),
                              active: _selectedGroup != null,
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            const SizedBox(width: 16),
                            _statusChipBtn('all', 'Все'),
                            const SizedBox(width: 8),
                            _statusChipBtn('planned', 'Запланирован'),
                            const SizedBox(width: 8),
                            _statusChipBtn('started', 'Начался'),
                            const SizedBox(width: 8),
                            _statusChipBtn('finished', 'Закончился'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Список ──
                  Expanded(
                    child: state is ExamLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state is ExamError
                        ? Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : pageItems.isEmpty
                        ? Center(
                            child: Text(
                              'Нет экзаменов',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          )
                        : ListView.separated(
                            itemCount: pageItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) =>
                                _examRow(context, pageItems[i]),
                          ),
                  ),

                  const SizedBox(height: 12),

                  // ── Пагинация ──
                  Row(
                    children: [
                      Text(
                        'Показано ${pageItems.length} из ${filtered.length} экзаменов',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                      const Spacer(),
                      _PaginationRow(
                        currentPage: _currentPage,
                        totalPages: totalPages,
                        onPageChanged: (p) => setState(() => _currentPage = p),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _examRow(BuildContext context, ExamModel e) {
    final statusInfo = _statusInfo(e.status);
    final icon = _iconForDirection(e.groupName);
    final isStarted = e.status == 'started';
    final isFinished = e.status == 'finished';

    final dateStr = isStarted
        ? 'Текущий сеанс'
        : '${e.examDate}  ${e.startTime.length >= 5 ? e.startTime.substring(0, 5) : e.startTime}';

    return GestureDetector(
      onTap: () => _editExam(context, e),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFED6A2E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFFED6A2E)),
            ),
            const SizedBox(width: 16),

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.group_outlined,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        e.groupName,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ЭКЗАМЕНАТОР',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[400],
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.teacherName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ДАТА И ВРЕМЯ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[400],
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A2233),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusInfo['color'] as Color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusInfo['dotColor'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusInfo['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusInfo['dotColor'] as Color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            if (isStarted)
              ElevatedButton(
                onPressed: () => _editExam(context, e),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED6A2E),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Перейти',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else if (isFinished)
              OutlinedButton(
                onPressed: () => _editExam(context, e),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Результаты',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
                ),
              )
            else
              const SizedBox(width: 40),

            IconButton(
              onPressed: () => context.read<ExamCubit>().deleteExam(e.id),
              icon: Icon(Icons.more_vert, size: 18, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _statusInfo(String status) {
    switch (status) {
      case 'started':
        return {
          'label': 'Начался',
          'color': const Color(0xFFFFF3E0),
          'dotColor': const Color(0xFFFF9800),
        };
      case 'finished':
        return {
          'label': 'Закончился',
          'color': const Color(0xFFE8F5E9),
          'dotColor': const Color(0xFF2ECC8A),
        };
      default:
        return {
          'label': 'Запланирован',
          'color': const Color(0xFFE8F0FF),
          'dotColor': const Color(0xFF6B7FD4),
        };
    }
  }

  Widget _filterChipBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool active,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFED6A2E).withOpacity(0.08)
              : const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? const Color(0xFFED6A2E).withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: active ? const Color(0xFFED6A2E) : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? const Color(0xFFED6A2E) : Colors.grey[700],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 15,
              color: active ? const Color(0xFFED6A2E) : Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChipBtn(String value, String label) {
    final isActive = _statusFilter == value;
    return GestureDetector(
      onTap: () => setState(() {
        _statusFilter = value;
        _currentPage = 1;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFED6A2E) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? const Color(0xFFED6A2E)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _showGroupPicker(BuildContext context, List<String> groups) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 200, 0, 0),
      items: [
        PopupMenuItem(
          value: null,
          onTap: () => setState(() {
            _selectedGroup = null;
            _currentPage = 1;
          }),
          child: const Text('Все группы'),
        ),
        ...groups.map(
          (g) => PopupMenuItem(
            value: g,
            onTap: () => setState(() {
              _selectedGroup = g;
              _currentPage = 1;
            }),
            child: Text(g),
          ),
        ),
      ],
    );
  }

  // ✅ Диалог сам читает GroupCubit и TeacherCubit — никаких параметров не нужно
  void _addExam(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ExamCubit>()),
          BlocProvider.value(value: context.read<GroupCubit>()),
          BlocProvider.value(value: context.read<TeacherCubit>()),
        ],
        child: const AddExamDialog(),
      ),
    );
  }

  void _editExam(BuildContext context, ExamModel exam) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditExamDialog(
          exam: exam,
          onSave: () => context.read<ExamCubit>().getExams(),
        ),
      ),
    );
  }
}

// ── Пагинация ─────────────────────────────────────────────────────────────────

class _PaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationRow({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PageBtn(
          icon: Icons.chevron_left,
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        const SizedBox(width: 4),
        ...List.generate(totalPages.clamp(0, 5), (i) {
          final p = i + 1;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _PageNumBtn(
              page: p,
              isActive: p == currentPage,
              onTap: () => onPageChanged(p),
            ),
          );
        }),
        _PageBtn(
          icon: Icons.chevron_right,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _PageBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? Colors.grey[300] : Colors.black87,
        ),
      ),
    );
  }
}

class _PageNumBtn extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;
  const _PageNumBtn({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFED6A2E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? const Color(0xFFED6A2E)
                : Colors.grey.withOpacity(0.25),
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
