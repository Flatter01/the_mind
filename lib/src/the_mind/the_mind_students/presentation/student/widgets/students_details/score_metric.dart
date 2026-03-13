import 'package:flutter/material.dart';

class ScoreMetric extends StatelessWidget {
  final String label;
  final double score;

  const ScoreMetric({super.key, required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.4)),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(score.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score / 5.0,
                  minHeight: 6,
                  backgroundColor: Colors.grey.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFED6A2E)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}