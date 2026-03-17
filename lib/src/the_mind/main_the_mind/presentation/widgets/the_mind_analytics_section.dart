import 'package:flutter/material.dart';

import 'package:srm/src/core/widgets/analytica/build_analytics_details.dart';
import 'package:srm/src/the_mind/home/data/models/build_debtors_table_models.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/widgets/analytica/analytica.dart';

class TheMindAnalyticsSection extends StatelessWidget {
  const TheMindAnalyticsSection({super.key});

  static const List<AnalyticsItem> _items = [
    AnalyticsItem(title: "Faol lidlar", value: "270"),
    AnalyticsItem(title: "Faol o'quvchilar", value: "187"),
    AnalyticsItem(title: "Sinov Darsida", value: "3"),
    AnalyticsItem(title: "Qarzdorlar", value: "33"),
    AnalyticsItem(title: "Kitoblar", value: "100"),
    AnalyticsItem(title: "Guruhlar", value: "35"),
  ];

  static final List<BuildDebtorsTableModels> _students = [
    BuildDebtorsTableModels(
      name: "Aliyev Bekzod",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "IELTS 7.0",
      balance: "-150 000",
      status: "Qarzdor",
      called: true,
    ),
    BuildDebtorsTableModels(
      name: "Sattorova Madina",
      phone: "+998 99 445 22 11",
      teacher: "Kamol",
      group: "General English A2",
      balance: "110 000",
      status: "Qarzdor emas",
      called: true,
    ),
    BuildDebtorsTableModels(
      name: "Karimov Jasur",
      phone: "+998 93 556 12 88",
      teacher: "Madina",
      group: "Math Beginner",
      balance: "-80 000",
      status: "Qarzdor",
      called: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Analytics(
      items: _items,
      onTap: (item) => _onTap(context, item.title),
    );
  }

  void _onTap(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuildAnalyticsDetails<BuildDebtorsTableModels>(
          data: _students,
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
