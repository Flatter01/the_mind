import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/kurs/lid_kurs_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_group_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/faol_lidlar/show_add_action_picker.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_models.dart';

class FaolLidlarPage extends StatefulWidget {
  const FaolLidlarPage({super.key});

  @override
  State<FaolLidlarPage> createState() => _FaolLidlarPageState();
}

class _FaolLidlarPageState extends State<FaolLidlarPage> {
  String _search = '';
  String selectedDay = 'Понедельник';
  final List<LidModels> faolStudents = [];
  final List<LidModels> trialLessons = [];

  final days = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
  ];

  final List<LidKursModel> kurs = [
    LidKursModel(kursName: "Beginner", kursPrice: 800000),
    LidKursModel(kursName: "Intermediate", kursPrice: 800000),
    LidKursModel(kursName: "Individual", kursPrice: 800000),
  ];

  final List<LidGroupModel> lidGroup = [
    LidGroupModel(
      id: "1",
      name: "Flutter A1",
      teacherName: "Ali",
      studentsCount: 12,
      isExamNow: false,
      lessonTime: "14:00-15:30",
      evenWeeks: true,
      daysPerWeek: 3,
    ),
    LidGroupModel(
      id: "1",
      name: "Flutter A1",
      teacherName: "Ali",
      studentsCount: 12,
      isExamNow: true,
      lessonTime: "14:00-15:30",
      evenWeeks: true,
      daysPerWeek: 3,
    ),
  ];

  final List<String> allStatuses = [
    'Lidlar',
    'В ожидании',
    'Пришли',
    'Не пришли',
    'Позвонить',
  ];

  final List<LidModels> users = [
    LidModels(
      name: 'Иван Иванов',
      phone: '+998 90 123 45 67',
      group: 'Группа A',
      date: '02.02.2026',
      status: 'Lidlar',
      gender: "",
      branch: "Toshkent",
      tariff: "Standart",
      day: "Понедельник",
    ),
  ];

  final List<LidModels> waiting = [
    LidModels(
      name: 'Алексей Алексев',
      phone: '+998 97 111 22 33',
      group: 'Группа C',
      date: '02.02.2026',
      status: 'В ожидании',
      gender: "",
      branch: "Toshkent",
      tariff: "Standart",
      day: "Понедельник",
    ),
  ];

  final List<LidModels> came = [
    LidModels(
      name: 'Сергей Сергеев',
      phone: '+998 99 444 55 66',
      group: 'Группа D',
      date: '02.02.2026',
      status: 'Пришли',
      gender: "",
      branch: "Toshkent",
      tariff: "Standart",
      day: "Понедельник",
    ),
  ];

  final List<LidModels> notCame = [
    LidModels(
      name: 'Дмитрий Дмитриев',
      phone: '+998 93 777 88 99',
      group: 'Группа E',
      date: '02.02.2026',
      status: 'Не пришли',
      gender: "",
      branch: "Toshkent",
      tariff: "Standart",
      day: "Понедельник",
    ),
  ];

  final List<LidModels> callVerdict = [
    LidModels(
      name: 'Мария Иванова',
      phone: '+998 95 111 22 33',
      group: 'Группа F',
      date: '02.02.2026',
      status: 'Позвонить',
      gender: "",
      branch: "Toshkent",
      tariff: "Standart",
      day: "Понедельник",
    ),
  ];

  void moveUserToStatus(LidModels user, String newStatus) {
    users.remove(user);
    waiting.remove(user);
    came.remove(user);
    notCame.remove(user);
    callVerdict.remove(user);

    user.status = newStatus;

    switch (newStatus) {
      case 'Lidlar':
        users.add(user);
        break;
      case 'В ожидании':
        waiting.add(user);
        break;
      case 'Пришли':
        came.add(user);
        break;
      case 'Не пришли':
        notCame.add(user);
        break;
      case 'Позвонить':
        callVerdict.add(user);
        break;
    }

    setState(() {});
  }

  void showStatusPicker(LidModels user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Сменить статус'),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: allStatuses.map((status) {
                final isCurrent = user.status == status;

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isCurrent
                      ? AppColors.mainColor.withOpacity(0.1)
                      : null,
                  title: Text(status),
                  trailing: isCurrent
                      ? Icon(Icons.check, color: AppColors.mainColor)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    moveUserToStatus(user, status);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  List<LidModels> _filter(List<LidModels> list) {
    if (_search.isEmpty) return list;
    return list
        .where((e) => e.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: screenWidth > 900 ? 420 : screenWidth * 0.7,
                  child: BuildSearchBar(
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                const SizedBox(width: 20),
                buildDayFilter(),
              ],
            ),
            const SizedBox(height: 24),

            /// 🔥 ГОРИЗОНТАЛЬНЫЙ СКРОЛЛ С МЫШКОЙ
            Expanded(
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildColumn('Lidlar', _filter(users)),
                      const SizedBox(width: 16),
                      buildColumn('В ожидании', _filter(waiting)),
                      const SizedBox(width: 16),
                      buildColumn('Пришли', _filter(came)),
                      const SizedBox(width: 16),
                      buildColumn('Не пришли', _filter(notCame)),
                      const SizedBox(width: 16),
                      buildColumn('Позвонить', _filter(callVerdict)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDayFilter() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: days.map((day) {
          final isActive = selectedDay == day;

          return GestureDetector(
            onTap: () => setState(() => selectedDay = day),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppColors.mainColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                day.substring(0, 2),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildColumn(String title, List<LidModels> data) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Divider(),

          /// 🔥 ВЕРТИКАЛЬНЫЙ СКРОЛЛ ВНУТРИ КОЛОНКИ
          Expanded(
            child: ListView(
              children: [
                if (data.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'Нет данных',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ...data.map((e) => userCard(e)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userCard(LidModels user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 ИМЯ
          Text(
            user.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 6),

          /// 🔹 ТЕЛЕФОН
          Row(
            children: [
              const Icon(Icons.phone, size: 14),
              const SizedBox(width: 6),
              Text(user.phone),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 ГРУППА И ДАТА
          Text(
            user.date,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          /// 🔹 КНОПКИ
          Row(
            children: [
              /// статус
              InkWell(
                onTap: () => showStatusPicker(user),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user.status,
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// добавить
              OutlinedButton.icon(
                onPressed: () => showAddLidDialog(
                  context: context,
                  groups: lidGroup,
                  kursList: kurs,
                  branches: ["Chilonzor", "Yunusobod", "Sergeli"],
                  booksList: [
                    BookModel("English Kids 1"),
                    BookModel("English Kids 2"),
                    BookModel("Grammar Book"),
                  ],
                  onSave: (LidData data) {
                    setState(() {
                      user.group = data.group?.name ?? user.group;
                      user.gender = data.gender ?? user.gender;
                      user.branch = data.region ?? user.branch;
                      user.tariff = data.kurs?.kursName ?? user.tariff;
                      user.comment = data.comment ?? "";
                    });
                  },
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text("edit"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
