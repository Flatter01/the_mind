import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/group_details.dart';

class GroupRow extends StatelessWidget {
  final GroupModel group;

  const GroupRow({super.key, required this.group});

  String get _initials {
    final name = (group.teacherName ?? '').trim();
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get _avatarColor {
    const colors = [
      Color(0xFFED6A2E),
      Color(0xFF6B7FD4),
      Color(0xFF2ECC8A),
      Color(0xFF8A9BB8),
    ];
    return colors[(group.teacherName ?? '').length % colors.length];
  }

  // ✅ Маппинг английских названий и чисел → русские сокращения
  static const _dayMap = {
    // Английские названия (из API объектов)
    'Monday': 'Пн',
    'Tuesday': 'Вт',
    'Wednesday': 'Ср',
    'Thursday': 'Чт',
    'Friday': 'Пт',
    'Saturday': 'Сб',
    'Sunday': 'Вс',
    // Числа (из API строки "1,3,5")
    '1': 'Пн',
    '2': 'Вт',
    '3': 'Ср',
    '4': 'Чт',
    '5': 'Пт',
    '6': 'Сб',
    '7': 'Вс',
  };

  String get _daysDisplay {
    final days = group.weekDays;
    if (days == null || days.trim().isEmpty) return '—';

    // weekDays после _parseWeekDays в GroupModel уже строка вида:
    // "Wednesday,Thursday,Saturday" или "2,4,6"
    final parts = days.split(',');

    final result = parts
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .map((p) => _dayMap[p] ?? p)
        .join('-');

    return result.isEmpty ? '—' : result;
  }

  // "10:00:00" → "10:00"
  String _fmt(String? t) {
    if (t == null) return '?';
    return t.length > 5 ? t.substring(0, 5) : t;
  }

  String get _timeDisplay {
    if (group.startTime == null && group.endTime == null) return '—';
    return '${_fmt(group.startTime)} — ${_fmt(group.endTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final students = group.studentCount ?? 0;
    const capacity = 12;
    final fillPercent = (students / capacity).clamp(0.0, 1.0);
    final isFull = students >= capacity;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<GroupCubit>(),
              child: GroupDetails(groupId: group.id!),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.08)),
          ),
        ),
        child: Row(
          children: [
            // Название
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name ?? '—',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                ],
              ),
            ),

            // Учитель
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: _avatarColor.withOpacity(0.15),
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _avatarColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      group.teacherName ?? '—',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1A2233),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Ученики + прогресс-бар
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$students/$capacity',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFull ? 'Full' : '${(fillPercent * 100).round()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isFull
                              ? const Color(0xFFED6A2E)
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fillPercent,
                      minHeight: 5,
                      backgroundColor: Colors.grey.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFED6A2E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Дни — теперь показывает Пн-Ср-Пт
            Expanded(
              flex: 2,
              child: Text(
                _daysDisplay,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1A2233),
                ),
              ),
            ),

            // Время
            Expanded(
              flex: 2,
              child: Text(
                _timeDisplay,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1A2233),
                ),
              ),
            ),

            // Уровень
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Text(
                  group.levelDisplay ?? group.level ?? '—',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Комната
            Expanded(
              flex: 1,
              child: Text(
                group.roomName ??
                    (group.room != null ? '${group.room}' : 'Online'),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}