import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/students_card.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/title.dart';

class StudentHistory extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const StudentHistory({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return StudentsCard.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Titles.title("Student History"),
          const SizedBox(height: 16),
          ...history.map(_historyItem),
        ],
      ),
    );
  }

  Widget _historyItem(Map<String, dynamic> h) {
    late IconData icon;
    late Color color;

    switch (h["type"]) {
      case "payment":
        icon = Icons.payments_rounded;
        color = Colors.green;
        break;
      case "absence":
        icon = Icons.cancel_rounded;
        color = Colors.red;
        break;
      case "group_add":
        icon = Icons.group_add_rounded;
        color = Colors.blue;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  h["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  h["description"],
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 6),
                Text(
                  h["date"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
