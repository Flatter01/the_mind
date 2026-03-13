import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const HistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item['color'] as Color;
    final icon = item['icon'] as IconData;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['date'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.4)),
                const SizedBox(height: 2),
                Text(item['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                const SizedBox(height: 2),
                Text(item['description'], style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}