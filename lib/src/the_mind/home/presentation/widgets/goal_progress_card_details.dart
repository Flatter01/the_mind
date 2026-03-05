import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/cell.dart';
import 'package:srm/src/core/widgets/flexible_data_table.dart';
import 'package:srm/src/core/widgets/menu_cell.dart';
import 'package:srm/src/the_mind/home/data/models/build_trial_lesson_models.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';

class GoalProgressCardDetails extends StatefulWidget {
  const GoalProgressCardDetails({super.key});

  @override
  State<GoalProgressCardDetails> createState() =>
      _GoalProgressCardDetailsState();
}

class _GoalProgressCardDetailsState extends State<GoalProgressCardDetails> {
  List<BuildTrialLessonModels> trialLesson = [
    BuildTrialLessonModels(
      name: "Aliyev Bekzod",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "IELTS 7.0",
      balance: "0",
      status: "Probniy dars",
      called: false,
    ),
    BuildTrialLessonModels(
      name: "Sattorova Madina",
      phone: "+998 99 445 22 11",
      teacher: "Kamol",
      group: "General English A2",
      balance: "0",
      status: "Probniy dars",
      called: true,
    ),
    BuildTrialLessonModels(
      name: "Karimov Jasur",
      phone: "+998 93 556 12 88",
      teacher: "Madina",
      group: "Math Beginner",
      balance: "0",
      status: "Probniy dars",
      called: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          const BuildSearchBar(),
          const SizedBox(height: 20),

          FlexibleDataTable<BuildTrialLessonModels>(
            title: "To‘lov qilishi kerak bo‘lganlar",
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => const StudentDetailsPage(),
              //   ),
              // );
            },

            rowBuilder: (s, i) => [
              Cell(s.name, bold: true),
              Cell(s.phone),
              Cell(s.teacher),
              Cell(s.group),

              Cell(
                s.balance,
                color: s.status == "Probniy dars"
                    ? Colors.orange
                    : Colors.green,
                bold: true,
              ),

              Cell(
                s.called ? "Pozvonili" : "Ne pozvonili",
                color: s.called ? Colors.green : Colors.red,
                bold: true,
              ),

              MenuCell(
                menuItems: [
                  const PopupMenuItem(
                    value: 'open',
                    child: Text("Ochish"),
                  ),
                  PopupMenuItem(
                    value: 'toggle_call',
                    child: Text(
                      s.called
                          ? "Ne pozvonili deb belgilash"
                          : "Pozvonili deb belgilash",
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'open':
                      debugPrint("Open ${s.name}");
                      break;

                    case 'toggle_call':
                      final index = trialLesson.indexOf(s);
                      trialLesson[index] =
                          s.copyWith(called: !s.called);
                      setState(() {});
                      break;
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
