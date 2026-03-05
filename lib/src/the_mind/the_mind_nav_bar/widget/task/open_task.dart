import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/notification/notification_tile.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/models/app_notification.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/widget/task/add_task.dart';

class OpenTask {
  static Future<void> openTask({
   required TapDownDetails details,
   required BuildContext context,
   required List<AppNotification> tasks,
   required VoidCallback refresh,
  }
  ) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        0,
        0,
      ),
      items: const [
        PopupMenuItem(
          value: 'add',
          child: Row(
            children: [
              Icon(Icons.add, size: 18),
              SizedBox(width: 8),
              Text("Добавить задачу"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'task',
          child: Row(
            children: [
              Icon(Icons.task, size: 18),
              SizedBox(width: 8),
              Text("Задачу"),
            ],
          ),
        ),
      ],
    );

    if (selected == 'add') {
      await showDialog(
        context: context,
        builder: (_) {
          return AddTask();
        },
      );
    }

    if (selected == 'task') {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Задачи"),
          backgroundColor: AppColors.bgColor,
          content: SizedBox(
            width: 400,
            height: 500, // важно задать высоту
            child: Column(
              children: [
                const BuildSearchBar(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: NotificationTile(
                        notification: tasks[i],
                        onComplete: () {
                          tasks[i].isCompleted = true;
                          refresh;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
