import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';

// Тип блока для разного отображения
enum StudentsBlockType { trial, debtors, absent }

class StudentsListWidget extends StatelessWidget {
  final String title;
  final Widget icons;
  final String quantity;
  final List<BuildStudentsTableItem> students;
  final StudentsBlockType blockType;

  const StudentsListWidget({
    super.key,
    required this.title,
    required this.icons,
    required this.quantity,
    required this.blockType,
    this.students = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              icons,
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  quantity,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _badgeColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // List
          students.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Нет данных',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(students.length, (index) {
                    final student = students[index];
                    return _buildStudentTile(student, index);
                  }),
                ),

          // Footer button (только для Должников)
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Разослать напоминания',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color get _badgeColor {
    switch (blockType) {
      case StudentsBlockType.trial:
        return const Color(0xFF6B7FD4);
      case StudentsBlockType.debtors:
        return const Color(0xFFED6A2E);
      case StudentsBlockType.absent:
        return const Color(0xFF8A9BB8);
    }
  }

  Widget _buildStudentTile(BuildStudentsTableItem student, int index) {
    switch (blockType) {
      case StudentsBlockType.trial:
        return _TrialStudentTile(student: student, index: index);
      case StudentsBlockType.debtors:
        return _DebtorStudentTile(student: student);
      case StudentsBlockType.absent:
        return _AbsentStudentTile(student: student);
    }
  }
}

// --- Tile: Записанные на пробный ---
class _TrialStudentTile extends StatelessWidget {
  final BuildStudentsTableItem student;
  final int index;

  const _TrialStudentTile({required this.student, required this.index});

  // Цвета аватаров
  static const _avatarColors = [
    Color(0xFFD4A5A5),
    Color(0xFFED6A2E),
    Color(0xFFB0C4D8),
  ];

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColors[index % _avatarColors.length];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarColor,
            child: Text(
              student.name.isNotEmpty ? student.name[0] : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${student.group} · 18:00',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: Colors.grey[400], size: 18),
        ],
      ),
    );
  }
}

// --- Tile: Должники ---
class _DebtorStudentTile extends StatelessWidget {
  final BuildStudentsTableItem student;

  const _DebtorStudentTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  student.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                student.balance,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFFED6A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(
                'Курс: ${student.group}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const Spacer(),
              Text(
                'просрочено 4 д.',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

// --- Tile: Не пришедшие ---
class _AbsentStudentTile extends StatelessWidget {
  final BuildStudentsTableItem student;

  const _AbsentStudentTile({required this.student});

  static const _dotColors = [
    Color(0xFFED6A2E),
    Color(0xFF6B7FD4),
    Color(0xFFF5C542),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _dotColors[0],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Курс: ${student.group}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Позвонить',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
