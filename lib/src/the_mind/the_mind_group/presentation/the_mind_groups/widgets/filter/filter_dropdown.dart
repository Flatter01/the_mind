import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  const FilterDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.containsKey(value) ? value : null,
          hint: Text(hint, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          icon: Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text('Все', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ),
            ...items.entries.map(
              (e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value, style: const TextStyle(fontSize: 13)),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}