import 'package:flutter/material.dart';

import 'package:srm/src/the_mind/main_the_mind/domain/attendance_entity.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/widgets/attendance_chart.dart';

class TheMindAttendanceSection extends StatelessWidget {
  const TheMindAttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AttendanceChart(data: _generateLast30Days());
  }

  List<AttendanceEntity> _generateLast30Days() {
    final now = DateTime.now();
    return List.generate(30, (i) {
      final day = now.subtract(Duration(days: 29 - i));
      return AttendanceEntity(
        date: DateTime(day.year, day.month, day.day),
        absent: (i * 2) % 7 + 1,
        attended: (i * 3) % 10 + 3,
      );
    });
  }
}
