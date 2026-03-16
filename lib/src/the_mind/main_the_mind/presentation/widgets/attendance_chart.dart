import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import '../../domain/attendance_entity.dart';

class AttendanceChart extends StatefulWidget {
  final List<AttendanceEntity> data;

  const AttendanceChart({super.key, required this.data});

  @override
  State<AttendanceChart> createState() => _AttendanceChartState();
}

class _AttendanceChartState extends State<AttendanceChart> {
  bool showAbsentOnly = false;
  bool showAttendedOnly = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Oxirgi 30 kun ichida davomad",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 320,
            child: BarChart(
              BarChartData(
                barGroups: _buildBars(),
                barTouchData: _buildTouchData(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: _buildTitles(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _legend(
                Colors.orange,
                "Absent",
                isActive: showAbsentOnly,
                onTap: () {
                  setState(() {
                    showAbsentOnly = !showAbsentOnly;
                    showAttendedOnly = false;
                  });
                },
              ),
              const SizedBox(width: 16),
              _legend(
                Colors.orangeAccent,
                "Attended",
                isActive: showAttendedOnly,
                onTap: () {
                  setState(() {
                    showAttendedOnly = !showAttendedOnly;
                    showAbsentOnly = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Tooltip ----------
  BarTouchData _buildTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.all(8),
        tooltipMargin: 8,
        getTooltipColor: (group) => Colors.black87,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final item = widget.data[group.x];
          final date = item.date;
          final value = rod.toY.toInt();

          final type = rodIndex == 0 ? "Absent" : "Attended";

          return BarTooltipItem(
            "$type\n${date.day}.${date.month}.${date.year}\n$value",
            const TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }

  // ---------- Titles ----------
  FlTitlesData _buildTitles() {
    return FlTitlesData(
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          getTitlesWidget: (value, _) => Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: _bottomTitle,
          reservedSize: 42,
        ),
      ),
    );
  }

  // ---------- X-axis labels ----------
  Widget _bottomTitle(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= widget.data.length) {
      return const SizedBox.shrink();
    }

    final d = widget.data[index].date;
    return Transform.rotate(
      angle: -0.9,
      child: Text("${d.day}.${d.month}", style: const TextStyle(fontSize: 10)),
    );
  }

  // ---------- Bars ----------
  List<BarChartGroupData> _buildBars() {
    return List.generate(widget.data.length, (i) {
      final item = widget.data[i];

      final showAbsent = showAttendedOnly ? 0.0 : item.absent.toDouble();
      final showAttended = showAbsentOnly ? 0.0 : item.attended.toDouble();

      return BarChartGroupData(
        x: i,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: showAbsent,
            width: 10,
            color: Colors.orange,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: showAttended,
            width: 10,
            color: Colors.orangeAccent[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  // ---------- Legend with hover ----------
  Widget _legend(
    Color color,
    String text, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
