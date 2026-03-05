import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/home/data/models/build_debtors_table_models.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';

class BuildDebtorsTable extends StatelessWidget {
  final List<BuildDebtorsTableModels> students;
  final Function(BuildDebtorsTableModels) onToggleCalled;
  final Function(BuildDebtorsTableModels) onMarkPaid;

  const BuildDebtorsTable({
    super.key,
    required this.students,
    required this.onToggleCalled,
    required this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    final debtors = students.where((e) => e.balance != "0").toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Qarzdor o‘quvchilar (${debtors.length})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          if (debtors.isEmpty)
            const Text("Qarzdorlar yo‘q"),

          if (debtors.isNotEmpty)
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2.2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1.6),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(1.4), // qarz
                5: FlexColumnWidth(1.4), // call status
                6: FixedColumnWidth(50),
              },
              border: const TableBorder(
                horizontalInside: BorderSide(color: Colors.black12),
              ),
              children: [
                _header(),
                ...debtors.map((e) => _row(context, e)),
              ],
            ),
        ],
      ),
    );
  }

  // ---------- HEADER ----------

  TableRow _header() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
      children: [
        _HeaderCell("Ism"),
        _HeaderCell("Telefon"),
        _HeaderCell("O‘qituvchi"),
        _HeaderCell("Guruh"),
        _HeaderCell("Qarz"),
        _HeaderCell("Qo‘ng‘iroq"),
        _HeaderCell(""),
      ],
    );
  }

  // ---------- ROW ----------

  TableRow _row(BuildContext context, BuildDebtorsTableModels s) {
    final callColor = s.called ? Colors.green : Colors.red;

    return TableRow(
      children: [
        _tap(context, _cell(s.name, bold: true)),
        _tap(context, _cell(s.phone)),
        _tap(context, _cell(s.teacher)),
        _tap(context, _cell(s.group)),
        _tap(
          context,
          _cell(s.balance, bold: true, color: Colors.red),
        ),
        _cell(
          s.called ? "Pozvonili" : "Ne pozvonili",
          bold: true,
          color: callColor,
        ),
        _menu(s),
      ],
    );
  }

  // ---------- MENU ----------

  Widget _menu(BuildDebtorsTableModels s) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz),
      onSelected: (v) {
        if (v == 'open') {
          debugPrint("Open ${s.name}");
        } else if (v == 'toggle_call') {
          onToggleCalled(s);
        } else if (v == 'paid') {
          onMarkPaid(s);
        }
      },
      itemBuilder: (_) => [
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
        const PopupMenuItem(
          value: 'paid',
          child: Text("To‘landi deb belgilash"),
        ),
      ],
    );
  }

  // ---------- TAP ----------

  Widget _tap(BuildContext context, Widget child) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const StudentDetailsPage(),
          ),
        );
      },
      child: child,
    );
  }

  // ---------- CELL ----------

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

// ---------- HEADER CELL ----------

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
        ),
      ),
    );
  }
}
