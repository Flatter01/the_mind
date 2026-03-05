import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/data/model/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';

class Students extends StatefulWidget {
  final List<StudentModel> students; // студенты в группе
  final List<StudentModel> allStudents; // все студенты CRM
  final Function(StudentModel) onSelect;
  final Function(StudentModel) onAddStudent;

  const Students({
    super.key,
    required this.students,
    required this.allStudents,
    required this.onSelect,
    required this.onAddStudent,
  });

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  BoxDecoration _card() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ученики",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          // здесь добавляем Flexible + SingleChildScrollView
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.students.length,
                    itemBuilder: (_, i) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StudentDetailsPage(),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.students[i].name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.students[i].phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Тариф: ${widget.students[i].tariff} • Баланс: ${widget.students[i].balance} сум',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.students[i].isFrozen
                                        ? 'Статус: заморожен'
                                        : 'Статус: активен',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: widget.students[i].isFrozen
                                          ? Colors.redAccent
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (v) => _onStudentAction(v, i),
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'edit', child: Text('Инфо')),
                              PopupMenuItem(
                                value: 'freeze',
                                child: Text('Заморозить'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Удалить',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _addStudent,
                    child: const Text('Добавить ученика'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onStudentAction(String value, int index) {
    switch (value) {
      case 'edit':
        widget.onSelect(widget.students[index]);
        break;

      case 'freeze':
        setState(() {
          widget.students[index].isFrozen = !widget.students[index].isFrozen;
        });
        break;

      case 'delete':
        setState(() {
          widget.students.removeAt(index);
        });
        break;
    }
  }

  // 🔥 ВЫБОР СТУДЕНТА ИЗ СПИСКА
  void _addStudent() async {
    // убираем уже добавленных
    final availableStudents = widget.allStudents
        .where(
          (student) => !widget.students.any((s) => s.phone == student.phone),
        )
        .toList();

    if (availableStudents.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Нет доступных учеников')));
      return;
    }

    final selected = await showDialog<StudentModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите ученика'),
          content: SizedBox(
            width: 400,
            height: 400,
            child: ListView.builder(
              itemCount: availableStudents.length,
              itemBuilder: (_, index) {
                final student = availableStudents[index];

                return ListTile(
                  title: Text(student.name),
                  subtitle: Text(student.phone),
                  onTap: () {
                    Navigator.pop(context, student);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        widget.onAddStudent(selected);
      });
    }
  }
}
