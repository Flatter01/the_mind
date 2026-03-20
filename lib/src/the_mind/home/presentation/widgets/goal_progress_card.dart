// goal_progress_card.dart
import 'package:flutter/material.dart';

const _orange = Color(0xFFED6A2E);
const _text = Color(0xFF1A2233);
const _grey = Color(0xFF8A94A6);

class GoalProgressCard extends StatefulWidget {
  const GoalProgressCard({super.key});

  @override
  State<GoalProgressCard> createState() => _GoalProgressCardState();
}

class _GoalProgressCardState extends State<GoalProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnimations;

  final List<_BarData> chartData = const [
    _BarData(value: 40, day: 'Пн'),
    _BarData(value: 70, day: 'Вт'),
    _BarData(value: 55, day: 'Ср'),
    _BarData(value: 90, day: 'Чт'),
    _BarData(value: 80, day: 'Пт'),
    _BarData(value: 110, day: 'Сб'),
    _BarData(value: 100, day: 'Вс'),
  ];

  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _barAnimations = List.generate(chartData.length, (i) {
      final start = (i / chartData.length * 0.4).clamp(0.0, 1.0);
      final end = (start + 0.6).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Пробные уроки',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _text,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Статистика за текущую неделю',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _orange.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(
                          color: _orange, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Эта неделя',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600, color: _orange),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Статистика карточки ──
          Row(
            children: [
              _StatCard(label: 'ЗАПИСАНО', value: '32', color: const Color(0xFF6B7FD4), bg: const Color(0xFFF0F1FA)),
              const SizedBox(width: 10),
              _StatCard(label: 'ПРИДУТ', value: '28', color: _orange, bg: const Color(0xFFFFF0EA)),
              const SizedBox(width: 10),
              _StatCard(label: 'ПРИШЛИ', value: '18', color: const Color(0xFF2ECC8A), bg: const Color(0xFFEAFBF3)),
              const SizedBox(width: 10),
              _StatCard(label: 'ВСЕГО', value: '124', color: Colors.white, bg: _text, isDark: true),
            ],
          ),

          const SizedBox(height: 20),

          // ── Бар-чарт ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final maxVal = chartData
                          .map((e) => e.value)
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble();

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(chartData.length, (i) {
                          final ratio = chartData[i].value / maxVal;
                          final h = ratio * 100 * _barAnimations[i].value;
                          final isHovered = _hoveredIndex == i;
                          final isLast = i == chartData.length - 1;
                          final isSecondLast = i == chartData.length - 2;

                          final color = isHovered
                              ? _orange
                              : isLast || isSecondLast
                                  ? _orange.withOpacity(isLast ? 1.0 : 0.7)
                                  : _orange.withOpacity(0.2 + (i / chartData.length) * 0.4);

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onHover: (_) => setState(() => _hoveredIndex = i),
                            onExit: (_) => setState(() => _hoveredIndex = null),
                            child: Tooltip(
                              message: '${chartData[i].day}: ${chartData[i].value}',
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 28,
                                height: h.clamp(4.0, 100.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(7),
                                  boxShadow: isHovered
                                      ? [BoxShadow(color: _orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // ── Подписи дней ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: chartData.map((d) => SizedBox(
                    width: 28,
                    child: Text(
                      d.day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _grey),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final int value;
  final String day;
  const _BarData({required this.value, required this.day});
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white.withOpacity(0.6) : color.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}