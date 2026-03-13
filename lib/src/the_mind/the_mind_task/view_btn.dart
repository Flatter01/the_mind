import 'package:flutter/material.dart';

class ViewBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final String mode;
  final String currentView;
  final ValueChanged<String> onChanged; // callback для родителя

  const ViewBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.mode,
    required this.currentView,
    required this.onChanged,
  });

  @override
  State<ViewBtn> createState() => _ViewBtnState();
}

class _ViewBtnState extends State<ViewBtn> {
  @override
  Widget build(BuildContext context) {
    final bool active = widget.currentView == widget.mode;

    return GestureDetector(
      onTap: () => widget.onChanged(widget.mode), // уведомляем родителя
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFFED6A2E) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: active ? const Color(0xFFED6A2E) : Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? const Color(0xFFED6A2E) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}