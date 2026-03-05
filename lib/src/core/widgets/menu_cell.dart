import 'package:flutter/material.dart';

class MenuCell extends StatelessWidget {
  final List<PopupMenuEntry<String>> menuItems;
  final void Function(String)? onSelected;
  const MenuCell({
    super.key,
    required this.menuItems,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz),
          onSelected: onSelected,
          itemBuilder: (_) => menuItems,
        ),
      ),
    );
  }
}
