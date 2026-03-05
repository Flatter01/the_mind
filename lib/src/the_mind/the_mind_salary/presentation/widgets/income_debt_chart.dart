import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class FinanceLineChart extends StatefulWidget {
  const FinanceLineChart({super.key});

  @override
  State<FinanceLineChart> createState() => _FinanceLineChartState();
}

class _FinanceLineChartState extends State<FinanceLineChart> {
  int? activeIndex; // null = показать все линии
  bool isYearly = false; // false = месячный (дни), true = годовой (месяцы)

  int get daysInCurrentMonth {
    final now = DateTime.now();
    final firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }

  List<FlSpot> _generateDailySpots(int base) {
    return List.generate(daysInCurrentMonth, (i) {
      final y = base + (i % 10) * 4;
      return FlSpot(i.toDouble(), y.toDouble());
    });
  }

  List<FlSpot> _generateMonthlySpots(int base) {
    return List.generate(12, (i) {
      final y = base + (i % 6) * 6;
      return FlSpot(i.toDouble(), y.toDouble());
    });
  }

  // Формат для подписей дня: "15 Ян"
  String _formatDailyLabel(int dayIndex) {
    const months = [
      'Yan',
      'Fev',
      'Mar',
      'Apr',
      'May',
      'Iyn',
      'Iyl',
      'Avg',
      'Sen',
      'Okt',
      'Noy',
      'Dek',
    ];
    final now = DateTime.now();
    final month = months[now.month - 1];
    final day = dayIndex + 1;
    return "$day $month";
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + LEGEND + TOGGLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Moliyaviy ko‘rsatkichlar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  _Legend(
                    color: const Color(0xFF0EA400),
                    text: "Daromad",
                    isActive: activeIndex == null || activeIndex == 0,
                    onTap: () => _onLegendTap(0),
                  ),
                  const SizedBox(width: 14),
                  _Legend(
                    color: const Color(0xFFF33232),
                    text: "Qarz",
                    isActive: activeIndex == null || activeIndex == 1,
                    onTap: () => _onLegendTap(1),
                  ),
                  const SizedBox(width: 14),
                  _Legend(
                    color: const Color(0xFFFFB703),
                    text: "Xarajat",
                    isActive: activeIndex == null || activeIndex == 2,
                    onTap: () => _onLegendTap(2),
                  ),
                  const SizedBox(width: 20),

                  /// TOGGLE
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isYearly = !isYearly;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isYearly ? "Yillik" : "Oylik",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!isYearly)
            Text(
              "Yil: ${DateTime.now().year}", // показываем текущий год над графиком
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          const SizedBox(height: 16),

          /// CHART
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 120,
                minX: 0,
                maxX: isYearly ? 11 : (daysInCurrentMonth - 1).toDouble(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade300, dashArray: [6, 6]),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: isYearly ? 1 : 2, // через день для наглядности
                      getTitlesWidget: (value, _) {
                        if (isYearly) {
                          const months = [
                            'Yan',
                            'Fev',
                            'Mar',
                            'Apr',
                            'May',
                            'Iyn',
                            'Iyl',
                            'Avg',
                            'Sen',
                            'Okt',
                            'Noy',
                            'Dek',
                          ];

                          if (value.toInt() < 0 || value.toInt() > 11) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        } else {
                          final dayIndex = value.toInt();
                          if (dayIndex < 0 || dayIndex >= daysInCurrentMonth) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _formatDailyLabel(dayIndex),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, _) => Text(
                        "${value.toInt()} mln",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        String text = "";
                        if (spot.barIndex == 0) text = "Daromad";
                        if (spot.barIndex == 1) text = "Qarz";
                        if (spot.barIndex == 2) text = "Xarajat";

                        return LineTooltipItem(
                          "$text\n${spot.y.toInt()} mln so'm",
                          TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: spot.bar.color,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  if (activeIndex == null || activeIndex == 0)
                    _line(
                      color: const Color(0xFF0EA400),
                      spots: isYearly
                          ? _generateMonthlySpots(40)
                          : _generateDailySpots(30),
                    ),
                  if (activeIndex == null || activeIndex == 1)
                    _line(
                      color: const Color(0xFFF33232),
                      spots: isYearly
                          ? _generateMonthlySpots(20)
                          : _generateDailySpots(15),
                    ),
                  if (activeIndex == null || activeIndex == 2)
                    _line(
                      color: const Color(0xFFFFB703),
                      spots: isYearly
                          ? _generateMonthlySpots(25)
                          : _generateDailySpots(18),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLegendTap(int index) {
    setState(() {
      activeIndex = (activeIndex == index) ? null : index;
    });
  }

  LineChartBarData _line({required Color color, required List<FlSpot> spots}) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.25), color.withOpacity(0.05)],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _Legend({
    required this.color,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isActive ? 1 : 0.35,
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
