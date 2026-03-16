import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/cubit/exam_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamDialog extends StatefulWidget {
  final List<String> teachers;
  final List<String> groups;

  const AddExamDialog({
    super.key,
    required this.groups,
    required this.teachers,
  });

  @override
  State<AddExamDialog> createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  final titleController = TextEditingController();
  final passScoreController = TextEditingController(text: '0');

  String? selectedGroup;
  String? selectedTeacher;
  DateTime? examDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isPercentage = false;
  bool isActive = true;

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

              // Название
              _buildField(titleController, 'Название экзамена'),

              // Группа + Преподаватель
              Row(
                children: [
                  Expanded(child: _buildGroupDropdown()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTeacherDropdown()),
                ],
              ),

              // Дата + Проходной балл
              Row(
                children: [
                  Expanded(child: _buildDatePicker()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField(passScoreController, 'Проходной балл')),
                ],
              ),

              // Начало + Конец
              Row(
                children: [
                  Expanded(child: _buildTimePicker('Начало', startTime, (t) => setState(() => startTime = t))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTimePicker('Конец', endTime, (t) => setState(() => endTime = t))),
                ],
              ),

              // Переключатели
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('В процентах', style: TextStyle(fontSize: 14)),
                      value: isPercentage,
                      onChanged: (v) => setState(() => isPercentage = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('Активен', style: TextStyle(fontSize: 14)),
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

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: label.contains('балл') ? TextInputType.number : TextInputType.text,
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

  Widget _buildGroupDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedGroup,
        items: widget.groups
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: (v) => setState(() => selectedGroup = v),
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
  }

  Widget _buildTeacherDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedTeacher,
        items: widget.teachers
            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
            .toList(),
        onChanged: (v) => setState(() => selectedTeacher = v),
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
  }

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
                    color: examDate == null ? Colors.grey[500] : Colors.black87,
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

  Widget _buildTimePicker(String label, TimeOfDay? time, ValueChanged<TimeOfDay> onPicked) {
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

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

  void _save() async {
    if (titleController.text.isEmpty ||
        selectedGroup == null ||
        selectedTeacher == null ||
        examDate == null ||
        startTime == null ||
        endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все обязательные поля')),
      );
      return;
    }

    final groupIndex = widget.groups.indexOf(selectedGroup!) + 1;
    final dateStr =
        '${examDate!.year}-${examDate!.month.toString().padLeft(2, '0')}-${examDate!.day.toString().padLeft(2, '0')}';

    try {
      await context.read<ExamCubit>().addExam(
        title: titleController.text,
        teacher: selectedTeacher!,
        group: groupIndex,
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