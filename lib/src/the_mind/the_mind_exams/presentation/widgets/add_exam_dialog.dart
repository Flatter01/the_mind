import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/cubit/exam_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_state.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_cubit.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_state.dart';

class AddExamDialog extends StatefulWidget {
  const AddExamDialog({super.key});

  @override
  State<AddExamDialog> createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  final titleController = TextEditingController();
  final passScoreController = TextEditingController(text: '0');

  // Храним выбранные значения как ID
  int? selectedGroupId;       // GroupModel.id (int)
  String? selectedTeacherId;  // TeacherModel.id (UUID String)

  // Для отображения в дропдауне
  String? selectedGroupName;
  String? selectedTeacherName;

  DateTime? examDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isPercentage = false;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().getGroups();
  }

  @override
  void dispose() {
    titleController.dispose();
    passScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 560,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Создать экзамен',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 24),

              _buildField(titleController, 'Название экзамена'),

              Row(
                children: [
                  Expanded(child: _buildGroupDropdown()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTeacherDropdown()),
                ],
              ),

              Row(
                children: [
                  Expanded(child: _buildDatePicker()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildField(passScoreController, 'Проходной балл'),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      'Начало',
                      startTime,
                      (t) => setState(() => startTime = t),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimePicker(
                      'Конец',
                      endTime,
                      (t) => setState(() => endTime = t),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: const Text(
                        'В процентах',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: isPercentage,
                      onChanged: (v) => setState(() => isPercentage = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      title: const Text(
                        'Активен',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: isActive,
                      onChanged: (v) => setState(() => isActive = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Поле ввода ────────────────────────────────────────────────────────────

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: label.contains('балл')
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ─── Dropdown групп — данные из GroupCubit ─────────────────────────────────

  Widget _buildGroupDropdown() {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        final groups = state is GroupLoaded ? state.groups : [];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<int>(
            value: selectedGroupId,
            hint: state is GroupLoading
                ? const Text('Загрузка...')
                : const Text('Группа'),
            items: groups
                .where((g) => g.id != null && g.name != null)
                .map(
                  (g) => DropdownMenuItem<int>(
                    value: g.id,               // ✅ int ID
                    child: Text(g.name ?? ''),
                  ),
                )
                .toList(),
            onChanged: (id) {
              if (id == null) return;
              final group = groups.firstWhere((g) => g.id == id);
              setState(() {
                selectedGroupId = id;
                selectedGroupName = group.name;
              });
            },
            decoration: InputDecoration(
              labelText: 'Группа',
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Dropdown учителей — данные из TeacherCubit ────────────────────────────

  Widget _buildTeacherDropdown() {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        final teachers = state is TeacherLoaded ? state.teachers : [];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DropdownButtonFormField<String>(
            value: selectedTeacherId,
            hint: state is TeacherLoading
                ? const Text('Загрузка...')
                : const Text('Преподаватель'),
            items: teachers
                .where((t) => t.id.isNotEmpty && t.fullName.isNotEmpty)
                .map(
                  (t) => DropdownMenuItem<String>(
                    value: t.id,               // ✅ UUID String
                    child: Text(t.fullName),
                  ),
                )
                .toList(),
            onChanged: (id) {
              if (id == null) return;
              final teacher = teachers.firstWhere((t) => t.id == id);
              setState(() {
                selectedTeacherId = id;
                selectedTeacherName = teacher.fullName;
              });
            },
            decoration: InputDecoration(
              labelText: 'Преподаватель',
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Date picker ───────────────────────────────────────────────────────────

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _pickDate,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  examDate == null
                      ? 'Дата экзамена'
                      : '${examDate!.year}-${examDate!.month.toString().padLeft(2, '0')}-${examDate!.day.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        examDate == null ? Colors.grey[500] : Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.calendar_today_outlined, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Time picker ───────────────────────────────────────────────────────────

  Widget _buildTimePicker(
    String label,
    TimeOfDay? time,
    ValueChanged<TimeOfDay> onPicked,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: time ?? TimeOfDay.now(),
          );
          if (picked != null) onPicked(picked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  time == null
                      ? label
                      : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 14,
                    color: time == null ? Colors.grey[500] : Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.access_time_outlined, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Кнопки ────────────────────────────────────────────────────────────────

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            backgroundColor: const Color(0xFFED6A2E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  // ─── Вспомогательные ───────────────────────────────────────────────────────

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: examDate ?? now,
    );
    if (picked != null) setState(() => examDate = picked);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  // ─── Сохранение ────────────────────────────────────────────────────────────

  void _save() async {
    if (titleController.text.isEmpty ||
        selectedGroupId == null ||
        selectedTeacherId == null ||
        examDate == null ||
        startTime == null ||
        endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все обязательные поля')),
      );
      return;
    }

    final dateStr =
        '${examDate!.year}-${examDate!.month.toString().padLeft(2, '0')}-${examDate!.day.toString().padLeft(2, '0')}';

    try {
      await context.read<ExamCubit>().addExam(
            title: titleController.text,
            teacher: selectedTeacherId!,   // ✅ UUID String
            group: selectedGroupId!,       // ✅ int
            examDate: dateStr,
            startTime: _formatTime(startTime!),
            endTime: _formatTime(endTime!),
            passScore: int.tryParse(passScoreController.text) ?? 0,
            isPercentage: isPercentage,
            isActive: isActive,
            createdBy: '',
          );

      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }
}