import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_state.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_record_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_state.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/create_group_page.dart';

class GroupDetails extends StatefulWidget {
  final int groupId;
  const GroupDetails({super.key, required this.groupId});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final Map<int, bool> _attendance = {};
  final Map<int, int?> _grades = {};
  final Map<int, TextEditingController> _hwControllers = {};
  bool _saving = false;

  String get _lessonDate =>
      DateTime.now().toIso8601String().substring(0, 10);
  final int _lessonNumber = 14;
  final int _totalLessons = 24;

  // хранит teacherId после загрузки группы
  String? _teacherId;

  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().getGroupDetails(widget.groupId);
  }

  @override
  void dispose() {
    for (final c in _hwControllers.values) c.dispose();
    super.dispose();
  }

  void _initStudentMaps(List<Map<String, dynamic>> students) {
    for (final s in students) {
      final id = s['student'] as int;
      if (!_attendance.containsKey(id)) {
        _attendance[id] = false;
        _grades[id] = null;
        _hwControllers[id] = TextEditingController();
      }
    }
  }

  int get _presentCount => _attendance.values.where((v) => v).length;

  Future<void> _saveJournal(
    List<Map<String, dynamic>> students,
  ) async {
    if (_teacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет ID преподавателя')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final records = students.map((s) {
        final id = s['student'] as int;
        final hwText = _hwControllers[id]?.text.trim() ?? '';
        return StudentRecordModel(
          studentId: id,
          firstName: '',
          lastName: '',
          fullName: s['student_name'] as String? ?? '',
          classScore: _grades[id],
          homeworkScore: int.tryParse(hwText),
          attendance: (_attendance[id] ?? false) ? 'present' : 'absent',
          absenceReason: '',
        );
      }).toList();

      await StudentRepository().saveJournal(
        groupId: widget.groupId,
        lessonDate: _lessonDate,
        teacherId: _teacherId!,
        records: records,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Журнал сохранён'),
            backgroundColor: Color(0xFF2ECC8A),
          ),
        );
      }
    } catch (e) {
      print("erroorr$e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        if (state is GroupLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF2F5F7),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFED6A2E)),
            ),
          );
        }

        if (state is GroupError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF2F5F7),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<GroupCubit>().getGroupDetails(
                      widget.groupId,
                    ),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! GroupDetailsLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        _initStudentMaps(state.students);

        final group = state.group;
        final students = state.students;

        // сохраняем teacherId при первой загрузке
        if (_teacherId == null && group.teacher != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _teacherId = group.teacher);
          });
        }
        final price = double.tryParse(group.price ?? '0') ?? 0.0;
        final dailyIncome = _presentCount * price;

        return Scaffold(
          backgroundColor: const Color(0xFFF2F5F7),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(group),
                    const SizedBox(height: 20),
                    _buildInfoAndFinance(group, dailyIncome),
                    const SizedBox(height: 20),
                    Expanded(child: _buildAttendanceTable(students, group)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Диалог добавления студента из списка ────────────────────────
  void _openAddStudentDialog() {
    final studentState = context.read<StudentCubit>().state;
    final allStudents = studentState is StudentLoaded ? studentState.students : <StudentModel>[];

    showDialog(
      context: context,
      builder: (dialogContext) {
        String search = '';
        bool adding = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filtered = allStudents.where((s) {
              final q = search.toLowerCase();
              final name = '${s.firstName ?? ''} ${s.lastName ?? ''}'.toLowerCase();
              final phone = (s.phone ?? '').toLowerCase();
              return q.isEmpty || name.contains(q) || phone.contains(q);
            }).toList();

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.12))),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFED6A2E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.person_add_outlined, color: Color(0xFFED6A2E), size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Добавить студента в группу',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36)),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: Icon(Icons.close, color: Colors.grey[400], size: 20),
                          ),
                        ],
                      ),
                    ),
                    // Search
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                      child: TextField(
                        autofocus: true,
                        onChanged: (v) => setDialogState(() => search = v),
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Поиск по имени или телефону...',
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFED6A2E)),
                          ),
                        ),
                      ),
                    ),
                    // List
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 360),
                      child: filtered.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text('Студенты не найдены', style: TextStyle(color: Colors.grey[400])),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => Divider(color: Colors.grey.withOpacity(0.08), height: 1),
                              itemBuilder: (_, i) {
                                final s = filtered[i];
                                final name = '${s.lastName ?? ''} ${s.firstName ?? ''}'.trim();
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  leading: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: const Color(0xFFED6A2E).withOpacity(0.12),
                                    child: Text(
                                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFED6A2E)),
                                    ),
                                  ),
                                  title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
                                  subtitle: Text(s.phone ?? '—', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                  trailing: adding
                                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFED6A2E)))
                                      : const Icon(Icons.add_circle_outline, color: Color(0xFFED6A2E), size: 20),
                                  onTap: adding
                                      ? null
                                      : () async {
                                          if (s.id == null) return;
                                          setDialogState(() => adding = true);
                                          try {
                                            await StudentRepository().assignGroupToStudent(
                                              studentId: s.id!,
                                              groupId: widget.groupId,
                                            );
                                            if (!dialogContext.mounted) return;
                                            Navigator.pop(dialogContext);
                                            if (mounted) {
                                              context.read<GroupCubit>().getGroupDetails(widget.groupId);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('✅ $name добавлен в группу'),
                                                  backgroundColor: const Color(0xFF2ECC8A),
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            setDialogState(() => adding = false);
                                            if (dialogContext.mounted) {
                                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                  backgroundColor: Colors.redAccent,
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Шапка — оригинальный UI, данные из API ──────────────────────
  Widget _buildHeader(GroupModel group) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233),
                  ),
                  children: [
                    const TextSpan(text: 'Группа: '),
                    TextSpan(
                      text: group.name ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${group.weekDays ?? ""}  |  ${group.startTime ?? ""} – ${group.endTime ?? ""}',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<GroupCubit>(),
              child: CreateGroupPage(group: group),
            ),
          ),
          icon: Icon(Icons.edit_outlined, size: 15, color: Colors.grey[700]),
          label: Text(
            'Редактировать',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: _openAddStudentDialog,
          icon: const Icon(Icons.add, size: 15, color: Colors.white),
          label: const Text(
            'Добавить студента',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFED6A2E),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // ── Информация + Финансы — оригинальный UI, данные из API ───────
  // ── Информация — точно как на скриншоте ─────────────────────────
  Widget _buildInfoAndFinance(GroupModel group, double dailyIncome) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 310,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      size: 15,
                      color: Color(0xFFED6A2E),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Информация',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _infoRow(
                  'Основной учитель',
                  group.teacherName ?? '—',
                  const Color(0xFF1A2233),
                ),
                const SizedBox(height: 14),
                // Замена — нет в API, оставляем прочерк
                _infoRow('Замена', '—', const Color(0xFFED6A2E)),
                const SizedBox(height: 14),
                _infoRow(
                  'Учебная комната',
                  group.roomName ?? '—',
                  const Color(0xFF1A2233),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 15,
                        color: Color(0xFFED6A2E),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Финансы преподавателя',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // СТАВКА ЗА УЧЕНИКА — нет в API, показываем из group.price
                      _financeStat(
                        'СТАВКА ЗА УЧЕНИКА',
                        '${group.price ?? "0"} Сум',
                        Colors.black87,
                      ),
                      const SizedBox(width: 40),
                      // ДОХОД ЗА ДЕНЬ — считаем сами
                      _financeStat(
                        'ДОХОД ЗА ДЕНЬ',
                        '${dailyIncome.toStringAsFixed(0)} Сум',
                        const Color(0xFFED6A2E),
                      ),
                      const SizedBox(width: 40),
                      // ТЕКУЩИЙ БАЛАНС — нет в API, прочерк
                      _financeStat(
                        'ТЕКУЩИЙ БАЛАНС',
                        '—',
                        const Color(0xFF2ECC8A),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _financeStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.grey[400],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ── Таблица — оригинальный UI, данные из API ────────────────────
  Widget _buildAttendanceTable(List<Map<String, dynamic>> students, GroupModel group) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A2233),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Посещаемость и успеваемость: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: _lessonDate,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 6),
                Text(
                  'Урок №$_lessonNumber из $_totalLessons',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _saving ? null : () => _saveJournal(students),
                  icon: _saving
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined, size: 15, color: Colors.white),
                  label: Text(
                    _saving ? 'Сохранение...' : 'Сохранить',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED6A2E),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 40),
                SizedBox(width: 12),
                Expanded(flex: 4, child: _ColHeader('ИМЯ СТУДЕНТА')),
                Expanded(flex: 3, child: _ColHeader('СТАТУС')),
                Expanded(flex: 3, child: _ColHeader('БАЛАНС')),
                Expanded(flex: 2, child: _ColHeader('БЫЛ/НЕТ')),
                Expanded(flex: 2, child: _ColHeader('ОЦЕНКА')),
                Expanded(flex: 3, child: _ColHeader('ДЗ')),
              ],
            ),
          ),

          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Text(
                      'Студентов нет',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  )
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, i) => _buildStudentRow(students[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRow(Map<String, dynamic> s) {
    final studentId =
        (s['student'] as num?)?.toInt() ??
        int.tryParse(s['student']?.toString() ?? '') ??
        0;

    // ✅ Пробуем все возможные поля для имени
    final name =
        s['student_name']?.toString() ??
        s['name']?.toString() ??
        s['full_name']?.toString() ??
        s['student_full_name']?.toString() ??
        '—';
    final isActive = s['is_active'] as bool? ?? true;
    final isStopped = s['is_stopped'] as bool? ?? false;
    final isPresent = _attendance[studentId] ?? false;
    final grade = _grades[studentId];

    _hwControllers.putIfAbsent(studentId, () => TextEditingController());

    return StatefulBuilder(
      builder: (context, setRowState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.07)),
            ),
          ),
          child: Row(
            children: [
              _avatar(name),
              const SizedBox(width: 12),

              // Имя
              Expanded(
                flex: 4,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A2233),
                  ),
                ),
              ),

              // Статус — из API
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isStopped
                          ? Colors.grey.withOpacity(0.1)
                          : isActive
                          ? const Color(0xFF2ECC8A).withOpacity(0.1)
                          : const Color(0xFFED6A2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isStopped
                          ? 'Остановлен'
                          : isActive
                          ? 'Активен'
                          : 'Неактивен',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isStopped
                            ? Colors.grey
                            : isActive
                            ? const Color(0xFF2ECC8A)
                            : const Color(0xFFED6A2E),
                      ),
                    ),
                  ),
                ),
              ),

              // Баланс — пока нет в student-groups API, показываем прочерк
              Expanded(
                flex: 3,
                child: Text(
                  '—',
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                ),
              ),

              // Чекбокс
              Expanded(
                flex: 2,
                child: Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: isPresent,
                    activeColor: const Color(0xFFED6A2E),
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.4),
                      width: 1.5,
                    ),
                    onChanged: (v) {
                      setState(() => _attendance[studentId] = v ?? false);
                      setRowState(() {});
                    },
                  ),
                ),
              ),

              // Оценка
              Expanded(
                flex: 2,
                child: isPresent
                    ? _gradeDropdown(studentId, grade, setRowState)
                    : Text(
                        '—',
                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
                      ),
              ),

              // ДЗ
              Expanded(
                flex: 3,
                child: isPresent
                    ? _hwField(studentId)
                    : Text(
                        '—',
                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _avatar(String name) {
    final parts = name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty
        ? name[0].toUpperCase()
        : '?';
    const colors = [
      Color(0xFFED6A2E),
      Color(0xFF6B7FD4),
      Color(0xFF2ECC8A),
      Color(0xFF8A9BB8),
    ];
    final color = colors[name.length % colors.length];
    return CircleAvatar(
      radius: 18,
      backgroundColor: color.withOpacity(0.15),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _gradeDropdown(int studentId, int? grade, StateSetter setRowState) {
    return SizedBox(
      height: 34,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: grade,
          isDense: true,
          hint: Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.grey[400],
          ),
          icon: grade != null
              ? Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.grey[400],
                )
              : const SizedBox.shrink(),
          selectedItemBuilder: (_) => List.generate(
            5,
            (i) => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${i + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2233),
                ),
              ),
            ),
          ),
          items: List.generate(5, (i) {
            final v = i + 1;
            return DropdownMenuItem(
              value: v,
              child: Text(
                '$v',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
          onChanged: (v) {
            setState(() => _grades[studentId] = v);
            setRowState(() {});
          },
        ),
      ),
    );
  }

  Widget _hwField(int studentId) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: _hwControllers[studentId],
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: '1–10',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFED6A2E)),
          ),
        ),
      ),
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String text;
  const _ColHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xFF8A9BB8),
        letterSpacing: 0.4,
      ),
    );
  }
}
