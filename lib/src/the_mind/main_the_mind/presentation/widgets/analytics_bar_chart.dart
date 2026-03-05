import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class AnalyticsBarChart extends StatelessWidget {
  const AnalyticsBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Активность за неделю",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: 20),
          SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = ["Jun 26","Jun 27","Jun 28","Jun 29","Jun 30","Jul 1","Jul 2"];
                        return Text(days[value.toInt()],
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary));
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(7, (i) {
                  final values = [2, 5, 8, 5, 10, 4, 3];
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i].toDouble(),
                        width: 22,
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4C6FFF), Color(0xFF6B8CFF)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
