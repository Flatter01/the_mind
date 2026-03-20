import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import '../../domain/attendance_entity.dart';

const _orange = Color(0xFFED6A2E);
const _orangeLight = Color(0xFFFFF3EE);
const _bg = Color(0xFFF7F8FA);
const _border = Color(0xFFE8EAF0);
const _text = Color(0xFF1A1F36);
const _grey = Color(0xFF8A94A6);

class AttendanceChart extends StatefulWidget {
  final List<AttendanceEntity> data;
  const AttendanceChart({super.key, required this.data});

  @override
  State<AttendanceChart> createState() => _AttendanceChartState();
}

class _AttendanceChartState extends State<AttendanceChart> {
  bool _showAbsentOnly = false;
  bool _showAttendedOnly = false;
  int? _hoveredIndex;

  int get _totalAbsent =>
      widget.data.fold(0, (s, e) => s + e.absent);
  int get _totalAttended =>
      widget.data.fold(0, (s, e) => s + e.attended);
  double get _attendanceRate {
    final total = _totalAbsent + _totalAttended;
    if (total == 0) return 0;
    return (_totalAttended / total * 100);
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(28),
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
                    'Посещаемость',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Последние 30 дней',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // ── Статистика ──
              _StatBadge(
                label: 'Присутствовали',
                value: '$_totalAttended',
                color: const Color(0xFF2ECC8A),
              ),
              const SizedBox(width: 12),
              _StatBadge(
                label: 'Пропустили',
                value: '$_totalAbsent',
                color: _orange,
              ),
              const SizedBox(width: 12),
              _StatBadge(
                label: 'Посещаемость',
                value: '${_attendanceRate.toStringAsFixed(1)}%',
                color: const Color(0xFF6B7FD4),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Легенда + фильтры ──
          Row(
            children: [
              _LegendButton(
                color: _orange,
                label: 'Пропустили',
                isActive: _showAbsentOnly,
                onTap: () => setState(() {
                  _showAbsentOnly = !_showAbsentOnly;
                  _showAttendedOnly = false;
                }),
              ),
              const SizedBox(width: 10),
              _LegendButton(
                color: const Color(0xFF2ECC8A),
                label: 'Присутствовали',
                isActive: _showAttendedOnly,
                onTap: () => setState(() {
                  _showAttendedOnly = !_showAttendedOnly;
                  _showAbsentOnly = false;
                }),
              ),
              const Spacer(),
              if (_showAbsentOnly || _showAttendedOnly)
                GestureDetector(
                  onTap: () => setState(() {
                    _showAbsentOnly = false;
                    _showAttendedOnly = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.close,
                            size: 13, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Сбросить',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // ── График ──
          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                barGroups: _buildBars(),
                barTouchData: _buildTouchData(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: _buildTitles(),
                maxY: _maxY + 2,
              ),
              swapAnimationDuration:
                  const Duration(milliseconds: 300),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  double get _maxY {
    double max = 0;
    for (final item in widget.data) {
      if (item.absent > max) max = item.absent.toDouble();
      if (item.attended > max) max = item.attended.toDouble();
    }
    return max;
  }

  BarTouchData _buildTouchData() {
    return BarTouchData(
      enabled: true,
      touchCallback: (event, response) {
        setState(() {
          if (response?.spot != null) {
            _hoveredIndex = response!.spot!.touchedBarGroupIndex;
          } else {
            _hoveredIndex = null;
          }
        });
      },
      touchTooltipData: BarTouchTooltipData(
        tooltipRoundedRadius: 12,
        tooltipPadding: const EdgeInsets.all(12),
        tooltipMargin: 10,
        getTooltipColor: (_) => const Color(0xFF1A1F36),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final item = widget.data[group.x];
          final d = item.date;
          final value = rod.toY.toInt();
          final isAbsent = rodIndex == 0;

          return BarTooltipItem(
            '${isAbsent ? "🔴 Пропустили" : "🟢 Присутствовали"}\n'
            '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}\n'
            '$value чел.',
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      rightTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (value, _) => Text(
            value.toInt().toString(),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: _bottomTitle,
          reservedSize: 40,
        ),
      ),
    );
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= widget.data.length) {
      return const SizedBox.shrink();
    }
    // Показываем каждые 5 дней
    if (index % 5 != 0) return const SizedBox.shrink();

    final d = widget.data[index].date;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}',
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[400],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBars() {
    return List.generate(widget.data.length, (i) {
      final item = widget.data[i];
      final isHovered = _hoveredIndex == i;

      final absentVal =
          _showAttendedOnly ? 0.0 : item.absent.toDouble();
      final attendedVal =
          _showAbsentOnly ? 0.0 : item.attended.toDouble();

      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: absentVal,
            width: 8,
            color: isHovered
                ? _orange
                : _orange.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: attendedVal,
            width: 8,
            color: isHovered
                ? const Color(0xFF2ECC8A)
                : const Color(0xFF2ECC8A).withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }
}

// ─── Статистика бейдж ─────────────────────────────────────────────────────────

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: _grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Кнопка легенды ───────────────────────────────────────────────────────────

class _LegendButton extends StatefulWidget {
  final Color color;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _LegendButton({
    required this.color,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_LegendButton> createState() => _LegendButtonState();
}

class _LegendButtonState extends State<_LegendButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        if (!_hovered) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: active
                ? widget.color.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active
                  ? widget.color.withOpacity(0.3)
                  : _border,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: active
                      ? widget.color
                      : widget.color.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: active ? widget.color : _grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}