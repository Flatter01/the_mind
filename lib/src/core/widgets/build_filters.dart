import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/create_group_page.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_payment/add_payment_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog_responsive.dart';

class BuildFilters extends StatefulWidget {
  final String? selectedDayType;
  final String? selectedTeacher;
  final String? selectedCourse;
  final String? selectedDebt;
  final bool? chek;

  final List<String> teachers;
  final List<String> courses;
  final List<BuildStudentsTableItem>? students;

  const BuildFilters({
    super.key,
    this.selectedDayType,
    this.selectedTeacher,
    this.selectedCourse,
    this.selectedDebt,
    this.chek,
    required this.teachers,
    required this.courses,
    this.students,
  });

  @override
  State<BuildFilters> createState() => _BuildFiltersState();
}

class _BuildFiltersState extends State<BuildFilters> {
  String? selectedDayType;
  String? selectedTeacher;
  String? selectedCourse;
  String? selectedDebt;

  bool get isGroupPage => widget.chek != null;
  // final List<Teacher> teachers = [
  //   Teacher(id: "t1", name: "Ali Karimov"),
  //   Teacher(id: "t2", name: "Olimjon Saidov"),
  // ];

  @override
  void initState() {
    super.initState();
    selectedDayType = widget.selectedDayType;
    selectedTeacher = widget.selectedTeacher;
    selectedCourse = widget.selectedCourse;
    selectedDebt = widget.selectedDebt;
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrlash',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          /// ---------- FILTERS ----------
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _dropdown(
                label: 'Kun turi',
                value: selectedDayType,
                items: const {'even': 'Juft kunlar', 'odd': 'Toq kunlar'},
                icon: Icons.calendar_month,
                onChanged: (v) => setState(() => selectedDayType = v),
              ),

              _dropdown(
                label: 'O‘qituvchi',
                value: selectedTeacher,
                items: {for (final t in widget.teachers) t: t},
                icon: Icons.person,
                onChanged: (v) => setState(() => selectedTeacher = v),
              ),

              _dropdown(
                label: 'Kurs',
                value: selectedCourse,
                items: {for (final c in widget.courses) c: c},
                icon: Icons.menu_book_outlined,
                onChanged: (v) => setState(() => selectedCourse = v),
              ),

              if (!isGroupPage)
                _dropdown(
                  label: 'Qarzdorlik',
                  value: selectedDebt,
                  items: const {
                    'debtor': 'Qarzdorlar',
                    'notDebtor': 'Qarzdor emas',
                    'trial': 'Probniy dars',
                  },
                  icon: Icons.warning_amber_rounded,
                  onChanged: (v) => setState(() => selectedDebt = v),
                ),

              if (isGroupPage) _createGroupButton(onTap: _openAddDialog),
            ],
          ),

          const SizedBox(height: 20),

          /// ---------- ACTION BUTTONS ----------
          Row(
            mainAxisAlignment: isGroupPage
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (!isGroupPage)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  label: const Text(
                    'O‘quvchi qo‘shish',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AddStudentDialogResponsive(
                        courses: widget.courses,
                        groups: const [
                          'Frontend A',
                          'Frontend B',
                          'IELTS 1',
                          'IELTS 2',
                        ],
                      ),
                    );

                    if (result != null) {
                      debugPrint('NEW STUDENT: $result');
                    }
                  },
                ),

              if (!isGroupPage) const SizedBox(width: 12),

              if (!isGroupPage)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.attach_money, color: Colors.white),
                  label: const Text(
                    'To‘lov kiritish',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AddPaymentDialogResponsive(
                        students: widget.students ?? [],
                      ),
                    );

                    if (result != null) {
                      debugPrint('NEW PAYMENT: $result');
                    }
                  },
                ),

              const SizedBox(width: 12),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Filtrlarni tozalash',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    selectedDayType = null;
                    selectedTeacher = null;
                    selectedCourse = null;
                    selectedDebt = null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------- CREATE GROUP ----------
  Widget _createGroupButton({required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: const [
            Icon(Icons.group_add, size: 18),
            SizedBox(width: 8),
            Expanded(child: Text('Create group')),
            Icon(Icons.add, size: 18),
          ],
        ),
      ),
    );
  }

  /// ---------- DROPDOWN ----------
  Widget _dropdown({
    required String label,
    required String? value,
    required Map<String, String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: items.containsKey(value) ? value : null,
          hint: Row(
            children: [
              Icon(icon, size: 18, color: Colors.black54),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          items: items.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите действие'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Создать новую группу'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => const CreateGroupPage(),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Потенциальные группы'),
                onTap: () {
                  Navigator.pop(context);
                  _showPotentialGroups();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPotentialGroups() {
    // Пример потенциальных групп
    final potentialGroups = [
      'Beginner A - 6 студентов',
      'Beginner B - 5 студентов',
      'Intermediate - 4 студента',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Потенциальные группы'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: potentialGroups.length,
              itemBuilder: (context, index) {
                final group = potentialGroups[index];
                return ListTile(
                  title: Text(group),
                  trailing: ElevatedButton(
                    child: const Text('Создать'),
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => CreateGroupPage(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
