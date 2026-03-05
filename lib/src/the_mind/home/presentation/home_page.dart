import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/analytica/build_analytics.dart';
import 'package:srm/src/core/widgets/analytica/build_analytics_details.dart';
import 'package:srm/src/core/widgets/cell.dart';
import 'package:srm/src/core/widgets/flexible_data_table.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/goal_progress_card.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/goal_progress_card_details.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/students_models.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// --- Trial ---
  List<BuildStudentsTableItem> trialLesson = [
    BuildStudentsTableItem(
      id: 0,
      name: "Aliyev Bekzod",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "IELTS 7.0",
      balance: "0",
      status: "Probniy dars",
      called: false,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Sattorova Madina",
      phone: "+998 99 445 22 11",
      teacher: "Kamol",
      group: "General English A2",
      balance: "0",
      status: "Probniy dars",
      called: true,
      missedLessons: 2,
    ),
  ];

  /// --- Debtors ---
  List<BuildStudentsTableItem> students = [
    BuildStudentsTableItem(
      id: 0,
      name: "Aliyev Bekzod",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "IELTS 7.0",
      balance: "-110 000",
      status: "Qarzdor",
      called: true,
      missedLessons: 2,
    ),
  ];

  final double todayGoal = 2_000_000;
  final double collected = 1_100_000;

  final List<AnalyticsItem> analyticsItems = [
    AnalyticsItem(
      title: "Faol o'quvchilar",
      value: "187",
      color: const Color(0xFF0EA400),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: "Yangi o'quvchilar (kutilmoqda)",
      value: "12",
      color: const Color(0xFF1E88E5),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: "Yangi lidlar",
      value: "20",
      color: const Color(0xFF43A047),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: "Sinov darsiga yozilganlar",
      value: "6",
      color: const Color(0xFFFFB300),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: "Bugungi tashriflar",
      value: "60",
      color: Colors.white,
      textColor: Colors.black87,
    ),
    AnalyticsItem(
      title: "Bugun kelganlar",
      value: "32",
      color: Colors.white,
      textColor: Colors.black87,
    ),
    AnalyticsItem(
      title: "Sinov darsida (bugun)",
      value: "3",
      color: Colors.white,
      textColor: Colors.black87,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final progressRaw = collected / todayGoal;
    final progressBarValue = progressRaw.clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          const SizedBox(height: 6),

          BuildAnalytics(
            items: analyticsItems,
            onTap: (item) => onTap(title: item.title),
          ),

          const SizedBox(height: 25),

          const Text(
            "Bugungi reja summa",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 14),

          GoalProgressCard(
            goal: todayGoal,
            collected: collected,
            progressRaw: progressRaw,
            progressBarValue: progressBarValue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GoalProgressCardDetails(),
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          /// ---------- Trial ----------
          FlexibleDataTable<BuildStudentsTableItem>(
            title: "Probniy dars o‘quvchilari",
            headers: const [
              "Ism",
              "Telefon",
              "O‘qituvchi",
              "Guruh",
              "Balans",
              "Qo‘ng‘iroq",
              "",
            ],
            data: trialLesson,
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.6),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1.4),
              6: FixedColumnWidth(50),
            },
            onRowTap: (s, i) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentDetailsPage()),
              );
            },
            rowBuilder: (s, i) => [
              Cell(s.name, bold: true),
              Cell(s.phone),
              Cell(s.teacher),
              Cell(s.group),
              Cell(s.balance, color: Colors.orange, bold: true),
              Cell(
                s.called ? "Pozvonili" : "Ne pozvonili",
                color: s.called ? Colors.green : Colors.red,
                bold: true,
              ),
              _menu(s),
            ],
          ),

          const SizedBox(height: 25),

          FlexibleDataTable<BuildStudentsTableItem>(
            title: "Qarzdor o‘quvchilar",
            headers: const [
              "Ism",
              "Telefon",
              "O‘qituvchi",
              "Guruh",
              "Balans",
              "Qo‘ng‘iroq",
              "",
            ],
            data: trialLesson,
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.6),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1.4),
              6: FixedColumnWidth(50),
            },
            onRowTap: (s, i) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentDetailsPage()),
              );
            },
            rowBuilder: (s, i) => [
              Cell(s.name, bold: true),
              Cell(s.phone),
              Cell(s.teacher),
              Cell(s.group),
              Cell(s.balance, color: Colors.red, bold: true),
              Cell(
                s.called ? "Pozvonili" : "Ne pozvonili",
                color: s.called ? Colors.green : Colors.red,
                bold: true,
              ),
              _menu(s),
            ],
          ),
          const SizedBox(height: 25),
          FlexibleDataTable<BuildStudentsTableItem>(
            title: "Kelmaganlar",
            headers: const [
              "Ism",
              "Telefon",
              "O‘qituvchi",
              "Guruh",
              "Kelmagan Dars",
                  "Balans",
              "Qo‘ng‘iroq",
              "",
            ],
            data: trialLesson,
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.6),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1.2),
              6: FlexColumnWidth(1.4),
              7: FixedColumnWidth(50),
            },
            onRowTap: (s, i) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentDetailsPage()),
              );
            },
            rowBuilder: (s, i) => [
              Cell(s.name, bold: true),
              Cell(s.phone),
              Cell(s.teacher),
              Cell(s.group),
              Cell(s.missedLessons.toString()),

              Cell(s.balance, color: Colors.orange, bold: true),
              Cell(
                s.called ? "Pozvonili" : "Ne pozvonili",
                color: s.called ? Colors.green : Colors.red,
                bold: true,
              ),
              _menu(s),
            ],
          ),
        ],
      ),
    );
  }

  void onTap({required String title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuildAnalyticsDetails<BuildStudentsTableItem>(
          data: students,
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

  Widget _menu(BuildStudentsTableItem s) {
    return Center(
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_horiz),
        onSelected: (v) {
          if (v == 'toggle_call') {
            setState(() {
              final i = trialLesson.indexOf(s);
              trialLesson[i] = s.copyWith(called: !s.called);
            });
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'open', child: Text("Ochish")),
          PopupMenuItem(value: 'toggle_call', child: Text("Toggle call")),
        ],
      ),
    );
  }
}
