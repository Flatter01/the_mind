import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/analytica/build_analytics_details.dart';
import 'package:srm/src/the_mind/home/data/models/build_debtors_table_models.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/widgets/analytics_grid.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/widgets/attendance_chart.dart';
import 'package:srm/src/core/widgets/analytica/build_analytics.dart';
import 'package:srm/src/the_mind/main_the_mind/data/attendance_api.dart';
import 'package:srm/src/the_mind/main_the_mind/data/attendance_repository.dart';
import 'package:srm/src/the_mind/main_the_mind/domain/attendance_entity.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/widgets/responsive_top_area.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/widgets/schedule_grid.dart';

class TheMindPage extends StatefulWidget {
  const TheMindPage({super.key});

  @override
  State<TheMindPage> createState() => _TheMindPageState();
}

class _TheMindPageState extends State<TheMindPage> {

  /// выбранный период
  DateTimeRange? selectedRange;

  /// выбор периода
  Future<void> pickPeriod() async {

    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if(range != null){
      setState(() {
        selectedRange = range;
      });
    }
  }

  final List<AnalyticsItem> analyticsItems = [
    const AnalyticsItem(
      title: "Faol lidlar",
      value: "270",
      color: Color(0xFF0A84FF),
      textColor: Colors.white,
    ),
    const AnalyticsItem(
      title: "Faol o'quvchilar",
      value: "187",
      color: Color(0xFF0EA400),
      textColor: Colors.white,
    ),
    const AnalyticsItem(
      title: "Sinov Darsida",
      value: "3",
      color: Colors.white,
      textColor: Colors.black87,
    ),
    const AnalyticsItem(
      title: "Qarzdorlar",
      value: "33",
      color: Colors.white,
      textColor: Colors.black87,
    ),
    const AnalyticsItem(
      title: "Kitoblar",
      value: "100",
      color: Colors.white,
      textColor: Colors.black,
    ),
    const AnalyticsItem(
      title: "Guruҳga qo'shilmagan",
      value: "0",
      color: Color(0xFFA1A1A1),
      textColor: Colors.white,
    ),
    const AnalyticsItem(
      title: "Guruhlar",
      value: "35",
      color: Colors.white,
      textColor: Colors.black87,
    ),
  ];

  /// Debtors

  List<BuildDebtorsTableModels> students = [

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

  Map<String, int> funnelCounts = {

    "So'rovlar": 120,
    "Sinov keldi": 80,
    "Sinov ketdi": 100,
    "To'lov qildi": 40,

  };

  final List<Color> funnelColors = [

    Color(0xFF4C6FFF),
    Color(0xFF34C759),
    Color(0xFFFF9F0A),
    Color(0xFFFF453A),

  ];

  late Future<List<AttendanceEntity>> future;

  @override
  void initState() {
    super.initState();
    future = AttendanceRepository(AttendanceApi()).fetch();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgColor,

      body: ListView(

        padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5),

        children: [

          BuildAnalytics(
              items: analyticsItems,
              onTap: (items)=> onTap(title: items.title)
          ),

          const SizedBox(height: 20),

          ResponsiveFunnelChart(
            funnelCounts: funnelCounts,
            funnelColors: funnelColors,
          ),

          const SizedBox(height: 20),

          /// Заголовок + период
          _sectionTitle("Asosiy ko‘rsatkichlar"),

          const SizedBox(height: 14),

          const AnalyticsGrid(),

          const SizedBox(height: 15),

          AttendanceChart(
              data: generateLast30Days()
          ),

          const SizedBox(height: 28),

          SchedulePage(),

          const SizedBox(height: 20),

        ],
      ),
    );
  }


  /// SECTION TITLE + DATE PICKER

  Widget _sectionTitle(String title) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        InkWell(

          onTap: pickPeriod,

          child: Container(

            padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6),

            decoration: BoxDecoration(

              borderRadius:
              BorderRadius.circular(8),

              border: Border.all(
                color: Colors.grey.shade300,
              ),

            ),

            child: Row(
              children: [

                const Icon(
                  Icons.date_range,
                  size: 18,
                ),

                const SizedBox(width: 6),

                Text(

                  selectedRange == null
                      ? "Период"
                      : "${selectedRange!.start.day}.${selectedRange!.start.month}"
                      " - "
                      "${selectedRange!.end.day}.${selectedRange!.end.month}",

                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),

              ],
            ),
          ),
        ),

      ],
    );
  }



  void onTap({required String title}) {

    Navigator.push(
      context,

      MaterialPageRoute(

        builder: (_) => BuildAnalyticsDetails<BuildDebtorsTableModels>(

          data: students,

          title: title,

          getName: (e) => e.name,

          getPhone: (e) => e.phone,

          getTeacher: (e) => e.teacher,

          getGroup: (e) => e.group,

          getBalance: (e) => e.balance,

          getCallStatus: (e) =>
          e.called
              ? "Pozvonili"
              : "Ne pozvonili",

          getBalanceColor: (_) => Colors.red,

          getCallStatusColor: (e) =>
          e.called
              ? Colors.green
              : Colors.red,
        ),
      ),
    );
  }


  List<AttendanceEntity> generateLast30Days() {

    final now = DateTime.now();

    return List.generate(30, (i) {

      final day =
      now.subtract(
          Duration(days: 29 - i));

      return AttendanceEntity(

        date: DateTime(
            day.year,
            day.month,
            day.day),

        absent: (i * 2) % 7 + 1,

        attended: (i * 3) % 10 + 3,

      );

    });

  }

}



class HoverCard extends StatefulWidget {

  const HoverCard({
    super.key,
    required this.child});

  final Widget child;

  @override
  State<HoverCard> createState()
      => _HoverCardState();

}



class _HoverCardState
extends State<HoverCard> {

  bool _hover = false;

  @override
  Widget build(BuildContext context) {

    final hovered =
        kIsWeb && _hover;

    return MouseRegion(

      onEnter: (_)
      => setState(() => _hover = true),

      onExit: (_)
      => setState(() => _hover = false),

      cursor: SystemMouseCursors.click,

      child: AnimatedContainer(

        duration:
        const Duration(milliseconds: 200),

        transform: hovered
            ? (Matrix4.identity()
          ..translate(0, -6, 0))
            : Matrix4.identity(),

        child: widget.child,
      ),
    );
  }
}