import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/analytic/analytic_item.dart';

class AnalyticCard extends StatelessWidget {
  final AnalyticItem item;

  const AnalyticCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    Color subColor = Colors.grey[500]!;

    if (item.subPositive == true) {
      subColor = const Color(0xFF2ECC8A);
    } else if (item.subPositive == false) {
      subColor = const Color(0xFFED6A2E);
    }

    return Container(
      width: 210,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                item.icon,
                size: 16,
                color: item.iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            item.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A2233),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              if (item.subPositive != null) ...[
                Icon(
                  item.subPositive!
                      ? Icons.trending_up_rounded
                      : Icons.warning_rounded,
                  size: 12,
                  color: subColor,
                ),
                const SizedBox(width: 3),
              ],
              Text(
                item.sub,
                style: TextStyle(
                  fontSize: 11,
                  color: subColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}