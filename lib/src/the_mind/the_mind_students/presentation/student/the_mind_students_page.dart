import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/analytica/build_analytics.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/build_filters.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/students_models.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/build_students_table.dart';

class TheMindStudentsPage extends StatefulWidget {
  const TheMindStudentsPage({super.key});

  @override
  State<TheMindStudentsPage> createState() => _TheMindStudentsPageState();
}

class _TheMindStudentsPageState extends State<TheMindStudentsPage> {
  String? selectedDayType;
  String? selectedTeacher;
  String? selectedCourse;
  String? selectedDebt;

  final List<String> teachers = ["All", "Aziz", "Kamol", "Madina"];
  final List<String> courses = ["All", "IELTS", "General English", "Math"];

  final List<AnalyticsItem> analyticsItems = [
    AnalyticsItem(
      title: "Faol lidlar",
      value: "270",
      color: Color(0xFF0A84FF),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: "Faol o'quvchilar",
      value: "187",
      color: Color(0xFF0EA400),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: "Qarzdorlar",
      value: "33",
      color: Colors.white,
      textColor: Colors.black87,
    ),
    AnalyticsItem(
      title: "Umumiy Qarz",
      value: "2 500 000",
      color: Color(0xFFF54D4D),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: "Guruhlar",
      value: "35",
      color: Colors.white,
      textColor: Colors.black87,
    ),
  ];

  final List<BuildStudentsTableItem> students = [
    BuildStudentsTableItem(
      id: 0,
      name: "Aliyev Bekzod",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "IELTS 7.0",
      balance: "-150 000",
      status: "Qarzdor",
      called: true,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 0,
      name: "Sattorova Madina",
      phone: "+998 99 x445 22 11",
      teacher: "Kamol",
      group: "General English A2",
      balance: "110 000",
      status: "Qarzdor emas",
      called: true,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 0,
      name: "Karimov Jasur",
      phone: "+998 93 556 12 88",
      teacher: "Madina",
      group: "Math Beginner",
      balance: "-80 000",
      status: "Qarzdor",
      called: true,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 0,
      name: "Karimov Jasur",
      phone: "+998 93 556 12 88",
      teacher: "Madina",
      group: "Math Beginner",
      balance: "0",
      status: "Probniy dars",
      called: true,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 0,
      name: "Karimov Jasur",
      phone: "+998 93 556 12 88",
      teacher: "Madina",
      group: "Math Beginner",
      balance: "0",
      status: "Probniy dars",
      called: true,
      missedLessons: 2,
    ),
  ];
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final filtered = students.where((w) {
      final q = _search.toLowerCase();
      return w.name.toLowerCase().contains(q) ||
          w.status.toLowerCase().contains(q) ||
          w.group.toLowerCase().contains(q) ||
          w.phone.toLowerCase().contains(q);
    }).toList();
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          BuildAnalytics(items: analyticsItems, onTap: (items) {}),
          const SizedBox(height: 20),
          BuildSearchBar(onChanged: (v) => setState(() => _search = v)),

          const SizedBox(height: 16),

          BuildFilters(
            teachers: teachers,
            courses: courses,
            students: students,
            selectedDayType: selectedDayType,
            selectedTeacher: selectedTeacher,
            selectedCourse: selectedCourse,
            selectedDebt: selectedDebt,
          ),
          const SizedBox(height: 16),
          BuildStudentsTable(students: students),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
