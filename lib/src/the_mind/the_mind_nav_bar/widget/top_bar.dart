import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onNotifications;
  final Function(TapDownDetails) onAddMenu;
  final Function(TapDownDetails) onTask;
  final VoidCallback onBack;
  final bool showBackButton;

  final String selectedBranch;
  final List<String> branches;
  final ValueChanged<String> onBranchChanged;
  final bool isMobile;

  const TopBar({
    super.key,
    required this.onNotifications,
    required this.onAddMenu,
    required this.onTask,
    required this.selectedBranch,
    required this.branches,
    required this.onBranchChanged,
    required this.isMobile,
    required this.onBack,
    required this.showBackButton,
  });

  void _showBranchMenu(BuildContext context, TapDownDetails details) async {
    final position = RelativeRect.fromLTRB(
      details.globalPosition.dx,
      details.globalPosition.dy,
      details.globalPosition.dx,
      0,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: branches
          .map(
            (branch) => PopupMenuItem<String>(
              value: branch,
              child: Text(
                branch,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          )
          .toList(),
    );

    if (selected != null && selected != selectedBranch) {
      onBranchChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),

          if (isMobile) const SizedBox(width: 10),
           IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          const Spacer(),

          /// 🔎 Search
          const SizedBox(width: 220,child: Padding(
            padding: EdgeInsets.all(8.0),
            child: BuildSearchBar(),
          )),

          const SizedBox(width: 20),

          /// 🏢 Branch selector
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => _showBranchMenu(context, details),
            child: Row(
              children: [
                Text(
                  selectedBranch,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),

          const SizedBox(width: 20),

          /// 📋 Tasks
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: onTask,
            child: const Icon(Icons.task_alt, color: Colors.blue, size: 24),
          ),

          const SizedBox(width: 12),

          /// 🔔 Notifications
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: onNotifications,
          ),

          const SizedBox(width: 16),

          /// ➕ Add button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: onAddMenu,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Добавить",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
