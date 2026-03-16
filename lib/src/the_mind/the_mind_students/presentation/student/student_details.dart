import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/history/history_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/journal/journal_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/journal/journal_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/history_item.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/info_field.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/profile_header.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/score_metric.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/section_card.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/table_header.dart';

class StudentDetailsPage extends StatefulWidget {
  final StudentModel student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  int _selectedTab = 0;
  int _discountAmount = 0;
  bool _editingDiscount = false;
  late TextEditingController _discountCtrl;

  final List<Map<String, dynamic>> payments = const [
    {
      "date": "12.10.2023",
      "purpose": "Оплата обучения (Октябрь)",
      "amount": "8 500 Сум",
      "status": "Успешно",
    },
    {
      "date": "15.09.2023",
      "purpose": "Учебные материалы",
      "amount": "1 200 Сум",
      "status": "Успешно",
    },
  ];

  @override
  void initState() {
    super.initState();
    _discountCtrl = TextEditingController(text: _discountAmount.toString());

    // Загружаем журнал — JournalCubit уже в дереве через main.dart
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = widget.student;
      context.read<JournalCubit>().loadJournal(
            groupId: int.tryParse(s.groupId ?? '') ?? 0,
            lessonDate: DateTime.now().toIso8601String().substring(0, 10),
            teacherId: s.teacherId?.toString() ?? '',
          );
    });
  }

  @override
  void dispose() {
    _discountCtrl.dispose();
    super.dispose();
  }

  int get _rawBalance {
    final raw = widget.student.balance.replaceAll(RegExp(r'[^0-9\-]'), '');
    return int.tryParse(raw) ?? 0;
  }

  int get _debtAmount => _rawBalance < 0 ? _rawBalance.abs() : 0;

  int get _debtAfterDiscount {
    final debt = _debtAmount - _discountAmount;
    return debt < 0 ? 0 : debt;
  }

  int get _balanceAfterDiscount {
    if (_rawBalance < 0) return -_debtAfterDiscount;
    return _rawBalance;
  }

  String get _balanceDisplay {
    final v = _rawBalance;
    return v < 0 ? '-${v.abs()} Сум' : '$v Сум';
  }

  String get _debtAfterDiscountDisplay =>
      _debtAfterDiscount > 0 ? '-$_debtAfterDiscount Сум' : '0 Сум';

  void _saveDiscount() {
    final val = int.tryParse(_discountCtrl.text) ?? 0;
    setState(() {
      _discountAmount = val;
      _editingDiscount = false;
    });
  }

  Color _colorFromApi(String color) {
    switch (color.toLowerCase()) {
      case 'orange':
        return const Color(0xFFED6A2E);
      case 'red':
        return Colors.redAccent;
      case 'blue':
        return const Color(0xFF6B7FD4);
      case 'green':
        return const Color(0xFF2ECC8A);
      case 'gray':
      default:
        return const Color(0xFF8A9BB8);
    }
  }

  IconData _iconFromApi(String icon) {
    switch (icon.toLowerCase()) {
      case 'payment':
        return Icons.account_balance_wallet_outlined;
      case 'absence':
        return Icons.cancel_outlined;
      case 'group':
        return Icons.group_add_outlined;
      case 'profile':
        return Icons.person_add_outlined;
      default:
        return Icons.info_outline;
    }
  }

  // Цвет по оценке
  Color _scoreColor(int? score) {
    if (score == null) return const Color(0xFF8A9BB8);
    if (score >= 5) return const Color(0xFF2ECC8A);
    if (score >= 4) return const Color(0xFF6B7FD4);
    if (score >= 3) return Colors.orange;
    return Colors.redAccent;
  }

  void _openEditStudent(StudentModel student) {
    final firstNameCtrl = TextEditingController(text: student.firstName);
    final lastNameCtrl = TextEditingController(text: student.lastName);
    final phoneCtrl = TextEditingController(text: student.phone);

    String status = student.status ?? 'active';
    String group = student.groupName ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Редактировать студента"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: firstNameCtrl,
                      decoration: const InputDecoration(labelText: "Имя"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lastNameCtrl,
                      decoration: const InputDecoration(labelText: "Фамилия"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(labelText: "Телефон"),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: ["active", "inactive"].contains(status)
                          ? status
                          : null,
                      decoration: const InputDecoration(labelText: "Статус"),
                      items: const [
                        DropdownMenuItem(
                          value: "active",
                          child: Text("Активный"),
                        ),
                        DropdownMenuItem(
                          value: "inactive",
                          child: Text("Не активный"),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          status = v!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: ["Flutter", "Frontend", "Backend"].contains(group)
                          ? group
                          : null,
                      decoration: const InputDecoration(labelText: "Группа"),
                      items: const [
                        DropdownMenuItem(
                          value: "Flutter",
                          child: Text("Flutter"),
                        ),
                        DropdownMenuItem(
                          value: "Frontend",
                          child: Text("Frontend"),
                        ),
                        DropdownMenuItem(
                          value: "Backend",
                          child: Text("Backend"),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          group = v!;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedStudent = student.copyWith(
                  firstName: firstNameCtrl.text,
                  lastName: lastNameCtrl.text,
                  phone: phoneCtrl.text,
                  status: status,
                  groupName: group,
                );
                // context.read<StudentCubit>().updateStudent(updatedStudent);
                Navigator.pop(context);
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final isDebtor = _balanceAfterDiscount < 0;

    return BlocProvider(
      create: (_) =>
          HistoryCubit(repository: StudentRepository())
            ..getHistory(s.id.toString()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5F7),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    student: s,
                    isDebtor: isDebtor,
                    onEdit: () => _openEditStudent(s),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Левая колонка ──
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            // Личные данные
                            SectionCard(
                              title: 'Личные данные',
                              trailing: Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoField(
                                          label: 'ИМЯ ФАМИЛИЯ',
                                          value:
                                              '${s.lastName ?? ''} ${s.firstName ?? ''}',
                                        ),
                                      ),
                                      Expanded(
                                        child: InfoField(
                                          label: 'ДАТА РОЖДЕНИЯ',
                                          value: s.birthDate ?? '—',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoField(
                                          label: 'ПОЛ',
                                          value: s.gender ?? '—',
                                        ),
                                      ),
                                      Expanded(
                                        child: InfoField(
                                          label: 'ТЕЛЕФОН',
                                          value: s.phone ?? '—',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoField(
                                          label: 'ОСНОВНАЯ ГРУППА',
                                          value: s.groupName ?? '—',
                                          valueColor: const Color(0xFFED6A2E),
                                        ),
                                      ),
                                      Expanded(
                                        child: InfoField(
                                          label: 'ПРЕПОДАВАТЕЛЬ',
                                          value: s.teacherName ?? '—',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Финансовое состояние
                            SectionCard(
                              title: 'Финансовое состояние',
                              trailing: _debtAfterDiscount > 0
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          size: 14,
                                          color: Color(0xFFED6A2E),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Долг: $_debtAfterDiscountDisplay',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFED6A2E),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: InfoField(
                                          label: 'ОБЩИЙ БАЛАНС',
                                          value: _balanceDisplay,
                                          valueColor: _rawBalance < 0
                                              ? const Color(0xFFED6A2E)
                                              : const Color(0xFF2ECC8A),
                                          valueBold: true,
                                          valueFontSize: 22,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ПЕРСОНАЛЬНАЯ СКИДКА',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[400],
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            if (_editingDiscount)
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 38,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(
                                                            0xFFED6A2E,
                                                          ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            _discountCtrl,
                                                        autofocus: true,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                        ],
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                          suffixText: 'Сум',
                                                          suffixStyle:
                                                              TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        onSubmitted: (_) =>
                                                            _saveDiscount(),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  GestureDetector(
                                                    onTap: _saveDiscount,
                                                    child: Container(
                                                      width: 32,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFF2ECC8A,
                                                        ).withOpacity(0.12),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: const Icon(
                                                        Icons.check,
                                                        size: 16,
                                                        color:
                                                            Color(0xFF2ECC8A),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  GestureDetector(
                                                    onTap: () => setState(
                                                      () =>
                                                          _editingDiscount =
                                                              false,
                                                    ),
                                                    child: Container(
                                                      width: 32,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 16,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            else
                                              GestureDetector(
                                                onTap: () {
                                                  _discountCtrl.text =
                                                      _discountAmount
                                                          .toString();
                                                  setState(
                                                    () =>
                                                        _editingDiscount = true,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      _discountAmount > 0
                                                          ? '$_discountAmount Сум'
                                                          : 'Не задана',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            _discountAmount > 0
                                                                ? const Color(
                                                                    0xFF2ECC8A,
                                                                  )
                                                                : Colors
                                                                    .grey[400],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 8,
                                                        vertical: 3,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFFED6A2E,
                                                        ).withOpacity(0.08),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        border: Border.all(
                                                          color: const Color(
                                                            0xFFED6A2E,
                                                          ).withOpacity(0.3),
                                                        ),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 11,
                                                            color: Color(
                                                              0xFFED6A2E,
                                                            ),
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            'изменить',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: Color(
                                                                0xFFED6A2E,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: InfoField(
                                          label: 'К ОПЛАТЕ',
                                          value: _debtAfterDiscount > 0
                                              ? '$_debtAfterDiscount Сум'
                                              : '0 Сум',
                                          valueColor: _debtAfterDiscount > 0
                                              ? const Color(0xFFED6A2E)
                                              : const Color(0xFF2ECC8A),
                                          valueBold: true,
                                          valueFontSize: 22,
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (_discountAmount > 0 &&
                                      _debtAmount > 0) ...[
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF2ECC8A,
                                        ).withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.discount_outlined,
                                            size: 14,
                                            color: Color(0xFF2ECC8A),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Скидка $_discountAmount Сум применена. Долг был: $_debtAmount Сум → к оплате: $_debtAfterDiscount Сум',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF2ECC8A),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  if (_discountAmount > 0 &&
                                      _debtAmount == 0) ...[
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.orange.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 14,
                                            color: Colors.orange,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Скидка задана, но у студента нет долга.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 8),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                          flex: 2,
                                          child: TableHeader('ДАТА'),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: TableHeader('НАЗНАЧЕНИЕ'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TableHeader('СУММА'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TableHeader('СТАТУС'),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ...payments.map(
                                    (p) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              p['date'],
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              p['purpose'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              p['amount'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              p['status'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF2ECC8A),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Академические успехи — данные из JournalCubit ──
                            BlocBuilder<JournalCubit, JournalState>(
                              builder: (context, journalState) {
                                // Запись текущего студента
                                final record = journalState is JournalLoaded
                                    ? journalState.records
                                        .where((r) => r.studentId == s.id)
                                        .firstOrNull
                                    : null;

                                // Средние по группе для ScoreMetric
                                double avgHw = 0;
                                double avgClass = 0;
                                int countHw = 0;
                                int countClass = 0;
                                if (journalState is JournalLoaded) {
                                  for (final r in journalState.records) {
                                    if (r.homeworkScore != null) {
                                      avgHw += r.homeworkScore!;
                                      countHw++;
                                    }
                                    if (r.classScore != null) {
                                      avgClass += r.classScore!;
                                      countClass++;
                                    }
                                  }
                                  if (countHw > 0) avgHw /= countHw;
                                  if (countClass > 0) avgClass /= countClass;
                                }

                                // grades — строим из API или показываем заглушки
                                final grades = record != null
                                    ? <Map<String, dynamic>>[
                                        {
                                          "label":
                                              record.classScore?.toString() ??
                                                  '—',
                                          "subject": "Оценка за урок",
                                          "color":
                                              _scoreColor(record.classScore),
                                        },
                                        {
                                          "label":
                                              record.homeworkScore?.toString() ??
                                                  '—',
                                          "subject": "Домашнее задание",
                                          "color": _scoreColor(
                                              record.homeworkScore),
                                        },
                                        {
                                          "label":
                                              record.attendance == 'present'
                                                  ? '✓'
                                                  : '✗',
                                          "subject": "Посещаемость",
                                          "color":
                                              record.attendance == 'present'
                                                  ? const Color(0xFF2ECC8A)
                                                  : Colors.redAccent,
                                        },
                                      ]
                                    : <Map<String, dynamic>>[
                                        {
                                          "label": "—",
                                          "subject": "Оценка за урок",
                                          "color": const Color(0xFF8A9BB8),
                                        },
                                        {
                                          "label": "—",
                                          "subject": "Домашнее задание",
                                          "color": const Color(0xFF8A9BB8),
                                        },
                                        {
                                          "label": "—",
                                          "subject": "Посещаемость",
                                          "color": const Color(0xFF8A9BB8),
                                        },
                                      ];

                                return SectionCard(
                                  title: 'Академические успехи',
                                  trailing: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Детальный отчет',
                                      style: TextStyle(
                                        color: Color(0xFFED6A2E),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),

                                      // ScoreMetric — средние по группе
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ScoreMetric(
                                              label: 'ДОМАШНИЕ\nЗАДАНИЯ',
                                              score:
                                                  countHw > 0 ? avgHw : 0.0,
                                            ),
                                          ),
                                          Expanded(
                                            child: ScoreMetric(
                                              label: 'ТЕСТЫ И ЭКЗАМЕНЫ',
                                              score: countClass > 0
                                                  ? avgClass
                                                  : 0.0,
                                            ),
                                          ),
                                          Expanded(
                                            child: ScoreMetric(
                                              label: 'АКТИВНОСТЬ',
                                              score: journalState
                                                      is JournalLoaded
                                                  ? journalState.records
                                                      .where((r) =>
                                                          r.attendance ==
                                                          'present')
                                                      .length
                                                      .toDouble()
                                                  : 0.0,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),

                                      // Заголовок + индикатор загрузки
                                      Row(
                                        children: [
                                          Text(
                                            'ПОСЛЕДНИЕ ОЦЕНКИ',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey[500],
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          if (journalState
                                              is JournalLoading) ...[
                                            const SizedBox(width: 8),
                                            const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // Карточки оценок — тот же UI что был
                                      Row(
                                        children: grades
                                            .map(
                                              (g) => Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 10,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(14),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xFFF8F9FB),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        g['label'] as String,
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: g['color']
                                                              as Color,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        g['subject'] as String,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),

                                      // Текст ошибки если что-то пошло не так
                                      if (journalState is JournalError) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          'Не удалось загрузить оценки',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.red[300],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ── Правая колонка — История из API ──
                      SizedBox(
                        width: 300,
                        child: SectionCard(
                          title: 'История активности',
                          child: BlocBuilder<HistoryCubit, HistoryState>(
                            builder: (context, state) {
                              if (state is HistoryLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (state is HistoryError) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    state.message,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }

                              if (state is HistoryLoaded) {
                                final items = state.history.results;

                                if (items.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Text(
                                      'История пуста',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    ...items.map(
                                      (h) => HistoryItem(
                                        item: {
                                          'type': h.type,
                                          'title': h.title,
                                          'description': h.description,
                                          'date': h.date,
                                          'color': _colorFromApi(h.color),
                                          'icon': _iconFromApi(h.icon),
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        child: const Text(
                                          'Показать всю историю',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}