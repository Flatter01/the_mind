import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MarketingAnalyticsPage extends StatefulWidget {
  const MarketingAnalyticsPage({super.key});

  @override
  State<MarketingAnalyticsPage> createState() => _MarketingAnalyticsPageState();
}

class _MarketingAnalyticsPageState extends State<MarketingAnalyticsPage> {
  String _chartMode = 'Неделя';
  final _searchController = TextEditingController();

  // ── Данные воронки ────────────────────────────────────────────
  final List<Map<String, dynamic>> _funnel = [
    {'label': 'Охват',   'value': 45200.0, 'display': '45.2k'},
    {'label': 'Клики',   'value': 2800.0,  'display': '2.8k'},
    {'label': 'Лиды',    'value': 1240.0,  'display': '1,240'},
    {'label': 'Продажи', 'value': 86.0,    'display': '86'},
  ];

  // ── Данные графика ─────────────────────────────────────────────
  final Map<String, List<double>> _chartData = {
    'Неделя': [12, 28, 45, 60, 95, 75, 55],
    'Месяц':  [30, 55, 40, 70, 90, 65, 50, 80, 95, 60, 45, 70],
  };
  final Map<String, List<String>> _chartLabels = {
    'Неделя': ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
    'Месяц':  ['1', '5', '8', '12', '15', '18', '20', '22', '24', '26', '28', '31'],
  };

  // ── Источники ──────────────────────────────────────────────────
  final List<Map<String, dynamic>> _sources = [
    {'name': 'Facebook Ads',  'icon': Icons.facebook,        'color': Color(0xFF1877F2), 'cost': 120000, 'leads': 420, 'students': 32},
    {'name': 'Google Search', 'icon': Icons.search,          'color': Color(0xFFED6A2E), 'cost': 180000, 'leads': 510, 'students': 28},
    {'name': 'YouTube',       'icon': Icons.play_circle_outline,'color': Color(0xFFFF0000),'cost': 95000, 'leads': 180, 'students': 16},
    {'name': 'VK Реклама',    'icon': Icons.share_outlined,  'color': Color(0xFF0077FF), 'cost': 55000,  'leads': 130, 'students': 10},
  ];

  List<Map<String, dynamic>> get _filteredSources {
    final q = _searchController.text.toLowerCase();
    return _sources.where((s) => s['name'].toString().toLowerCase().contains(q)).toList();
  }

  // ── Расчёты ────────────────────────────────────────────────────
  int get _totalCost    => _sources.fold(0, (s, e) => s + (e['cost'] as int));
  int get _totalLeads   => _sources.fold(0, (s, e) => s + (e['leads'] as int));
  int get _totalStudents=> _sources.fold(0, (s, e) => s + (e['students'] as int));
  int get _cpaStudent   => _totalStudents == 0 ? 0 : (_totalCost / _totalStudents).round();
  double get _roi       => _totalCost == 0 ? 0 : ((_totalStudents * 5232 - _totalCost) / _totalCost * 100);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          // ── 4 карточки ────────────────────────────────────────
          Row(
            children: [
              _statCard('Затраты на рекламу', _fmt(_totalCost),      '↗12%',  Icons.campaign_outlined,       true,  Colors.orange),
              const SizedBox(width: 14),
              _statCard('Всего лидов',        _fmtK(_totalLeads),    '↘5.4%', Icons.people_outline,          false, const Color(0xFF6B7FD4)),
              const SizedBox(width: 14),
              _statCard('Всего студентов',    '$_totalStudents',     '↘2%',   Icons.school_outlined,          false, Colors.purple),
              const SizedBox(width: 14),
              _statCard('Цена за студента',   '${_fmt(_cpaStudent)} ₽', '↗8.1%', Icons.receipt_long_outlined, true, Colors.orange),
            ],
          ),

          const SizedBox(height: 16),

