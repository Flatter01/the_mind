import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_task/the_mind_task_page.dart';

class ListRow extends StatefulWidget {
  final TaskModel task;
  final void Function(Offset) onStatusTap;

  const ListRow({super.key, required this.task, required this.onStatusTap});

  @override
  State<ListRow> createState() => _ListRowState();
}

class _ListRowState extends State<ListRow> {
  bool _hovered = false;

  static const _statusLabels = [
    'Нужно сделать', 'В работе', 'На проверке', 'Выполнено'
  ];
  static const _statusColors = [
    Color(0xFF6B7FD4), Color(0xFFFF9800), Color(0xFF9B59B6), Color(0xFF2ECC8A)
  ];

  @override
  Widget build(BuildContext context) {
    final t = widget.task;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) { if (!_hovered) setState(() => _hovered = true); },
      onExit: (_) { if (mounted) setState(() => _hovered = false); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _hovered ? const Color(0xFFFFFAF8) : null,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // ── Чекбокс ──
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: t.done ? const Color(0xFFED6A2E) : null,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: t.done
                      ? const Color(0xFFED6A2E)
                      : Colors.grey.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: t.done
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),

            // ── Название + описание ──
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: t.done ? Colors.grey[400] : const Color(0xFF1A2233),
                      decoration: t.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (t.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      t.description,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF8A94A6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // ── Тег ──
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: t.tagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  t.tag,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: t.tagColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            // ── Статус ──
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColors[t.status.index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        color: _statusColors[t.status.index],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _statusLabels[t.status.index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _statusColors[t.status.index],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Дедлайн ──
            Expanded(
              flex: 2,
              child: t.deadline != null
                  ? Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: t.deadlineSoon
                              ? const Color(0xFFED6A2E)
                              : Colors.grey[400],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          t.deadline!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: t.deadlineSoon
                                ? const Color(0xFFED6A2E)
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  : Text('—', style: TextStyle(fontSize: 13, color: Colors.grey[300])),
            ),

            // ── Три точки ──
            SizedBox(
              width: 40,
              child: GestureDetector(
                onTapDown: (d) => widget.onStatusTap(d.globalPosition),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: _hovered
                          ? Colors.grey.withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}