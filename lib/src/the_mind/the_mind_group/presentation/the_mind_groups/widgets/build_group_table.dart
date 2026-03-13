import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/group_details.dart';

class BuildGroupTable extends StatelessWidget {
  final List<GroupModel> groups;

  const BuildGroupTable({super.key, required this.groups});

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
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(3), // Название группы
                  1: FlexColumnWidth(2.5), // Учитель
                  2: FlexColumnWidth(1.2), // Кол-во студентов
                  3: FlexColumnWidth(1.2), // Лимит студентов
                  4: FlexColumnWidth(1.4), // Статус
                  5: FlexColumnWidth(1.4), // Дни
                  6: FlexColumnWidth(1.4), // Время
                  7: FlexColumnWidth(1.4), // Уровень
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
            ),
          ),
        ],
      ),
    );
  }

  TableRow _tableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
      children: [
        _HeaderCell("Guruh nomi"),
        _HeaderCell("O'qituvchi"),
        _HeaderCell("O'quvchilar"),
        _HeaderCell("Limit"),
        _HeaderCell("Holati"),
        _HeaderCell("Kunlar"),
        _HeaderCell("Vaqti"),
        _HeaderCell("Level"),
        _HeaderCell(""),
      ],
    );
  }

  TableRow _tableRow(BuildContext context, int index, GroupModel g) {
    final bool isActive = g.isActive ?? false;
    final Color statusColor = isActive ? Colors.green : Colors.grey;

    return TableRow(
      children: [
        _touch(context, _cell(g.name ?? '', bold: true, color: _groupColor(g))),
        _touch(context, _cell(g.teacher ?? '')),
        _touch(context, _cell((g.studentCount ?? 0).toString())),
        _touch(context, _cell((g.room ?? 0).toString())), // Используем room как limit
        _touch(context, _cell(isActive ? 'Active' : 'Finished', bold: true, color: statusColor)),
        _touch(context, _cell(g.weekDays?.toString() ?? '')),
        _touch(context, _cell("${g.startTime ?? ''} - ${g.endTime ?? ''}")),
        _touch(context, _cell(g.level ?? '')),
        _menu(context, index),
      ],
    );
  }

  Color _groupColor(GroupModel g) {
    switch (g.level) {
      case 'beginner':
        return AppColors.mainColor;
      case 'individual':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Widget _menu(BuildContext context, int index) {
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
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'details', child: Text("Ochish")),
          ],
        ),
      ),
    );
  }

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