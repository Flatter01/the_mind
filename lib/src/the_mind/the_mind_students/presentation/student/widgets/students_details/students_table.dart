import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/pagination_row.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/student_row.dart';

class StudentsTable extends StatelessWidget {
  final List<StudentModel> students;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int perPage;
  final ValueChanged<int> onPageChanged;

  const StudentsTable({
    super.key,
    required this.students,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.perPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Заголовок таблицы
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                _headerCell('ФИО СТУДЕНТА', flex: 3),
                _headerCell('ТЕЛЕФОН', flex: 2),
                _headerCell('ГРУППА / ПРЕПОДАВАТЕЛЬ', flex: 3),
                _headerCell('БАЛАНС', flex: 1),
                _headerCell('СТАТУС', flex: 1),
                _headerCell('ДЕЙСТВИЯ', flex: 1),
              ],
            ),
          ),

          // Строки
          ...students.map((s) => StudentRow(student: s)),

          // Пагинация
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Показано ${(_currentStart(currentPage, perPage))}-${_currentEnd(currentPage, perPage, totalCount)} из $totalCount студентов',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const Spacer(),
                PaginationRow(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: onPageChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _currentStart(int page, int per) => (page - 1) * per + 1;
  int _currentEnd(int page, int per, int total) {
    final end = page * per;
    return end > total ? total : end;
  }

  Widget _headerCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8A9BB8),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
