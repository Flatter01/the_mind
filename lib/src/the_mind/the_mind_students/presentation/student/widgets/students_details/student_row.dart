import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';

class StudentRow extends StatelessWidget {
  final StudentModel student;

  const StudentRow({super.key, required this.student});

  String get _initials {
    final first = (student.firstName ?? '').isNotEmpty
        ? student.firstName![0]
        : '';
    final last = (student.lastName ?? '').isNotEmpty
        ? student.lastName![0]
        : '';
    return '$last$first'.toUpperCase();
  }

  Color get _avatarColor {
    final colors = [
      const Color(0xFFED6A2E),
      const Color(0xFF6B7FD4),
      const Color(0xFF2ECC8A),
      const Color(0xFF8A9BB8),
    ];
    final hash = (student.firstName ?? '').length % colors.length;
    return colors[hash];
  }

  @override
  Widget build(BuildContext context) {
    final isDebtor =
        student.status.toLowerCase().contains('qarzdor') ||
        student.status.toLowerCase().contains('должник');
    final isTrial =
        student.status.toLowerCase().contains('trial') ||
        student.status.toLowerCase().contains('probniy') ||
        student.status.toLowerCase().contains('пробный');

    final balanceNegative = student.balance.contains('-');

    Color statusColor;
    String statusLabel;
    Color statusBg;

    if (isDebtor) {
      statusColor = const Color(0xFFED6A2E);
      statusBg = const Color(0xFFED6A2E).withOpacity(0.1);
      statusLabel = 'Должник';
    } else if (isTrial) {
      statusColor = const Color(0xFF6B7FD4);
      statusBg = const Color(0xFF6B7FD4).withOpacity(0.1);
      statusLabel = 'Пробный';
    } else {
      statusColor = const Color(0xFF2ECC8A);
      statusBg = const Color(0xFF2ECC8A).withOpacity(0.1);
      statusLabel = 'Активен';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDetailsPage(student: student),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
        ),
        child: Row(
          children: [
            // Имя + аватар
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _avatarColor.withOpacity(0.15),
                    child: Text(
                      _initials,
                      style: TextStyle(
                        color: _avatarColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${student.lastName ?? ''} ${student.firstName ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Телефон
            Expanded(
              flex: 2,
              child: Text(
                student.phone ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),

            // Группа / преподаватель
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.groupName ?? '____',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  Text(
                    student.teacherName ?? '___',
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),

            // Баланс
            Expanded(
              flex: 1,
              child: Text(
                student.balance,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: balanceNegative
                      ? const Color(0xFFED6A2E)
                      : const Color(0xFF1A2233),
                ),
              ),
            ),

            // Статус
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ),

            // Действия
            Expanded(
              flex: 1,
              child: PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                onSelected: (value) {
                  if (value == 'delete') {
                    context.read<StudentCubit>().deleteStudent(student.id!);
                  }

                  if (value == 'freeze') {
                    debugPrint("Заморозить: ${student.firstName}");
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'delete', child: Text("Удалить")),
                  PopupMenuItem(value: 'freeze', child: Text("Заморозить")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
