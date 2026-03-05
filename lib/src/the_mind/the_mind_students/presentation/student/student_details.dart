import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/student_history.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/students_exams.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/students_main_info.dart';

class StudentDetailsPage extends StatefulWidget {
  final StudentModel student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

enum StudentStatus { trial, active, inactive }

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  String abonementName = "Individual";
  int abonementPrice = 2200000;
  int discountPercent = 0;

  // ===== SECONDARY DATA =====
  final List<Map<String, dynamic>> groups = const [
    {
      "title": "English A2",
      "teacher": "Sara Milton",
      "attendance": 82,
      "period": "Jan 2024 – Now",
    },
    {
      "title": "English A1",
      "teacher": "Daniel Ford",
      "attendance": 91,
      "period": "Sep 2023 – Dec 2023",
    },
  ];

  final List<Map<String, dynamic>> exams = const [
    {
      "name": "Grammar Test",
      "score": 84,
      "date": "10 Jan 2024",
      'teacher': "Ali Aliev",
    },
    {
      "name": "Speaking Exam",
      "score": 76,
      "date": "02 Feb 2024",
      'teacher': "Aziz Azizev",
    },
    {
      "name": "Listening Test",
      "score": 92,
      "date": "14 Feb 2024",
      'teacher': "Aziz Azizev",
    },
  ];

  final List<Map<String, dynamic>> history = const [
    {
      "type": "group_add",
      "title": "Added to group",
      "description": "Student was added to English A2",
      "date": "05 Jan 2024",
    },
    {
      "type": "payment",
      "title": "Payment received",
      "description": "150,000 UZS paid for January",
      "date": "06 Jan 2024",
    },
    {
      "type": "absence",
      "title": "Absent",
      "description": "Student was absent (no reason)",
      "date": "12 Jan 2024",
    },
    {
      "type": "payment",
      "title": "Payment received",
      "description": "150,000 UZS paid for February",
      "date": "05 Feb 2024",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f5f7),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 360,
                  child: StudentsMainInfo(
                    lastName: widget.student.lastName ?? "",
                    firstName: widget.student.firstName ?? "",
                    gender: widget.student.gender ?? "",
                    birthDate:widget.student.birthDate ?? "",
                    phone:widget.student.phone ?? "",
                    balance:widget.student.balance,
                    currentGroup:widget.student.groupName ?? "",
                    abonementName: abonementName,
                    abonementPrice: abonementPrice,
                    discountAmount: discountPercent,
                    statusDisplay: widget.student.statusDisplay,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StudentsExams(exams: exams),
                        const SizedBox(height: 20),
                        StudentHistory(history: history),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
