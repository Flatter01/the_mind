import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/data/model/lesson_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/data/model/student_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/data/model/teacher_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/widgets/lessons.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/widgets/students.dart';

class GroupDetails extends StatefulWidget {
  const GroupDetails({super.key});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final int pricePerStudent = 50000;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StudentModel? selectedStudent;
  final List<StudentModel> allCrmStudents = [
    StudentModel(
      name: 'Ali',
      phone: '+998 90 555 11 11',
      tariff: 'Standart',
      balance: 120000,
      tariffPrice: 800000,
      discount: 0,
      lesson: 51,
      bal: 200,
      arrivalDate: DateTime(2026, 2, 20),
      activationDate: DateTime(2026, 2, 21),
    ),
    StudentModel(
      name: 'Aziz',
      phone: '+998 93 444 55 76',
      tariff: 'Premium',
      balance: 300000,
      tariffPrice: 800000,
      discount: 0,
      lesson: 51,
      bal: 200,
      arrivalDate: DateTime(2026, 2, 20),
      activationDate: DateTime(2026, 2, 21),
    ),
    StudentModel(
      name: 'Begzod',
      phone: '+998 99 777 88 09',
      tariff: 'Basic',
      balance: 0,
      tariffPrice: 800000,
      discount: 0,
      lesson: 51,
      bal: 200,
      arrivalDate: DateTime(2026, 2, 20),
      activationDate: DateTime(2026, 2, 21),
    ),
  ];
  final List<StudentModel> groupStudents = [
    StudentModel(
      name: 'Azizbek',
      phone: '+998 90 111 22 33',
      tariff: 'Standart',
      balance: 120000,
      tariffPrice: 800000,
      discount: 0,
      lesson: 51,
      bal: 200,
      arrivalDate: DateTime(2026, 2, 20),
      activationDate: DateTime(2026, 2, 21),
    ),
    StudentModel(
      name: 'Jasmina',
      phone: '+998 93 444 55 66',
      tariff: 'Premium',
      balance: 300000,
      tariffPrice: 800000,
      discount: 0,
      lesson: 51,
      bal: 200,
      arrivalDate: DateTime(2026, 2, 20),
      activationDate: DateTime(2026, 2, 21),
    ),
    StudentModel(
      name: 'Sardor',
      phone: '+998 99 777 88 99',
      tariff: 'Basic',
      balance: 0,
      tariffPrice: 800000,
      discount: 0,
      lesson: 51,
      bal: 200,
      arrivalDate: DateTime(2026, 2, 20),
      activationDate: DateTime(2026, 2, 21),
    ),
  ];

  final List<LessonModel> lessons = [
    LessonModel(date: '12.09.2025', visits: []),
    LessonModel(date: '14.09.2025', visits: []),
    LessonModel(date: '16.09.2025', visits: []),
  ];

  final List<TeacherModel> teachers = [
    TeacherModel(name: 'Aliyev Bekzod', balance: 1250000),
    TeacherModel(name: 'Karimova Dilnoza', balance: 820000),
    TeacherModel(name: 'Usmonov Jamshid', balance: 540000),
  ];

  late TeacherModel currentTeacher;

  @override
  void initState() {
    super.initState();
    currentTeacher = teachers.first;
  }

  int get dailyIncome =>
      groupStudents.where((s) => s.isPresent && !s.isFrozen).length *
      pricePerStudent;

  void _changeTeacher(TeacherModel teacher) {
    setState(() {
      currentTeacher = teacher;
    });
  }

  Widget _studentDrawer() {
    if (selectedStudent == null) return const SizedBox();

    final s = selectedStudent!;

    return Drawer(
      backgroundColor: AppColors.bgColor,
      width: 360,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    s.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _infoRow('Телефон', s.phone),
                  _infoRow('Тариф', s.tariff),
                  _infoRow('Баланс', '${s.balance} сум'),
                  _infoRow('Статус', s.isFrozen ? 'Заморожен' : 'Активен'),
                  _infoRow('Тариф цена', "${s.tariffPrice}"),
                  _infoRow('Скидки', "${s.discount}"),
                  _infoRow('Урок', "${s.lesson}"),
                  _infoRow('Бал', "${s.bal}"),
                  _infoRow('Дата прибытия', "${s.arrivalDate}"),
                  _infoRow('Дата активации', "${s.activationDate}"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Закрыть',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      key: _scaffoldKey,
      endDrawer: _studentDrawer(),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 24),
                _stats(),
                const SizedBox(height: 24),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Lessons(
                          students: groupStudents,
                          lessonDates: [
                            '01',
                            '03',
                            '06',
                            '08',
                            '10',
                            '13',
                            '14',
                            '15',
                            '16',
                            '18',
                            '19',
                            '10',
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: Students(
                          students: groupStudents,
                          allStudents: allCrmStudents,
                          onSelect: (student) {
                            setState(() {
                              selectedStudent = student;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          onAddStudent: (student) {
                            setState(() {
                              groupStudents.add(student);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          currentTeacher.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        PopupMenuButton<TeacherModel>(
          onSelected: _changeTeacher,
          child: ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.swap_horiz, color: Colors.black),
            label: const Text(
              'Поменять учителя',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          itemBuilder: (_) => teachers
              .map(
                (t) => PopupMenuItem(
                  value: t,
                  child: Text('${t.name} — ${t.balance} сум'),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ================= STATS =================

  Widget _stats() {
    return Row(
      children: [
        _stat('За ученика', '$pricePerStudent сум'),
        _stat('За день', '$dailyIncome сум'),
        _stat('Баланс', '${currentTeacher.balance} сум'),
      ],
    );
  }

  Widget _stat(String title, String value) {
    return Expanded(
      child: AppCard(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
