import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/group_details.dart';

class BuildGroupTable extends StatefulWidget {
  final List<GroupModel> groups;

  const BuildGroupTable({super.key, required this.groups});

  @override
  State<BuildGroupTable> createState() => _BuildGroupTableState();
}

class _BuildGroupTableState extends State<BuildGroupTable> {
  late List<GroupModel> groups;

  @override
  void initState() {
    super.initState();
    groups = List.from(widget.groups);
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Guruhlar ro'yxati",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3), // Название группы — самая длинная
              1: FlexColumnWidth(2.5), // Учитель — тоже длинная
              2: FlexColumnWidth(1.2), // Кол-во студентов — короткое число
              3: FlexColumnWidth(1.2), // Лимит студентов — короткое число
              4: FlexColumnWidth(1.4), // Статус — средняя ширина
              5: FlexColumnWidth(1.2), // Тип недели — короткий
              6: FlexColumnWidth(1.4), // Время — чуть шире
              7: FlexColumnWidth(1.4), // Level + Stage — средняя ширина
              8: FixedColumnWidth(50), // Меню
            },

            border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.black12),
            ),
            children: [
              _tableHeader(),
              ...groups.asMap().entries.map(
                (entry) => _tableRow(context, entry.key, entry.value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------

  TableRow _tableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
      children: [
        _HeaderCell("Guruh nomi"),
        _HeaderCell("O'qituvchi"),
        _HeaderCell("O'quvchilar"),
        _HeaderCell("O'quvchilar Limit"),
        _HeaderCell("Holati"),
        _HeaderCell("Haftalar"),
        _HeaderCell("Vaqti"),
        _HeaderCell("Level"),
        _HeaderCell(""),
      ],
    );
  }

  // ---------------- ROW ----------------

  TableRow _tableRow(BuildContext context, int index, GroupModel g) {
    final bool isActive = g.status == GroupStatus.active;
    final Color statusColor = isActive ? Colors.green : Colors.grey;

    return TableRow(
      children: [
        _touch(context, _cell(g.name, bold: true, color: _groupColor(g))),
        _touch(context, _cell(g.teacher)),
        _touch(context, _cell(g.students.toString())),
        _touch(context, _cell(g.studentsLimit.toString())),
        _touch(context, _cell(g.status.label, bold: true, color: statusColor)),
        _touch(context, _cell(g.weekType.label)),
        _touch(context, _cell(g.lessonTime)),

        // 👇 Level + Stage
        _touch(context, _cell("${g.level.label} ${g.levelStage}", bold: true)),

        _menu(context, g, index),
      ],
    );
  }

  Color _groupColor(GroupModel g) {
    if (g.level == GroupLevel.beginner) {
      return AppColors.mainColor; // оранжевый
    } else if (g.level == GroupLevel.individual) {
      return Colors.green; // индивидуальные
    } else {
      return Colors.blue; // остальные
    }
  }

  // ---------------- MENU ----------------

  Widget _menu(BuildContext context, GroupModel g, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: AppColors.bgColor,
          icon: const Icon(Icons.more_horiz, color: Colors.grey),
          onSelected: (value) {
            if (value == 'details') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GroupDetails()),
              );
            } else if (value == 'delete') {
              setState(() {
                groups.removeAt(index);
              });
            } else if (value.startsWith('level_')) {
              final newLevel = GroupLevel.values.firstWhere(
                (e) => e.name == value.split('_')[1],
              );

              setState(() {
                groups[index] = groups[index].copyWith(level: newLevel);
              });
            } else if (value.startsWith('stage_')) {
              final newStage = int.parse(value.split('_')[1]);

              setState(() {
                groups[index] = groups[index].copyWith(levelStage: newStage);
              });
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'details', child: Text("Ochish")),
            const PopupMenuItem(value: 'delete', child: Text("O‘chirish")),

            const PopupMenuDivider(),
            const PopupMenuItem(enabled: false, child: Text("Level")),

            ...GroupLevel.values.map(
              (level) => PopupMenuItem(
                value: 'level_${level.name}',
                child: Text(level.label),
              ),
            ),

            const PopupMenuDivider(),
            const PopupMenuItem(enabled: false, child: Text("Stage")),

            ...List.generate(
              5,
              (index) => PopupMenuItem(
                value: 'stage_${index + 1}',
                child: Text("Stage ${index + 1}"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TAP ----------------

  Widget _touch(BuildContext context, Widget child) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GroupDetails()),
        );
      },
      child: child,
    );
  }

  // ---------------- CELL ----------------

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

// ---------------- HEADER CELL ----------------

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
