import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_state.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/history/history_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/journal/journal_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/journal/journal_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
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
  int _discountAmount = 0;
  bool _editingDiscount = false;
  late TextEditingController _discountCtrl;

  static const _orange = Color(0xFFED6A2E);

  final List<Map<String, dynamic>> payments = const [
    {
      'date': '12.10.2023',
      'purpose': 'Оплата обучения (Октябрь)',
      'amount': '8 500 Сум',
      'status': 'Успешно',
    },
    {
      'date': '15.09.2023',
      'purpose': 'Учебные материалы',
      'amount': '1 200 Сум',
      'status': 'Успешно',
    },
  ];

  @override
  void initState() {
    super.initState();
    _discountCtrl = TextEditingController(text: _discountAmount.toString());
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
    final raw =
        widget.student.balance.replaceAll(RegExp(r'[^0-9\-]'), '');
    return int.tryParse(raw) ?? 0;
  }

  int get _debtAmount => _rawBalance < 0 ? _rawBalance.abs() : 0;
  int get _debtAfterDiscount {
    final d = _debtAmount - _discountAmount;
    return d < 0 ? 0 : d;
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
        return _orange;
      case 'red':
        return Colors.redAccent;
      case 'blue':
        return const Color(0xFF6B7FD4);
      case 'green':
        return const Color(0xFF2ECC8A);
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

  Color _scoreColor(int? score) {
    if (score == null) return const Color(0xFF8A9BB8);
    if (score >= 5) return const Color(0xFF2ECC8A);
    if (score >= 4) return const Color(0xFF6B7FD4);
    if (score >= 3) return Colors.orange;
    return Colors.redAccent;
  }

  // ── Современный диалог редактирования ────────────────────────────────────

  void _openEditStudent(StudentModel student) {
    final firstNameCtrl = TextEditingController(text: student.firstName ?? '');
    final lastNameCtrl = TextEditingController(text: student.lastName ?? '');
    final phoneCtrl = TextEditingController(text: student.phone ?? '');

    String status = student.status;
    String? selectedGroupId = student.groupId;
    String? selectedGroupName = student.groupName;
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 40,
          ),
          child: SizedBox(
            width: 520,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──
                    Container(
                      padding: const EdgeInsets.fromLTRB(28, 24, 16, 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.12),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: _orange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Редактировать студента',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1F36),
                                ),
                              ),
                              Text(
                                '${student.lastName ?? ''} ${student.firstName ?? ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Body ──
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Имя + Фамилия
                            Row(
                              children: [
                                Expanded(
                                  child: _editField(
                                    controller: lastNameCtrl,
                                    label: 'Фамилия',
                                    icon: Icons.person_outline,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _editField(
                                    controller: firstNameCtrl,
                                    label: 'Имя',
                                    icon: Icons.person,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Телефон
                            _editField(
                              controller: phoneCtrl,
                              label: 'Телефон',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 14),

                            // Статус
                            _editLabel('СТАТУС'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _statusToggle(
                                  label: 'Активный',
                                  value: 'active',
                                  current: status,
                                  color: const Color(0xFF2ECC8A),
                                  onTap: () => setDialogState(
                                    () => status = 'active',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _statusToggle(
                                  label: 'Не активен',
                                  value: 'inactive',
                                  current: status,
                                  color: Colors.grey,
                                  onTap: () => setDialogState(
                                    () => status = 'inactive',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _statusToggle(
                                  label: 'Пробный',
                                  value: 'trial',
                                  current: status,
                                  color: const Color(0xFF6B7FD4),
                                  onTap: () => setDialogState(
                                    () => status = 'trial',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Группа из GroupCubit
                            _editLabel('ГРУППА'),
                            const SizedBox(height: 8),
                            BlocBuilder<GroupCubit, GroupState>(
                              builder: (context, groupState) {
                                final groups = groupState is GroupLoaded
                                    ? groupState.groups
                                    : <GroupModel>[];

                                return Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F8FA),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.18),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: groups.any(
                                        (g) =>
                                            g.id?.toString() == selectedGroupId,
                                      )
                                          ? selectedGroupId
                                          : null,
                                      hint: Text(
                                        selectedGroupName ?? 'Выберите группу',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: selectedGroupName != null
                                              ? const Color(0xFF1A1F36)
                                              : Colors.grey[400],
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[500],
                                      ),
                                      isExpanded: true,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1A1F36),
                                      ),
                                      items: groups
                                          .map(
                                            (g) => DropdownMenuItem<String>(
                                              value: g.id?.toString(),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      color: g.isActive == true
                                                          ? const Color(
                                                              0xFF2ECC8A,
                                                            )
                                                          : Colors.grey,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          g.name ?? '—',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        if (g.teacherName !=
                                                            null)
                                                          Text(
                                                            g.teacherName!,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors
                                                                  .grey[500],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) {
                                        final match = groups.firstWhere(
                                          (g) => g.id?.toString() == v,
                                          orElse: () => const GroupModel(),
                                        );
                                        setDialogState(() {
                                          selectedGroupId = v;
                                          selectedGroupName = match.name;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Footer ──
                    Container(
                      padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withOpacity(0.12),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: isSaving
                                ? null
                                : () => Navigator.pop(dialogContext),
                            child: Text(
                              'Отмена',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: isSaving
                                ? null
                                : () async {
                                    setDialogState(() => isSaving = true);
                                    try {
                                      await context
                                          .read<StudentCubit>()
                                          .repository
                                          .updateStudent(
                                            student.id.toString(),
                                            {
                                              'first_name':
                                                  firstNameCtrl.text.trim(),
                                              'last_name':
                                                  lastNameCtrl.text.trim(),
                                              'phone': phoneCtrl.text.trim(),
                                              'status': status,
                                            },
                                          );

                                      if (!dialogContext.mounted) return;
                                      Navigator.pop(dialogContext);

                                      // Обновляем список
                                      if (context.mounted) {
                                        context
                                            .read<StudentCubit>()
                                            .getStudents();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('✅ Данные обновлены'),
                                            backgroundColor:
                                                Color(0xFF2ECC8A),
                                            behavior:
                                                SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      setDialogState(() => isSaving = false);
                                      if (dialogContext.mounted) {
                                        ScaffoldMessenger.of(dialogContext)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                            backgroundColor: Colors.redAccent,
                                            behavior:
                                                SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: isSaving
                                    ? _orange.withOpacity(0.6)
                                    : _orange,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _orange.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: isSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Сохранить',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ── Helpers для диалога ───────────────────────────────────────────────────

  Widget _editField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1F36)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _editLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.grey[500],
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _statusToggle({
    required String label,
    required String value,
    required String current,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isActive = current == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.1) : const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? color : Colors.grey.withOpacity(0.18),
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? color : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? color : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
                                          valueColor: _orange,
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
                                          color: _orange,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Долг: $_debtAfterDiscountDisplay',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _orange,
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
                                              ? _orange
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
                                                          color: _orange,
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
                                                      () => _editingDiscount =
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
                                                        color: _orange
                                                            .withOpacity(0.08),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        border: Border.all(
                                                          color: _orange
                                                              .withOpacity(0.3),
                                                        ),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 11,
                                                            color: _orange,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            'изменить',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: _orange,
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
                                              ? _orange
                                              : const Color(0xFF2ECC8A),
                                          valueBold: true,
                                          valueFontSize: 22,
                                        ),
                                      ),
                                    ],
                                  ),

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

                            // ── Академические успехи ──
                            BlocBuilder<JournalCubit, JournalState>(
                              builder: (context, journalState) {
                                final record = journalState is JournalLoaded
                                    ? journalState.records
                                        .where((r) => r.studentId == s.id)
                                        .firstOrNull
                                    : null;

                                double avgHw = 0, avgClass = 0;
                                int countHw = 0, countClass = 0;
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

                                final grades = record != null
                                    ? <Map<String, dynamic>>[
                                        {
                                          'label':
                                              record.classScore?.toString() ??
                                                  '—',
                                          'subject': 'Оценка за урок',
                                          'color':
                                              _scoreColor(record.classScore),
                                        },
                                        {
                                          'label':
                                              record.homeworkScore?.toString() ??
                                                  '—',
                                          'subject': 'Домашнее задание',
                                          'color': _scoreColor(
                                              record.homeworkScore),
                                        },
                                        {
                                          'label':
                                              record.attendance == 'present'
                                                  ? '✓'
                                                  : '✗',
                                          'subject': 'Посещаемость',
                                          'color': record.attendance ==
                                                  'present'
                                              ? const Color(0xFF2ECC8A)
                                              : Colors.redAccent,
                                        },
                                      ]
                                    : <Map<String, dynamic>>[
                                        {
                                          'label': '—',
                                          'subject': 'Оценка за урок',
                                          'color': const Color(0xFF8A9BB8),
                                        },
                                        {
                                          'label': '—',
                                          'subject': 'Домашнее задание',
                                          'color': const Color(0xFF8A9BB8),
                                        },
                                        {
                                          'label': '—',
                                          'subject': 'Посещаемость',
                                          'color': const Color(0xFF8A9BB8),
                                        },
                                      ];

                                return SectionCard(
                                  title: 'Академические успехи',
                                  trailing: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Детальный отчет',
                                      style: TextStyle(
                                        color: _orange,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ScoreMetric(
                                              label: 'ДОМАШНИЕ\nЗАДАНИЯ',
                                              score: countHw > 0 ? avgHw : 0,
                                            ),
                                          ),
                                          Expanded(
                                            child: ScoreMetric(
                                              label: 'ТЕСТЫ И ЭКЗАМЕНЫ',
                                              score: countClass > 0
                                                  ? avgClass
                                                  : 0,
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
                                                  : 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
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
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ── Правая колонка — История ──
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
                                            color: Colors.grey.withOpacity(
                                              0.3,
                                            ),
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