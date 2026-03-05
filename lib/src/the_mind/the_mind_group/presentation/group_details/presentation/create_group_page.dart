import 'package:flutter/material.dart';

enum TeacherRateType { fixed, percent }

enum WeekType { even, odd }

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final groupName = TextEditingController();
  final studentLimit = TextEditingController();
  final studentPrice = TextEditingController();
  final teacherRate = TextEditingController();

  String? selectedTeacher;
  String? selectedTariff;
  String? selectedLevel;

  TeacherRateType rateType = TeacherRateType.fixed;
  WeekType weekType = WeekType.even;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final teachers = ['Ali', 'Bekzod', 'Sardor'];
  final tariff = ['Individual', 'Group', 'VIP'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Создание группы',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _field('Название группы', groupName),
                _field('Лимит учеников', studentLimit, isNumber: true),

                /// УЧИТЕЛЬ
                DropdownButtonFormField<String>(
                  value: selectedTeacher,
                  decoration: const InputDecoration(
                    labelText: 'Учитель',
                    border: OutlineInputBorder(),
                  ),
                  items: teachers
                      .map(
                        (t) =>
                            DropdownMenuItem<String>(value: t, child: Text(t)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedTeacher = v),
                ),

                const SizedBox(height: 16),

                /// ВРЕМЯ
                Row(
                  children: [
                    Expanded(
                      child: _timeButton(
                        context,
                        title: 'Начало урока',
                        time: startTime,
                        onPick: (t) => setState(() => startTime = t),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _timeButton(
                        context,
                        title: 'Конец урока',
                        time: endTime,
                        onPick: (t) => setState(() => endTime = t),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ТИП НЕДЕЛИ
                const Text(
                  'Занятия проходят:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                RadioListTile(
                  title: const Text('В чётную неделю'),
                  value: WeekType.even,
                  groupValue: weekType,
                  onChanged: (v) => setState(() => weekType = v!),
                ),
                RadioListTile(
                  title: const Text('В нечётную неделю'),
                  value: WeekType.odd,
                  groupValue: weekType,
                  onChanged: (v) => setState(() => weekType = v!),
                ),

                const Divider(height: 32),

                /// ТАРИФ
                DropdownButtonFormField<String>(
                  value: selectedTariff,
                  decoration: const InputDecoration(
                    labelText: 'Тариф',
                    border: OutlineInputBorder(),
                  ),
                  items: tariff
                      .map(
                        (t) =>
                            DropdownMenuItem<String>(value: t, child: Text(t)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedTariff = v),
                ),
                SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: selectedLevel,
                  decoration: const InputDecoration(
                    labelText: 'Уровень',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(5, (index) {
                    final level = (index + 1).toString();
                    return DropdownMenuItem(value: level, child: Text(level));
                  }),
                  onChanged: (v) => setState(() => selectedLevel = v),
                ),

                SizedBox(height: 15),
                RadioListTile(
                  title: const Text('Фиксированная ставка'),
                  value: TeacherRateType.fixed,
                  groupValue: rateType,
                  onChanged: (v) => setState(() => rateType = v!),
                ),
                RadioListTile(
                  title: const Text('Процент'),
                  value: TeacherRateType.percent,
                  groupValue: rateType,
                  onChanged: (v) => setState(() => rateType = v!),
                ),

                _field(
                  rateType == TeacherRateType.fixed
                      ? 'Фикс за одного ученика'
                      : 'Процент (%)',
                  teacherRate,
                  isNumber: true,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Создать группу'),
                      ),
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

  Widget _field(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _timeButton(
    BuildContext context, {
    required String title,
    required TimeOfDay? time,
    required Function(TimeOfDay) onPick,
  }) {
    return ElevatedButton(
      onPressed: () async {
        final t = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (t != null) onPick(t);
      },
      child: Text(time == null ? title : '$title: ${time.format(context)}'),
    );
  }
}
