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

  double get _balance => double.tryParse(student.balance) ?? 0;

  String get _balanceDisplay {
    final b = _balance;
    if (b == 0) return '0 сум';
    if (b < 0) return '${b.toInt()} сум'; // отрицательный = долг
    return '+${b.toInt()} сум'; // положительный = переплатил
  }

  bool get _isDebt => _balance < 0;

  // ✅ Статус берём из поля status (active/inactive/trial)
  // НЕ из debt_status — он у всех 'debt' кто не заплатил
  Map<String, dynamic> _statusInfo() {
    final s = student.status.toLowerCase();

    // ✅ 1. Заморозка — проверяем первой
    if (s == 'frozen' || s == 'freeze' || s == 'замороженный') {
      return {
        'label': 'Заморожен',
        'color': const Color(0xFF6B7FD4),
        'bg': const Color(0xFF6B7FD4).withOpacity(0.1),
      };
    }

    // ✅ 2. Не активен
    if (s == 'inactive' || s == 'не активен') {
      return {
        'label': 'Не активен',
        'color': Colors.grey,
        'bg': Colors.grey.withOpacity(0.1),
      };
    }

    // ✅ 3. Пробный
    if (s == 'trial' || s == 'пробный' || s == 'probniy') {
      return {
        'label': 'Пробный',
        'color': const Color(0xFF6B7FD4),
        'bg': const Color(0xFF6B7FD4).withOpacity(0.1),
      };
    }

    // ✅ 4. Должник — либо явно из API, либо баланс отрицательный
    final isBalanceNegative = (double.tryParse(student.balance) ?? 0) < 0;
    if (s == 'debtor' ||
        s == 'qarzdor' ||
        s == 'должник' ||
        isBalanceNegative) {
      return {
        'label': 'Должник',
        'color': const Color(0xFFED6A2E),
        'bg': const Color(0xFFED6A2E).withOpacity(0.1),
      };
    }

    // 5. Активен — по умолчанию
    return {
      'label': 'Активен',
      'color': const Color(0xFF2ECC8A),
      'bg': const Color(0xFF2ECC8A).withOpacity(0.1),
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo();

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
            // ── Имя + аватар ──
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

            // ── Телефон ──
            Expanded(
              flex: 2,
              child: Text(
                student.phone ?? '—',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),

            // ── Группа / преподаватель ──
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.groupName ?? '—',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  Text(
                    student.teacherName ?? '—',
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),

            // ── Баланс ──
            // Показываем сколько ещё должен (finalPrice - paidAmount)
            Expanded(
              flex: 1,
              child: Text(
                _balanceDisplay,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _isDebt
                      ? const Color(0xFFED6A2E) // должен — красный
                      : const Color(
                          0xFF2ECC8A,
                        ), // оплачено/переплатил — зелёный
                ),
              ),
            ),

            // ── Статус ──
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusInfo['bg'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusInfo['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusInfo['color'] as Color,
                  ),
                ),
              ),
            ),

            // ── Действия ──
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
                    context.read<StudentCubit>().freezeStudent(student.id!);
                  }
                  if (value == 'unfreeze') {
                    context.read<StudentCubit>().unfreezeStudent(student.id!);
                  }
                },
                itemBuilder: (context) {
                  final isFrozen = student.status == 'frozen';
                  return [
                    const PopupMenuItem(value: 'delete', child: Text('Удалить')),
                    if (isFrozen)
                      const PopupMenuItem(value: 'unfreeze', child: Text('Разморозить'))
                    else
                      const PopupMenuItem(value: 'freeze', child: Text('Заморозить')),
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
