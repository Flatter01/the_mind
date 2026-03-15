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
  final _groupName     = TextEditingController();
  final _studentLimit  = TextEditingController();
  final _studentPrice  = TextEditingController();
  final _teacherRate   = TextEditingController(text: '0');
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl   = TextEditingController();
  final _roomCtrl      = TextEditingController(text: '0');

  String? _selectedLevel;
  String? _selectedTeacherId;   // UUID — API'га юборилади
  TeacherRateType _rateType = TeacherRateType.fixed;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isActive = true;

  final Map<String, String> _levels = const {
    'beginner':     'Начинающий (Beginner)',
    'elementary':   'Элементарный (Elementary)',
    'intermediate': 'Средний (Intermediate)',
    'upper':        'Выше среднего (Upper)',
    'advanced':     'Продвинутый (Advanced)',
  };

  @override
  void initState() {
    super.initState();
    // Ўқитувчилар рўйхатини юклаймиз
    context.read<TeacherCubit>().getTeachers();
  }

  @override
  void dispose() {
    _groupName.dispose();
    _studentLimit.dispose();
    _studentPrice.dispose();
    _teacherRate.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:00';

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

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
    if (_startDateCtrl.text.isEmpty || _endDateCtrl.text.isEmpty) {
      _showError(context, 'Укажите даты начала и окончания');
      return;
    }

    await context.read<GroupCubit>().createGroup(
      name: _groupName.text.trim(),
      level: _selectedLevel!,
      teacher: _selectedTeacherId!,  // UUID
      room: int.tryParse(_roomCtrl.text) ?? 0,
      price: _studentPrice.text.trim(),
      startDate: _startDateCtrl.text,
      endDate: _endDateCtrl.text,
      startTime: _fmt(_startTime!),
      endTime: _fmt(_endTime!),
      isActive: _isActive,
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
                      // Название группы
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
                      // ← TEACHER DROPDOWN
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
                                child: _timeField(context,
                                    time: _startTime,
                                    onPick: (t) =>
                                        setState(() => _startTime = t)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text('—',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[400])),
                              ),
                              Expanded(
                                child: _timeField(context,
                                    time: _endTime,
                                    onPick: (t) =>
                                        setState(() => _endTime = t)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labeledField(
                          label: 'Даты начала — окончания *',
                          child: Row(
                            children: [
                              Expanded(
                                child: _dateField(
                                    controller: _startDateCtrl,
                                    hint: 'Начало'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text('—',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[400])),
                              ),
                              Expanded(
                                child: _dateField(
                                    controller: _endDateCtrl,
                                    hint: 'Конец'),
                              ),
                            ],
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
                          label: 'Цена (сум/месяц)',
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
                                      color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    _rateToggleBtn('Фикса', TeacherRateType.fixed),
                                    _rateToggleBtn('Процент (%)', TeacherRateType.percent),
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
                                      color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _teacherRate,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.symmetric(horizontal: 14),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        _rateType == TeacherRateType.percent
                                            ? '%'
                                            : 'сум',
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w600),
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
                                  color: Colors.grey.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Отмена',
                                style: TextStyle(color: Colors.black87)),
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
                                  horizontal: 32, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: state is GroupLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('Создать группу',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
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

  // ── TEACHER DROPDOWN ─────────────────────────────────────────────────────
  Widget _teacherDropdown() {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        // Юкланаётган пайт
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
                width: 20, height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFED6A2E),
                ),
              ),
            ),
          );
        }

        // Хатолик бўлса
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
                  Text('Ошибка. Нажмите для повтора',
                      style: TextStyle(fontSize: 13, color: Colors.red[400])),
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
                teachers.isEmpty
                    ? 'Учителя не найдены'
                    : 'Выберите учителя',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
              isExpanded: true,
              items: teachers.map((t) {
                final name = t.fullName ?? t.username ?? '—';
                final initials = name.trim().isNotEmpty
                    ? name.trim().split(' ').map((p) => p[0]).take(2).join()
                    : '?';

                return DropdownMenuItem<String>(
                  value: t.id,  // ← UUID API'га юборилади
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
                              name,  // ← Исм-фамилия кўрсатилади
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
              onChanged: (uuid) => setState(() => _selectedTeacherId = uuid),
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Text(title,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A2233)));

  Widget _labeledField({required String label, required Widget child}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600])),
        const SizedBox(height: 8),
        child,
      ]);

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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
            hint: Text(hint,
                style: TextStyle(fontSize: 14, color: Colors.grey[400])),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
            isExpanded: true,
            items: items.entries
                .map((e) => DropdownMenuItem(
                    value: e.key,
                    child:
                        Text(e.value, style: const TextStyle(fontSize: 14))))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      );

  Widget _timeField(BuildContext context,
          {required TimeOfDay? time, required ValueChanged<TimeOfDay> onPick}) =>
      GestureDetector(
        onTap: () async {
          final t = await showTimePicker(
              context: context, initialTime: TimeOfDay.now());
          if (t != null) onPick(t);
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(children: [
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                time != null ? _fmt(time) : '--:--',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: time != null ? const Color(0xFF1A2233) : Colors.grey[400],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.access_time, size: 18, color: Colors.grey[400]),
            ),
          ]),
        ),
      );

  Widget _dateField({
    required TextEditingController controller,
    required String hint,
  }) =>
      GestureDetector(
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (picked != null) controller.text = _fmtDate(picked);
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) => Row(children: [
              const SizedBox(width: 12),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value.text.isEmpty ? hint : value.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: value.text.isEmpty
                        ? Colors.grey[400]
                        : const Color(0xFF1A2233),
                  ),
                ),
              ),
            ]),
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
                  ? [BoxShadow(
                      color: Colors.black.withOpacity(0.06), blurRadius: 6)]
                  : [],
            ),
            child: Center(
              child: Text(label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _rateType == type
                        ? const Color(0xFF1A2233)
                        : Colors.grey[500],
                  )),
            ),
          ),
        ),
      );
}