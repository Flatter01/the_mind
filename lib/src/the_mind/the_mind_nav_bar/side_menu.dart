import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class SideMenu extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final ValueChanged<int?> onStudentSubTap;
  final bool isMobile;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.onStudentSubTap,
    required this.isMobile,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final items = const [
    _MenuItem(Icons.home, "Home"),
    _MenuItem(Icons.bar_chart_outlined, "Analytics"),
    _MenuItem(Icons.people_outline_outlined, "Lid"),
    _MenuItem(Icons.people_outline, "Students"),
    _MenuItem(Icons.groups_2_outlined, "Group"),
    _MenuItem(Icons.menu_book_outlined, "Exam"),
    _MenuItem(Icons.school_outlined, "Teacher"),
    _MenuItem(Icons.task, "Task"),
    _MenuItem(Icons.badge_outlined, "Workers"),
    _MenuItem(Icons.payments_outlined, "Salary"),
    _MenuItem(Icons.receipt_long_outlined, "Transactions"),
    _MenuItem(Icons.settings_outlined, "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    final isCollapsed =
        !widget.isMobile && MediaQuery.of(context).size.width < 1200;

    return Container(
      width: widget.isMobile ? double.infinity : (isCollapsed ? 72 : 240),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            /// LOGO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFED6A2E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.psychology_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  if (!isCollapsed || widget.isMobile) ...[
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "The Mind",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A2233),
                          ),
                        ),
                        Text(
                          "Admin Dashboard",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// MENU
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    return _buildMenuItem(
                      items[i],
                      i,
                      isCollapsed && !widget.isMobile,
                    );
                  },
                ),
              ),
            ),

            /// BOTTOM PROFILE
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF1A2233),
                    child: Text(
                      "A",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (!isCollapsed || widget.isMobile) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Alex Rivera",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF1A2233),
                            ),
                          ),
                          Text(
                            "Super Admin",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.settings_outlined,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item, int index, bool collapsed) {
    final isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        widget.onStudentSubTap(null);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.symmetric(
          horizontal: collapsed ? 0 : 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFED6A2E).withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment:
              collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              size: 20,
              color: isSelected
                  ? const Color(0xFFED6A2E)
                  : const Color(0xFF8A9BB8),
            ),
            if (!collapsed) ...[
              const SizedBox(width: 12),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFFED6A2E)
                      : const Color(0xFF4A5568),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;

  const _MenuItem(this.icon, this.title);
}