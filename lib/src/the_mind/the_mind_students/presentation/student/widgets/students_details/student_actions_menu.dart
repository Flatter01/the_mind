import 'package:flutter/material.dart';

class StudentActionsMenu extends StatelessWidget {
  const StudentActionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<_StudentAction>(
        tooltip: 'Actions',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: _StudentAction.freeze,
            child: _Item(icon: Icons.pause_circle, text: 'Заморозить'),
          ),
          PopupMenuItem(
            value: _StudentAction.editAbonement,
            child: _Item(
              icon: Icons.payments_outlined,
              text: 'Править абонемент',
            ),
          ),
          PopupMenuItem(
            value: _StudentAction.changePeriod,
            child: _Item(
              icon: Icons.access_time,
              text: 'Изменить период участника',
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: _StudentAction.report,
            child: _Item(icon: Icons.bar_chart, text: 'Отчет посещаемости'),
          ),
          PopupMenuItem(
            value: _StudentAction.withdraw,
            child: _Item(icon: Icons.remove_circle_outline, text: 'Списание'),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: _StudentAction.transfer,
            child: _Item(
              icon: Icons.sync_alt,
              text: 'Перевести в другую группу',
            ),
          ),
          PopupMenuItem(
            value: _StudentAction.delete,
            child: _Item(
              icon: Icons.delete_outline,
              text: 'Удалить из группы',
              isDanger: true,
            ),
          ),
        ],
        onSelected: (value) {
          // TODO: обработка действий
        },
        child: Icon(Icons.more_horiz),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDanger;

  const _Item({required this.icon, required this.text, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : Colors.black87;

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}

enum _StudentAction {
  freeze,
  editAbonement,
  changePeriod,
  report,
  withdraw,
  transfer,
  delete,
}
