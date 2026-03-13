import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/payment/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/payment/group_state.dart';

enum TeacherRateType { fixed, percent }
enum WeekType { even, odd }

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _groupName    = TextEditingController();
  final _studentLimit = TextEditingController();
  final _studentPrice = TextEditingController();
  final _teacherRate  = TextEditingController(text: '0');

  String? _selectedTeacher;
  String? _selectedLevel;
  TeacherRateType _rateType = TeacherRateType.fixed;
  WeekType _weekType = WeekType.even;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final _teachers = ['Ali', 'Bekzod', 'Sardor'];

  final _levels = const {
    'beginner':     'Начинающий (Beginner)',
    'elementary':   'Элементарный (Elementary)',
    'intermediate': 'Средний (Intermediate)',
    'upper':        'Выше среднего (Upper)',
    'advanced':     'Продвинутый (Advanced)',
  };

  final _tariffs = const {
    'standard': 'Стандартный (5000₽/мес)',
    'premium':  'Премиум (8000₽/мес)',
    'vip':      'VIP (12000₽/мес)',
  };
  String? _selectedTariff = 'standard';

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _groupName.dispose();
    _studentLimit.dispose();
    _studentPrice.dispose();
    _teacherRate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Основная информация ───────────────────────────
                _sectionTitle('Основная информация'),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _labeledField(
                        label: 'Название группы',
                        child: _inputField(
                          controller: _groupName,
                          hint: 'Например: Junior-1',
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _labeledField(
                        label: 'Лимит учеников',
                        child: _inputField(
                          controller: _studentLimit,
                          hint: 'Максимум 15',
                          isNumber: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Выбор учителя
                    Expanded(
                      child: _labeledField(
                        label: 'Выбор учителя',
                        child: _dropdownField(
                          hint: 'Выберите преподавателя',
                          value: _selectedTeacher,
                          items: {for (final t in _teachers) t: t},
                          onChanged: (v) => setState(() => _selectedTeacher = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Уровень
                    Expanded(
                      child: _labeledField(
                        label: 'Уровень сложности',
                        child: _dropdownField(
                          hint: 'Выберите уровень',
                          value: _selectedLevel,
                          items: _levels,
                          onChanged: (v) => setState(() => _selectedLevel = v),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Расписание ────────────────────────────────────
                _sectionTitle('Расписание'),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Время занятий
                    Expanded(
                      child: _labeledField(
                        label: 'Время занятий',
                        child: Row(
                          children: [
                            Expanded(child: _timeField(context, time: _startTime, onPick: (t) => setState(() => _startTime = t))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('—', style: TextStyle(fontSize: 18, color: Colors.grey[400])),
                            ),
                            Expanded(child: _timeField(context, time: _endTime, onPick: (t) => setState(() => _endTime = t))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Дни недели
                    Expanded(
                      child: _labeledField(
                        label: 'Дни недели',
                        child: Row(
                          children: [
                            Expanded(
                              child: _weekTypeBtn(
                                label: 'Четные',
                                selected: _weekType == WeekType.even,
                                isLeft: true,
                                onTap: () => setState(() => _weekType = WeekType.even),
                              ),
                            ),
                            Expanded(
                              child: _weekTypeBtn(
                                label: 'Нечетные',
                                selected: _weekType == WeekType.odd,
                                isLeft: false,
                                onTap: () => setState(() => _weekType = WeekType.odd),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Финансы и оплата ──────────────────────────────
                _sectionTitle('Финансы и оплата'),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Тариф
                    Expanded(
                      child: _labeledField(
                        label: 'Тариф обучения',
                        child: _dropdownField(
                          hint: 'Выберите тариф',
                          value: _selectedTariff,
                          items: _tariffs,
                          onChanged: (v) => setState(() => _selectedTariff = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Оплата учителю
                    Expanded(
                      child: _labeledField(
                        label: 'Оплата учителю',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Переключатель Фикса / Процент
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FB),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _rateType = TeacherRateType.fixed),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: _rateType == TeacherRateType.fixed ? Colors.white : Colors.transparent,
                                          borderRadius: BorderRadius.circular(9),
                                          boxShadow: _rateType == TeacherRateType.fixed
                                              ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)]
                                              : [],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Фикса',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: _rateType == TeacherRateType.fixed
                                                  ? const Color(0xFF1A2233)
                                                  : Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _rateType = TeacherRateType.percent),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: _rateType == TeacherRateType.percent ? Colors.white : Colors.transparent,
                                          borderRadius: BorderRadius.circular(9),
                                          boxShadow: _rateType == TeacherRateType.percent
                                              ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)]
                                              : [],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Процент (%)',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: _rateType == TeacherRateType.percent
                                                  ? const Color(0xFF1A2233)
                                                  : Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Поле ввода ставки
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: _teacherRate,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      _rateType == TeacherRateType.percent ? '%' : '₽',
                                      style: TextStyle(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.15),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        _rateType == TeacherRateType.percent
                                            ? 'Расчет от прибыли группы'
                                            : 'Фикс за одного ученика',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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

                const SizedBox(height: 36),

                // ── Кнопки ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Отмена', style: TextStyle(fontSize: 14, color: Colors.black87)),
                    ),
                    const SizedBox(width: 12),
                    BlocConsumer<GroupCubit, GroupState>(
                      listener: (context, state) {
                        if (state is GroupLoaded) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Группа успешно создана'), backgroundColor: Colors.green),
                          );
                        } else if (state is GroupError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is GroupLoading
                              ? null
                              : () async {
                                  if (_startTime == null || _endTime == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Укажите время занятий'), backgroundColor: Colors.red),
                                    );
                                    return;
                                  }
                                  await context.read<GroupCubit>().createGroup(
                                    name: _groupName.text,
                                    level: _selectedLevel ?? '',
                                    teacher: _selectedTeacher ?? '',
                                    room: 0,
                                    price: _studentPrice.text,
                                    startDate: '2026-03-08',
                                    endDate: '2026-06-08',
                                    startTime: _fmt(_startTime!),
                                    endTime: _fmt(_endTime!),
                                    isActive: true,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED6A2E),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: state is GroupLoading
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Создать группу', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Заголовок секции ──────────────────────────────────────────────────────
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2233)),
    );
  }

  // ── Лейбл + поле ─────────────────────────────────────────────────────────
  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[600])),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  // ── Текстовое поле ────────────────────────────────────────────────────────
  Widget _inputField({required TextEditingController controller, required String hint, bool isNumber = false}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      ),
    );
  }

  // ── Dropdown ──────────────────────────────────────────────────────────────
  Widget _dropdownField({
    required String hint,
    required String? value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) {
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
          value: items.containsKey(value) ? value : null,
          hint: Text(hint, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
          isExpanded: true,
          items: items.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 14))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── Поле времени ──────────────────────────────────────────────────────────
  Widget _timeField(BuildContext context, {required TimeOfDay? time, required ValueChanged<TimeOfDay> onPick}) {
    return GestureDetector(
      onTap: () async {
        final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
                  color: time != null ? const Color(0xFF1A2233) : Colors.grey[400],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.access_time, size: 18, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  // ── Кнопка чётные/нечётные ────────────────────────────────────────────────
  Widget _weekTypeBtn({
    required String label,
    required bool selected,
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFED6A2E).withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(12) : Radius.zero,
            right: !isLeft ? const Radius.circular(12) : Radius.zero,
          ),
          border: Border.all(
            color: selected ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xFFED6A2E) : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}