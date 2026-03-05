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
  bool isStudentsOpen = false;
  int? selectedStudentSubIndex;

  final items = const [
    _MenuItem(Icons.home, "Home"),
    _MenuItem(Icons.bar_chart_outlined, "Analytics"),
    _MenuItem(Icons.people_outline_outlined, "Lid"),
    _MenuItem(Icons.people_outline, "Students"),
    _MenuItem(Icons.groups_2_outlined, "Group"),
    _MenuItem(Icons.menu_book_outlined, "Exam"),
    _MenuItem(Icons.school_outlined, "Teacher"),
    _MenuItem(Icons.badge_outlined, "Workers"),
    _MenuItem(Icons.payments_outlined, "Salary"),
    _MenuItem(Icons.receipt_long_outlined, "Transactions"),
    _MenuItem(Icons.person_outline, "Profile"),
    _MenuItem(Icons.settings_outlined, "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    final isCollapsed =
        !widget.isMobile && MediaQuery.of(context).size.width < 1200;

    return Container(
      width: widget.isMobile
          ? double
                .infinity // 📱 Drawer занимает всю ширину
          : (isCollapsed ? 90 : 260), // 💻 Web

      decoration: BoxDecoration(
        color: AppColors.bgColor,
        border: widget.isMobile
            ? null
            : Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Text(
              isCollapsed && !widget.isMobile ? "T/M" : "THE MIND",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => _buildMenuItem(
                  items[i],
                  i,
                  isCollapsed && !widget.isMobile,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item, int index, bool collapsed) {
    final isSelected = widget.selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        widget.onTap(index);
        widget.onStudentSubTap(null);

        setState(() {
          selectedStudentSubIndex = null;
          isStudentsOpen = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: collapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            if (!collapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
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
