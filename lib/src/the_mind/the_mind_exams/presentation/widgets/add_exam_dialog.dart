import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/datasources/exam_api_service.dart';
import '../the_mind_exams_page.dart';

class AddExamDialog extends StatefulWidget {
  final Function(ExamItem) onAdd;
  final List<String> teachers;
  final List<String> groups;

  const AddExamDialog({
    super.key,
    required this.onAdd,
    required this.groups,
    required this.teachers,
  });

  @override
  State<AddExamDialog> createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  final title = TextEditingController();
  final direction = TextEditingController();

  String? selectedGroup;
  String? selectedTeacher;

  DateTime? date;

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
              _header(),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(child: _field(title, "Exam name")),
                  const SizedBox(width: 16),
                  Expanded(child: _groupDropdown()),
                ],
              ),

              _teacherDropdown(),

              _field(direction, "Direction"),

              const SizedBox(height: 8),

              _datePicker(),

              const SizedBox(height: 28),

              _actions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Text(
      "Add exam",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
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

  /// GROUP
  Widget _groupDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedGroup,
        items: widget.groups
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedGroup = value;
          });
        },
        decoration: InputDecoration(
          labelText: "Group",
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

  /// TEACHER
  Widget _teacherDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedTeacher,
        items: widget.teachers
            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedTeacher = value;
          });
        },
        decoration: InputDecoration(
          labelText: "Teacher",
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

  Widget _datePicker() {
    return InkWell(
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
                date == null
                    ? "Select exam date"
                    : "${date!.day}.${date!.month}.${date!.year}",
              ),
            ),
            const Icon(Icons.calendar_today_outlined),
          ],
        ),
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Save"),
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
      initialDate: date ?? now,
    );

    if (picked != null) {
      setState(() => date = picked);
    }
  }

  void _save() async {
    if (title.text.isEmpty ||
        selectedGroup == null ||
        selectedTeacher == null ||
        direction.text.isEmpty ||
        date == null)
      return;

    // Формируем тело POST-запроса
    final Map<String, dynamic> data = {
      "title": title.text,
      "group": widget.groups.indexOf(
        selectedGroup!,
      ), // или айди группы, если есть
      "exam_date": date!.toIso8601String().split('T')[0], // YYYY-MM-DD
      "start_time": DateTime.now()
          .toIso8601String(), // можно добавить поле времени
      "end_time": DateTime.now()
          .add(const Duration(hours: 2))
          .toIso8601String(),
      "pass_score": 0,
      "is_percentage": true,
      "is_active": true,
      "created_by": "3fa85f64-5717-4562-b3fc-2c963f66afa6", // твой user_id
    };

    try {
      final examModel = await ExamApiService().postRequest(
        'exams/',
        data: data,
      );

      // Если успешно, добавляем в локальный список
      widget.onAdd(
        ExamItem(
          title: examModel.title,
          group: selectedGroup!,
          teacher: selectedTeacher!,
          direction: direction.text,
          date: date!,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      // Показываем ошибку
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при создании экзамена: $e')),
      );
    }
  }
}
