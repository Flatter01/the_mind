import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_state.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/model/teacher_model.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_cubit.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_state.dart';

enum TeacherRateType { fixed, percent }

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _groupName = TextEditingController();
  final _studentPrice = TextEditingController();
  final _teacherRate = TextEditingController(text: '0');
  final _roomCtrl = TextEditingController(text: '0');

  String? _selectedLevel;
  String? _selectedTeacherId;
  TeacherRateType _rateType = TeacherRateType.fixed;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isActive = true;

  // ✅ Обязательные даты
  DateTime? _startDate;
  DateTime? _endDate;

  final Set<int> _selectedDays = {};

  static const _dayLabels = {
    1: 'Пн',
    2: 'Вт',
    3: 'Ср',
    4: 'Чт',
    5: 'Пт',
    6: 'Сб',
    7: 'Вс',
  };

  void _selectOdd() => setState(() {
        _selectedDays.clear();
        _selectedDays.addAll([1, 3, 5]);
      });

  void _selectEven() => setState(() {
        _selectedDays.clear();
        _selectedDays.addAll([2, 4, 6]);
      });

  void _selectAll() => setState(() {
        _selectedDays.addAll([1, 2, 3, 4, 5, 6, 7]);
      });

  void _clearDays() => setState(() => _selectedDays.clear());

  List<int> get _weekDaysList {
    final sorted = _selectedDays.toList()..sort();
    return sorted;
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  final Map<String, String> _levels = const {
    'beginner': 'Начинающий (Beginner)',
    'elementary': 'Элементарный (Elementary)',
    'intermediate': 'Средний (Intermediate)',
    'upper': 'Выше среднего (Upper)',
    'advanced': 'Продвинутый (Advanced)',
  };

  @override
  void initState() {
    super.initState();
    context.read<TeacherCubit>().getTeachers();
    // Ставим дату по умолчанию — сегодня
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _groupName.dispose();
    _studentPrice.dispose();
    _teacherRate.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _submit(BuildContext context) async {
    if (_groupName.text.trim().isEmpty) {
      _showError(context, 'Название группы обязательно');
      return;
    }
    if (_selectedTeacherId == null) {
      _showError(context, 'Выберите учителя');
      return;
    }
    if (_selectedLevel == null) {
      _showError(context, 'Выберите уровень');
      return;
    }
    if (_startTime == null || _endTime == null) {
      _showError(context, 'Укажите время занятий');
      return;
    }
    if (_selectedDays.isEmpty) {
      _showError(context, 'Выберите дни недели');
      return;
    }
    if (_startDate == null) {
      _showError(context, 'Укажите дату начала');
      return;
    }

    // ✅ Валидация цены — максимум 8 цифр до запятой
    final priceText = _studentPrice.text.trim();
    if (priceText.isNotEmpty) {
      final priceVal = double.tryParse(priceText) ?? 0;
      if (priceVal >= 100000000) {
        _showError(context, 'Цена слишком большая (макс. 99 999 999)');
        return;
      }
    }

    await context.read<GroupCubit>().createGroup(
          name: _groupName.text.trim(),
          level: _selectedLevel!,
          teacher: _selectedTeacherId!,
          room: int.tryParse(_roomCtrl.text) ?? 0,
          price: priceText.isEmpty ? '0' : priceText,
          weekDays: _weekDaysList,
          startTime: _fmt(_startTime!),
          endTime: _fmt(_endTime!),
          isActive: _isActive,
          startDate: _fmtDate(_startDate!),         // ✅ обязательное
          endDate: _endDate != null ? _fmtDate(_endDate!) : '',
        );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: BlocListener<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state is GroupLoaded) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Группа успешно создана!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is GroupError) {
            _showError(context, state.message);
          }
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Создать группу',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Основная информация ──
                  _sectionTitle('Основная информация'),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _labeledField(
                          label: 'Название группы *',
                          child: _inputField(
                            controller: _groupName,
                            hint: 'Например: Junior-1',
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labeledField(
                          label: 'Учитель *',
                          child: _teacherDropdown(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _labeledField(
                          label: 'Уровень сложности *',
                          child: _dropdownField(
                            hint: 'Выберите уровень',
                            value: _selectedLevel,
                            items: _levels,
                            onChanged: (v) =>
                                setState(() => _selectedLevel = v),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labeledField(
                          label: 'Кабинет (номер)',
                          child: _inputField(
                            controller: _roomCtrl,
                            hint: '0',
                            isNumber: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Расписание ──
                  _sectionTitle('Расписание'),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _labeledField(
                          label: 'Время занятий *',
                          child: Row(
                            children: [
                              Expanded(
                                child: _timeField(
                                  context,
                                  time: _startTime,
                                  onPick: (t) =>
                                      setState(() => _startTime = t),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  '—',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _timeField(
                                  context,
                                  time: _endTime,
                                  onPick: (t) =>
                                      setState(() => _endTime = t),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labeledField(
                          label: 'Дни занятий *',
                          child: _weekDaySelector(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ✅ Даты начала и конца
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _labeledField(
                          label: 'Дата начала *',
                          child: _datePicker(
                            date: _startDate,
                            hint: 'Выберите дату',
                            onPick: (d) => setState(() => _startDate = d),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labeledField(
                          label: 'Дата окончания',
                          child: _datePicker(
                            date: _endDate,
                            hint: 'Необязательно',
                            onPick: (d) => setState(() => _endDate = d),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Финансы ──
                  _sectionTitle('Финансы и оплата'),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _labeledField(
                          // ✅ Подсказка о максимальной цене
                          label: 'Цена (сум/месяц, макс. 99 999 999)',
                          child: _inputField(
                            controller: _studentPrice,
                            hint: '500000',
                            isNumber: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labeledField(
                          label: 'Оплата учителю',
                          child: Column(
                            children: [
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _rateToggleBtn(
                                      'Фикса',
                                      TeacherRateType.fixed,
                                    ),
                                    _rateToggleBtn(
                                      'Процент (%)',
                                      TeacherRateType.percent,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _teacherRate,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        _rateType == TeacherRateType.percent
                                            ? '%'
                                            : 'сум',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Switch(
                        value: _isActive,
                        activeColor: const Color(0xFFED6A2E),
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isActive ? 'Группа активна' : 'Группа неактивна',
                        style: TextStyle(
                          color: _isActive
                              ? const Color(0xFFED6A2E)
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Кнопки ──
                  BlocBuilder<GroupCubit, GroupState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: state is GroupLoading
                                ? null
                                : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Отмена',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: state is GroupLoading
                                ? null
                                : () => _submit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFED6A2E),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is GroupLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Создать группу',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Дата-пикер ────────────────────────────────────────────────────────────

  Widget _datePicker({
    required DateTime? date,
    required String hint,
    required ValueChanged<DateTime> onPick,
  }) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFED6A2E),
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: date != null
              ? const Color(0xFFFFF3EE)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: date != null
                ? const Color(0xFFED6A2E).withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: date != null
                  ? const Color(0xFFED6A2E)
                  : Colors.grey[400],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                date != null ? _fmtDate(date) : hint,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: date != null
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: date != null
                      ? const Color(0xFF1A2233)
                      : Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ВЫБОР ДНЕЙ НЕДЕЛИ ─────────────────────────────────────────────────────

  Widget _weekDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _quickBtn(
              'Нечётные',
              onTap: _selectOdd,
              active: _selectedDays.containsAll([1, 3, 5]) &&
                  !_selectedDays.contains(2),
            ),
            const SizedBox(width: 8),
            _quickBtn(
              'Чётные',
              onTap: _selectEven,
              active: _selectedDays.containsAll([2, 4, 6]) &&
                  !_selectedDays.contains(1),
            ),
            const SizedBox(width: 8),
            _quickBtn(
              'Все',
              onTap: _selectAll,
              active: _selectedDays.length == 7,
            ),
            const Spacer(),
            if (_selectedDays.isNotEmpty)
              GestureDetector(
                onTap: _clearDays,
                child: Text(
                  'Сбросить',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: _dayLabels.entries.map((entry) {
            final isSelected = _selectedDays.contains(entry.key);
            final isWeekend = entry.key >= 6;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  if (isSelected) {
                    _selectedDays.remove(entry.key);
                  } else {
                    _selectedDays.add(entry.key);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 4),
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFED6A2E)
                        : isWeekend
                            ? const Color(0xFFFFF3EE)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFED6A2E)
                          : isWeekend
                              ? const Color(0xFFED6A2E).withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : isWeekend
                                ? const Color(0xFFED6A2E)
                                : const Color(0xFF1A2233),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedDays.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _buildDaysHint(),
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ],
    );
  }

  Widget _quickBtn(
    String label, {
    required VoidCallback onTap,
    required bool active,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFED6A2E).withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? const Color(0xFFED6A2E).withOpacity(0.4)
                : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xFFED6A2E) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  String _buildDaysHint() {
    final sorted = _selectedDays.toList()..sort();
    final names = sorted.map((d) => _dayLabels[d]!).join(', ');
    return 'Выбрано: $names';
  }

  // ── TEACHER DROPDOWN ──────────────────────────────────────────────────────

  Widget _teacherDropdown() {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        if (state is TeacherLoading) {
          return Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFED6A2E),
                ),
              ),
            ),
          );
        }
        if (state is TeacherError) {
          return GestureDetector(
            onTap: () => context.read<TeacherCubit>().getTeachers(),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: Colors.red[400]),
                  const SizedBox(width: 8),
                  Text(
                    'Ошибка. Нажмите для повтора',
                    style: TextStyle(fontSize: 13, color: Colors.red[400]),
                  ),
                  const Spacer(),
                  Icon(Icons.refresh, size: 16, color: Colors.red[400]),
                ],
              ),
            ),
          );
        }

        final teachers = state is TeacherLoaded
            ? state.teachers.where((t) => t.isActive == true).toList()
            : <TeacherModel>[];

        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTeacherId,
              hint: Text(
                teachers.isEmpty ? 'Учителя не найдены' : 'Выберите учителя',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[500],
              ),
              isExpanded: true,
              items: teachers.map((t) {
                final name = t.fullName ?? t.username ?? '—';
                final initials = name.trim().isNotEmpty
                    ? name
                        .trim()
                        .split(' ')
                        .map((p) => p.isNotEmpty ? p[0] : '')
                        .take(2)
                        .join()
                    : '?';
                return DropdownMenuItem<String>(
                  value: t.id,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            const Color(0xFFED6A2E).withOpacity(0.12),
                        child: Text(
                          initials.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFED6A2E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (t.experienceYear != null)
                              Text(
                                'Опыт: ${t.experienceYear} лет',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (uuid) =>
                  setState(() => _selectedTeacherId = uuid),
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A2233),
        ),
      );

  Widget _labeledField({
    required String label,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool isNumber = false,
  }) =>
      Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters:
              isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
          ),
        ),
      );

  Widget _dropdownField({
    required String hint,
    required String? value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: items.containsKey(value) ? value : null,
            hint: Text(
              hint,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
            isExpanded: true,
            items: items.entries
                .map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(
                      e.value,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      );

  Widget _timeField(
    BuildContext context, {
    required TimeOfDay? time,
    required ValueChanged<TimeOfDay> onPick,
  }) =>
      GestureDetector(
        onTap: () async {
          final t = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (t != null) onPick(t);
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  time != null ? _fmt(time) : '--:--',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: time != null
                        ? const Color(0xFF1A2233)
                        : Colors.grey[400],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.access_time,
                  size: 18,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _rateToggleBtn(String label, TeacherRateType type) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _rateType = type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _rateType == type ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              boxShadow: _rateType == type
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _rateType == type
                      ? const Color(0xFF1A2233)
                      : Colors.grey[500],
                ),
              ),
            ),
          ),
        ),
      );
}