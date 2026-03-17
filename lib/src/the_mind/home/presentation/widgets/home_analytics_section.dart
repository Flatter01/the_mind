import 'package:flutter/material.dart';

import 'package:srm/src/core/widgets/analytica/build_analytics_details.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/build_analytics.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';

class HomeAnalyticsSection extends StatelessWidget {
  const HomeAnalyticsSection({super.key});

  static const List<AnalyticsItem> _items = [
    AnalyticsItem(title: "Лиды", value: "128"),
    AnalyticsItem(title: "Студенты", value: "542"),
    AnalyticsItem(title: "Ожидаемые", value: "45"),
    AnalyticsItem(title: "Новые студенты", value: "12"),
  ];

  static final List<BuildStudentsTableItem> _debtors = [
    BuildStudentsTableItem(
      id: 0,
      name: "Виктор Петров",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "Frontend Developer",
      balance: "12 400 ₽",
      status: "Qarzdor",
      called: true,
      missedLessons: 4,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Елена Кравц",
      phone: "+998 90 777 88 99",
      teacher: "Aziz",
      group: "UX/UI Design",
      balance: "5 800 ₽",
      status: "Qarzdor",
      called: true,
      missedLessons: 12,
    ),
    BuildStudentsTableItem(
      id: 2,
      name: "Иван Макаров",
      phone: "+998 90 555 66 77",
      teacher: "Aziz",
      group: "Java Start",
      balance: "15 000 ₽",
      status: "Qarzdor",
      called: false,
      missedLessons: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BuildAnalytics(
      items: _items,
      onTap: (item) => _onAnalyticsTap(context, item.title),
    );
  }

  void _onAnalyticsTap(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuildAnalyticsDetails<BuildStudentsTableItem>(
          data: _debtors,
          title: title,
          getName: (e) => e.name,
          getPhone: (e) => e.phone,
          getTeacher: (e) => e.teacher,
          getGroup: (e) => e.group,
          getBalance: (e) => e.balance,
          getCallStatus: (e) => e.called ? "Pozvonili" : "Ne pozvonili",
          getBalanceColor: (_) => Colors.red,
          getCallStatusColor: (e) => e.called ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
