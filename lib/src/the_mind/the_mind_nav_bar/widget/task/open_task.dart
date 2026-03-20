import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/notification/notification_tile.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/models/app_notification.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/widget/task/add_task.dart';

const _orange = Color(0xFFED6A2E);

class OpenTask {
  static Future<void> openTask({
    required TapDownDetails details,
    required BuildContext context,
    required List<AppNotification> tasks,
    required VoidCallback refresh,
  }) async {
    final screenSize = MediaQuery.of(context).size;
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        screenSize.width - details.globalPosition.dx,
        screenSize.height - details.globalPosition.dy,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      items: [
        PopupMenuItem<String>(
          value: 'add',
          padding: EdgeInsets.zero,
          child: _TaskMenuItem(
            icon: Icons.add_circle_outline_rounded, // ← понятная иконка
            label: 'Добавить задачу',
          ),
        ),
        PopupMenuItem<String>(
          value: 'task',
          padding: EdgeInsets.zero,
          child: _TaskMenuItem(
            icon: Icons.format_list_bulleted_rounded, // ← понятная иконка
            label: 'Мои задачи',
          ),
        ),
      ],
    );

    if (selected == 'add') {
      await showDialog(
        context: context,
        builder: (_) => const AddTask(),
      );
    }

    if (selected == 'task') {
      await showDialog(
        context: context,
        builder: (_) => _TaskListDialog(
          tasks: tasks,
          refresh: refresh,
        ),
      );
    }
  }
}

// ─── Элемент меню ─────────────────────────────────────────────────────────────

class _TaskMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;

  const _TaskMenuItem({required this.icon, required this.label});

  @override
  State<_TaskMenuItem> createState() => _TaskMenuItemState();
}

class _TaskMenuItemState extends State<_TaskMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        if (!_hovered) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        color: _hovered ? _orange.withOpacity(0.06) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 17,
              color: _hovered ? _orange : const Color(0xFF8A94A6),
            ),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    _hovered ? FontWeight.w600 : FontWeight.normal,
                color: _hovered ? _orange : const Color(0xFF1A1F36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Диалог списка задач ──────────────────────────────────────────────────────

class _TaskListDialog extends StatefulWidget {
  final List<AppNotification> tasks;
  final VoidCallback refresh;

  const _TaskListDialog({required this.tasks, required this.refresh});

  @override
  State<_TaskListDialog> createState() => _TaskListDialogState();
}

class _TaskListDialogState extends State<_TaskListDialog> {
  String _search = '';

  List<AppNotification> get _filtered {
    if (_search.isEmpty) return widget.tasks;
    return widget.tasks
        .where((t) =>
            t.title.toLowerCase().contains(_search.toLowerCase()) ||
            t.body.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      elevation: 0,
      child: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 16, 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.12)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.format_list_bulleted_rounded,
                      color: _orange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Мои задачи',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1F36),
                        ),
                      ),
                      Text(
                        '${widget.tasks.length} задач',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF8A94A6)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close,
                        color: Colors.grey[400], size: 20),
                  ),
                ],
              ),
            ),

            // ── Поиск ──
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.2)),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF1A1F36)),
                  decoration: InputDecoration(
                    hintText: 'Поиск задач...',
                    hintStyle: const TextStyle(
                        fontSize: 13, color: Color(0xFF8A94A6)),
                    prefixIcon: Icon(Icons.search,
                        size: 18, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ── Список ──
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 460),
              child: _filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.task_outlined,
                              size: 40, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'Задач не найдено',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding:
                          const EdgeInsets.fromLTRB(28, 8, 28, 20),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) => NotificationTile(
                        notification: _filtered[i],
                        onComplete: () {
                          setState(() {
                            _filtered[i].isCompleted = true;
                          });
                          widget.refresh();
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}