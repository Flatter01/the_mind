import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';

class BuildStudentsTable extends StatelessWidget {
  final List<StudentModel> students;

  const BuildStudentsTable({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "O'quvchilar ro'yxati",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1.2),
              6: FixedColumnWidth(50),
            },
            border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.black12),
            ),
            children: [
              _tableHeader(),
              ...students.map((s) => _tableRow(s, context)),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- HEADER ----------------
  TableRow _tableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
      children: [
        _HeaderCell("Ismi Familiyasi"),
        _HeaderCell("Telefon"),
        _HeaderCell("Guruh"),
        _HeaderCell("O'qituvchi"),
        _HeaderCell("Balans"),
        _HeaderCell("Holati"),
        _HeaderCell(""),
      ],
    );
  }

  /// ---------------- ROW ----------------
  TableRow _tableRow(StudentModel s, BuildContext context) {
    final bool isDebtor = s.status.toLowerCase() == "qarzdor";
    final bool isTrial =
        s.status.toLowerCase() == "trial" ||
        s.status.toLowerCase() == "probniy dars" ||
        s.status.toLowerCase() == "пробный урок";

    Color statusColor;
    if (isDebtor) {
      statusColor = Colors.red;
    } else if (isTrial) {
      statusColor = Colors.amber;
    } else {
      statusColor = Colors.green;
    }

    return TableRow(
      children: [
        _touch(context, _cell("${s.lastName}${s.firstName}"), s),
        _touch(context, _cell(s.phone ?? ""), s),
        _touch(context, _cell(s.groupName ?? ""), s),
        _touch(context, _cell(s.teacherName ?? ""), s),
        _touch(
          context,
          _cell(
            s.balance,
            color: isDebtor ? Colors.redAccent : const Color(0xFF0EA400),
          ),
          s,
        ),
        _touch(context, _cell(s.status, bold: true, color: statusColor), s),

        /// ----------- MENU -----------
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Align(
            alignment: Alignment.center,
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: AppColors.bgColor,
              icon: const Icon(Icons.more_horiz, color: Colors.grey),
              onSelected: (value) {
                if (value == 'delete') {
                  debugPrint("O'chirish: ${s.lastName}${s.firstName}");
                } else if (value == 'blacklist') {
                  debugPrint("Muzlash: ${s.lastName}${s.firstName}");
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'delete', child: Text("O'chirish")),
                PopupMenuItem(value: 'blacklist', child: Text("Muzlash")),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _touch(BuildContext context, Widget child, StudentModel student) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDetailsPage(student: student),
          ),
        );
      },
      child: child,
    );
  }

  /// ---------------- CELL ----------------
  Widget _cell(String text, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: color ?? Colors.black87,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

/// ---------------- HEADER CELL ----------------
class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
