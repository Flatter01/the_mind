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
  final titleController = TextEditingController();
  final directionController = TextEditingController();

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
              const Text(
                "Add exam",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(child: _buildField(titleController, "Exam name")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildGroupDropdown()),
                ],
              ),

              _buildTeacherDropdown(),

              const SizedBox(height: 8),

              _buildDatePicker(),

              const SizedBox(height: 28),

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

  /// GROUP DROPDOWN
  Widget _buildGroupDropdown() {
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

  /// TEACHER DROPDOWN
  Widget _buildTeacherDropdown() {
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

  /// DATE PICKER
  Widget _buildDatePicker() {
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

  /// ACTION BUTTONS
  Widget _buildActions(BuildContext context) {
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

  /// PICK DATE
  void _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: date ?? now,
    );

    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
  }

  /// SAVE EXAM
  void _save() async {
    if (titleController.text.isEmpty ||
        selectedGroup == null ||
        selectedTeacher == null ||
        directionController.text.isEmpty ||
        date == null) {
      return;
    }

    try {
      await ExamApiService().createExam(
        title: titleController.text,
        date: date!.toIso8601String().split('T')[0],
        group: widget.groups.indexOf(selectedGroup!) + 1,
      );

      widget.onAdd(
        ExamItem(
          title: titleController.text,
          group: selectedGroup!,
          teacher: selectedTeacher!,
          direction: directionController.text,
          date: date!,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ошибка при создании экзамена: $e"),
        ),
      );
    }
  }
}