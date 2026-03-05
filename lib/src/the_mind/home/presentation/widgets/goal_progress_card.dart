import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class GoalProgressCard extends StatelessWidget {
  final double goal;
  final double collected;
  final double progressRaw;
  final double progressBarValue;
  final VoidCallback onTap;

  const GoalProgressCard({
    required this.goal,
    required this.collected,
    required this.progressRaw,
    required this.progressBarValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// суммы
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Maqsad", style: TextStyle(color: Colors.grey[600])),
                Text(
                  "${goal.toStringAsFixed(0)} so'm",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Olingan",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                Text(
                  "${collected.toStringAsFixed(0)} so'm",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// прогресс бар
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressBarValue,
                minHeight: 18,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.green),
              ),
            ),

            const SizedBox(height: 10),

            /// проценты
            Text(
              "Progress: ${(progressRaw * 100).toStringAsFixed(1)}%",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            /// если больше 100%
            if (progressRaw > 1) ...[
              const SizedBox(height: 4),
              Text(
                "Reja bajarildi +${((progressRaw - 1) * 100).toStringAsFixed(1)}%",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
