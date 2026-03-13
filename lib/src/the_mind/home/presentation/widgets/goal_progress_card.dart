import 'package:flutter/material.dart';

class GoalProgressCard extends StatefulWidget {
  const GoalProgressCard({super.key});

  @override
  State<GoalProgressCard> createState() => _GoalProgressCardState();
}

class _GoalProgressCardState extends State<GoalProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnimations;

  final List<int> chartData = const [40, 70, 55, 90, 80, 110, 100];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _barAnimations = List.generate(chartData.length, (index) {
      final start = index / chartData.length * 0.4;
      final end = start + 0.6;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0, 1), end.clamp(0, 1),
              curve: Curves.easeOutCubic),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          const Text(
            "Пробные уроки",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF1A2233),
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 16),

          // Stats cards row
          _StatCardsRow(),

          const SizedBox(height: 16),

          // Bar chart
          _AnimatedBarChart(
            data: chartData,
            animations: _barAnimations,
          ),
        ],
      ),
    );
  }
}

class _StatCardsRow extends StatelessWidget {
  const _StatCardsRow();

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(
        label: "ЗАПИСАНО",
        value: "32",
        valueColor: const Color(0xFF8A9BB8),
        bgColor: const Color(0xFFF4F5F7),
      ),
      _StatItem(
        label: "ПРИДУТ",
        value: "28",
        valueColor: const Color(0xFFED6A2E),
        bgColor: const Color(0xFFFFF0EA),
      ),
      _StatItem(
        label: "ПРИШЛИ",
        value: "18",
        valueColor: const Color(0xFF2ECC8A),
        bgColor: const Color(0xFFEAFBF3),
      ),
      _StatItem(
        label: "ВСЕГО",
        value: "124",
        valueColor: Colors.white,
        bgColor: const Color(0xFF1A2233),
      ),
    ];

    return Row(
      children: stats
          .map((s) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: stats.indexOf(s) < stats.length - 1 ? 10 : 0,
                  ),
                  child: _StatCard(item: s),
                ),
              ))
          .toList(),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final Color valueColor;
  final Color bgColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.bgColor,
  });
}

class _StatCard extends StatelessWidget {
  final _StatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: item.bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.label,
            style: TextStyle(
              color: item.valueColor.withOpacity(
                item.bgColor == const Color(0xFF1A2233) ? 0.6 : 0.75,
              ),
              fontWeight: FontWeight.w600,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.value,
            style: TextStyle(
              color: item.valueColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBarChart extends StatelessWidget {
  final List<int> data;
  final List<Animation<double>> animations;

  const _AnimatedBarChart({
    required this.data,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    final barColors = [
      const Color(0xFFEAD0C5),
      const Color(0xFFE6B39A),
      const Color(0xFFE2B6A6),
      const Color(0xFFE38E6B),
      const Color(0xFFE29B7E),
      const Color(0xFFED6A2E),
      const Color(0xFFF05A14),
    ];

    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 150,
      child: AnimatedBuilder(
        animation: animations.last,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(data.length, (index) {
              final heightRatio = data[index] / maxValue;
              final animatedHeight =
                  heightRatio * 110 * animations[index].value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 28,
                    height: animatedHeight.clamp(4, 110),
                    decoration: BoxDecoration(
                      color: barColors[index],
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}