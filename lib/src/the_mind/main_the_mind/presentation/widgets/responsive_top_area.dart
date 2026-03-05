import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class ResponsiveFunnelChart extends StatelessWidget {
  const ResponsiveFunnelChart({
    super.key,
    required this.funnelCounts,
    required this.funnelColors,
  });

  final Map<String, int> funnelCounts;
  final List<Color> funnelColors;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff6f7fb),
        borderRadius: BorderRadius.circular(18),
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(child: _FunnelCard(funnelCounts, funnelColors)),
                const SizedBox(width: 16),
                Expanded(child: _PieCard(funnelCounts, funnelColors)),
              ],
            )
          : Column(
              children: [
                _FunnelCard(funnelCounts, funnelColors),
                const SizedBox(height: 16),
                _PieCard(funnelCounts, funnelColors),
              ],
            ),
    );
  }
}

/// -------------------- FUNNEL CARD --------------------

class _FunnelCard extends StatelessWidget {
  const _FunnelCard(this.data, this.colors);

  final Map<String, int> data;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final max = data.values.isEmpty
        ? 1
        : data.values.reduce((a, b) => a > b ? a : b);

    final entries = data.entries.toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sotuv Funnel',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          ...List.generate(entries.length, (i) {
            final e = entries[i];
            final progress = e.value / max;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        e.value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 18,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(
                            colors[i % colors.length],
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// -------------------- PIE CARD С ПРОЦЕНТАМИ --------------------

class _PieCard extends StatelessWidget {
  const _PieCard(this.data, this.colors);

  final Map<String, int> data;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final total = entries.fold<int>(0, (p, e) => p + e.value);

    if (total == 0) {
      return const AppCard(
        child: SizedBox(
          height: 220,
          child: Center(child: Text('Нет данных')),
        ),
      );
    }

    final sections = List.generate(entries.length, (i) {
      final value = entries[i].value.toDouble();
      final percent = (value / total) * 100;

      return PieChartSectionData(
        value: value,
        color: colors[i % colors.length],
        radius: 60,
        title: '${percent.toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });

    return AppCard(
      child: Column(
        children: [
          const SizedBox(height: 4),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 55,
                sectionsSpace: 3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Total: $total",
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