          // ── График + Воронка ──────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // График
              Expanded(
                flex: 5,
                child: _card(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Динамика показателей', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                        const Spacer(),
                        _modeToggle(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(height: 200, child: _lineChart()),
                  ],
                )),
              ),

              const SizedBox(width: 14),

              // Воронка конверсии
              SizedBox(
                width: 280,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFED6A2E), Color(0xFFD4521A)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Воронка конверсии', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 20),
                      ..._funnel.map((f) => _funnelRow(f)),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ROI', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('${_roi.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Таблица источников ────────────────────────────────
          _card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Эффективность по источникам', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    height: 38,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Поиск источника...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FB),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Шапка
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: const [
                    Expanded(flex: 3, child: _ColH('ИСТОЧНИК')),
                    Expanded(flex: 2, child: _ColH('СУММА ЗАТРАТ')),
                    Expanded(flex: 2, child: _ColH('КОЛ-ВО ЛИДОВ')),
                    Expanded(flex: 2, child: _ColH('КОЛ-ВО СТУДЕНТОВ')),
                    Expanded(flex: 2, child: _ColH('CPA (СТУДЕНТ)')),
                  ],
                ),
              ),
              Divider(color: Colors.grey.withOpacity(0.08), height: 1),

              ..._filteredSources.map(_sourceRow),
            ],
          )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Строка воронки ─────────────────────────────────────────────
  Widget _funnelRow(Map<String, dynamic> f) {
    final max = (_funnel.first['value'] as double);
    final val = f['value'] as double;
    final pct = max == 0 ? 0.0 : val / max;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(f['label'], style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85))),
              const Spacer(),
              Text(f['display'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Строка источника ───────────────────────────────────────────
  Widget _sourceRow(Map<String, dynamic> s) {
    final cpa = s['students'] == 0 ? 0 : ((s['cost'] as int) / (s['students'] as int)).round();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.07)))),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: (s['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(s['icon'] as IconData, size: 16, color: s['color'] as Color),
                ),
                const SizedBox(width: 10),
                Text(s['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2233))),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text('${_fmt(s['cost'] as int)} ₽', style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
          Expanded(flex: 2, child: Text('${s['leads']}', style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
          Expanded(flex: 2, child: Text('${s['students']}', style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
          Expanded(
            flex: 2,
            child: Text('${_fmt(cpa)} ₽', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFED6A2E))),
          ),
        ],
      ),
    );
  }

  // ── Линейный график ────────────────────────────────────────────
  Widget _lineChart() {
    final data   = _chartData[_chartMode]!;
    final labels = _chartLabels[_chartMode]!;

    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.withOpacity(0.07), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (v, _) {
            final i = v.toInt();
            if (i < 0 || i >= labels.length) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(labels[i], style: TextStyle(fontSize: 11, color: Colors.grey[400])),
            );
          },
          interval: 1,
        )),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => const Color(0xFF1A2233),
          getTooltipItems: (spots) => spots.map((s) => LineTooltipItem(
            '${s.y.toInt()}%',
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
          )).toList(),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
          isCurved: true,
          curveSmoothness: 0.35,
          color: const Color(0xFFED6A2E),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [const Color(0xFFED6A2E).withOpacity(0.2), const Color(0xFFED6A2E).withOpacity(0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      minY: 0,
    ));
  }

  // ── Переключатель Неделя/Месяц ─────────────────────────────────
  Widget _modeToggle() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF2F5F7), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: ['Неделя', 'Месяц'].map((m) {
          final active = _chartMode == m;
          return GestureDetector(
            onTap: () => setState(() => _chartMode = m),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)] : [],
              ),
              child: Text(m, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? const Color(0xFF1A2233) : Colors.grey[500])),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Карточка статистики ────────────────────────────────────────
  Widget _statCard(String label, String value, String trend, IconData icon, bool up, Color barColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500]))),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: barColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, size: 16, color: barColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                const SizedBox(width: 6),
                Text(trend, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: up ? const Color(0xFFED6A2E) : const Color(0xFF2ECC8A))),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 3,
                backgroundColor: barColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: child,
  );

  String _fmt(int n) {
    return NumberFormat('#,###', 'ru_RU').format(n).replaceAll(',', ' ');
  }

  String _fmtK(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _ColH extends StatelessWidget {
  final String text;
  const _ColH(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5));
}

// Сохраняем модели из оригинального кода для совместимости
class FunnelStage {
  TextEditingController name;
  TextEditingController count;
  FunnelStage(String n, int c)
      : name = TextEditingController(text: n),
        count = TextEditingController(text: c.toString());
}

class CostItem {
  TextEditingController name;
  TextEditingController value;
  CostItem(String n, String v)
      : name = TextEditingController(text: n),
        value = TextEditingController(text: v);
}