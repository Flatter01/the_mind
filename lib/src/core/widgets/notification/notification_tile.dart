import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/models/app_notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onComplete;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isTask = notification.type == NotificationType.task;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              _IconCircle(
                icon: isTask ? Icons.task_alt : Icons.message,
                color: isTask ? Colors.blue : Colors.purple,
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  notification.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (isTask) _StatusChip(notification.isCompleted),
            ],
          ),

          const SizedBox(height: 6),

          /// FROM / TO
          if (notification.fromUserId != null ||
              notification.toUserId != null)
            Row(
              children: [
                if (notification.fromUserId != null)
                  Text(
                    "От: ${notification.fromUserId}",
                    style: theme.textTheme.bodySmall,
                  ),
                if (notification.toUserId != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    "Кому: ${notification.toUserId}",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),

          const SizedBox(height: 8),

          /// BODY
          Text(
            notification.body,
            style: theme.textTheme.bodyMedium,
          ),

          /// DEADLINE
          if (isTask && notification.deadline != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Срок: ${_formatDate(notification.deadline!)}",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
          ],

          /// BUTTON
          if (isTask && !notification.isCompleted) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check),
                label: const Text("Выполнено"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}."
        "${date.month.toString().padLeft(2, '0')}."
        "${date.year}  "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  }
}

/// ICON CIRCLE
class _IconCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconCircle({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

/// STATUS CHIP
class _StatusChip extends StatelessWidget {
  final bool isCompleted;

  const _StatusChip(this.isCompleted);

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? "Выполнено" : "В процессе",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
