import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/students_card.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/title.dart';

class StudentsExams extends StatelessWidget {
  final List<Map<String, dynamic>> exams;

  const StudentsExams({super.key, required this.exams});

  @override
  Widget build(BuildContext context) {
    return StudentsCard.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Titles.title("Exams"),
          const SizedBox(height: 12),
          for (final e in exams) _examItem(e),
        ],
      ),
    );
  }

  Widget _examItem(Map<String, dynamic> e) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Сначала дата
          Text(
            e["date"] ?? "-",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),

          // Потом название экзамена
          Expanded(
            child: Text(
              e["name"] ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          // Потом учитель
          Text(
            e["teacher"] ?? "-",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 12),

          // В конце оценка
          Text(
            "${e["score"] ?? "-"}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
