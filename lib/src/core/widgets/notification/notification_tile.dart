import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/models/app_notification.dart';

const _orange = Color(0xFFED6A2E);
const _bg = Color(0xFFF7F8FA);
const _border = Color(0xFFE8EAF0);
const _text = Color(0xFF1A1F36);
const _grey = Color(0xFF8A94A6);

class NotificationTile extends StatefulWidget {
  final AppNotification notification;
  final VoidCallback onComplete;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onComplete,
  });

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _hovered = false;

  bool get _isTask =>
      widget.notification.type == NotificationType.task;

  Color get _typeColor =>
      _isTask ? _orange : const Color(0xFF6B7FD4);

  IconData get _typeIcon =>
      _isTask ? Icons.task_alt_rounded : Icons.message_outlined;

  @override
  Widget build(BuildContext context) {
    final n = widget.notification;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFFFFFAF8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? _orange.withOpacity(0.2)
                : _border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.07 : 0.04),
              blurRadius: _hovered ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              children: [
                // Иконка типа
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_typeIcon, color: _typeColor, size: 20),
                ),
                const SizedBox(width: 12),

                // Заголовок
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      if (n.deadline != null) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 12,
                              color: _isDeadlineSoon(n.deadline!)
                                  ? _orange
                                  : _grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Срок: ${_formatDate(n.deadline!)}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _isDeadlineSoon(n.deadline!)
                                    ? _orange
                                    : _grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Статус чип
                if (_isTask) _buildStatusChip(n.isCompleted),
              ],
            ),

            // ── От кого / Кому ──
            if (n.fromUserId != null || n.toUserId != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (n.fromUserId != null) ...[
                      const Icon(Icons.person_outline,
                          size: 13, color: _grey),
                      const SizedBox(width: 5),
                      Text(
                        'От: ${n.fromUserId}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (n.fromUserId != null && n.toUserId != null)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          width: 1,
                          height: 12,
                          color: _border,
                        ),
                      ),
                    if (n.toUserId != null) ...[
                      const Icon(Icons.arrow_forward_outlined,
                          size: 13, color: _grey),
                      const SizedBox(width: 5),
                      Text(
                        'Кому: ${n.toUserId}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // ── Тело ──
            const SizedBox(height: 12),
            Text(
              n.body,
              style: const TextStyle(
                fontSize: 13,
                color: _text,
                height: 1.5,
              ),
            ),

            // ── Кнопка выполнено ──
            if (_isTask && !n.isCompleted) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: widget.onComplete,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _orange,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: _orange.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded,
                              size: 15, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Выполнено',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isCompleted) {
    final color = isCompleted
        ? const Color(0xFF2ECC8A)
        : _orange;
    final label = isCompleted ? 'Выполнено' : 'В процессе';
    final icon = isCompleted
        ? Icons.check_circle_outline
        : Icons.timelapse_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  bool _isDeadlineSoon(DateTime deadline) {
    final diff = deadline.difference(DateTime.now()).inHours;
    return diff < 24 && diff >= 0;
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}  '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}