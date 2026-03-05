import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import '../the_mind_exams_page.dart';

class EditExamDialog extends StatefulWidget {
  final ExamItem exam;
  final List<Student> allStudents;
  final List<String> teachers;
  final VoidCallback onSave;

  const EditExamDialog({
    super.key,
    required this.exam,
    required this.allStudents,
    required this.teachers,
    required this.onSave,
  });

  @override
  State<EditExamDialog> createState() => _EditExamDialogState();
}

class _EditExamDialogState extends State<EditExamDialog> {
  late final TextEditingController title;
  late final TextEditingController direction;

  late DateTime date;
  late bool isFinished;
  late String selectedGroup;
  late String selectedTeacher;

  late List<StudentMark> marks;

  final groups = ["Group A", "Group B", "Group C"];

  @override
  void initState() {
    super.initState();

    title = TextEditingController(text: widget.exam.title);
    direction = TextEditingController(text: widget.exam.direction);

    date = widget.exam.date;
    isFinished = widget.exam.isFinished;

    selectedGroup = widget.exam.group;
    selectedTeacher = widget.exam.teacher;

    marks = List.from(widget.exam.students);

    _ensureStudentsLoaded();
  }

  void _ensureStudentsLoaded() {
    final groupStudents = widget.allStudents
        .where((s) => s.group == selectedGroup)
        .toList();

    for (final s in groupStudents) {
      if (!marks.any((m) => m.fullName == s.fullName)) {
        marks.add(StudentMark(fullName: s.fullName, mark: 0));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.bgColor,
      child: SizedBox(
        width: 650,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Exam",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),

                const SizedBox(height: 20),

                _modernField(title, "Exam name"),

                _modernGroupDropdown(),

                _modernTeacherDropdown(),

                _modernField(direction, "Direction"),

                _modernDatePicker(),

                _modernStatusSwitch(),

                const SizedBox(height: 24),

                const Text(
                  "Student Marks",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),

                const SizedBox(height: 12),

                ...marks.map(_modernMarkRow),

                const SizedBox(height: 28),

                _modernActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  /// GROUP DROPDOWN
  Widget _modernGroupDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedGroup,
        items: groups
            .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g),
                ))
            .toList(),
        onChanged: (v) {
          setState(() {
            selectedGroup = v!;
            marks.clear();
            _ensureStudentsLoaded();
          });
        },
        decoration: InputDecoration(
          labelText: "Group",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  /// TEACHER DROPDOWN
  Widget _modernTeacherDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedTeacher,
        items:widget.teachers
            .map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t),
                ))
            .toList(),
        onChanged: (v) {
          setState(() {
            selectedTeacher = v!;
          });
        },
        decoration: InputDecoration(
          labelText: "Teacher",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _modernMarkRow(StudentMark m) {
    final ctrl = TextEditingController(text: m.mark.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
                child: Text(
              m.fullName,
              style: const TextStyle(fontSize: 15),
            )),
            SizedBox(
              width: 100,
              child: TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "0-100",
                  filled: true,
                  fillColor: AppColors.bgColor,
                  contentPadding:
                      const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
                onChanged: (v) {
                  final val = int.tryParse(v) ?? 0;
                  m.mark = val.clamp(0, 100);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _modernDatePicker() => GestureDetector(
        onTap: _pickDate,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "${date.day}.${date.month}.${date.year}",
                style: const TextStyle(fontSize: 15),
              )),
              const Icon(Icons.calendar_today_outlined, size: 20),
            ],
          ),
        ),
      );

  Widget _modernStatusSwitch() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14)),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Finished"),
          value: isFinished,
          onChanged: (v) => setState(() => isFinished = v),
        ),
      );

  Widget _modernActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.mainColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _save,
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _pickDate() async {
    final p = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: date,
    );

    if (p != null) setState(() => date = p);
  }

  void _save() {
    widget.exam.title = title.text;
    widget.exam.group = selectedGroup;
    widget.exam.teacher = selectedTeacher;
    widget.exam.direction = direction.text;
    widget.exam.date = date;
    widget.exam.isFinished = isFinished;
    widget.exam.students = marks;

    widget.onSave();

    Navigator.pop(context);
  }
}
