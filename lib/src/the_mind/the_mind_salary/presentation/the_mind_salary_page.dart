import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/tariff_page.dart';

class TheMindSalaryPage extends StatefulWidget {
  const TheMindSalaryPage({super.key});

  @override
  State<TheMindSalaryPage> createState() => _TheMindSalaryPageState();
}

class _TheMindSalaryPageState extends State<TheMindSalaryPage> {
  String _chartMode = 'Месяц'; // 'Месяц' | 'Год'
  int _hoveredIndex = -1;
    final List<Tariff> tariffs = [];


  // Данные графика по месяцам
  final List<double> _monthData = [
    320,
    210,
    380,
    360,
    490,
    370,
    310,
    420,
    290,
    380,
    460,
    400,
  ];
  final List<String> _months = [
    'Янв',
    'Фев',
    'Мар',
    'Апр',
    'Май',
    'Июн',
    'Июл',
    'Авг',
    'Сен',
    'Окт',
    'Ноя',
    'Дек',
  ];

  // Данные сотрудников
  final List<_SalaryRow> _employees = [
    _SalaryRow(
      initials: 'ИП',
      name: 'Игорь Петров',
      role: 'Старший преподаватель',
      base: 85000,
      bonus: 12000,
      paid: true,
    ),
    _SalaryRow(
      initials: 'МС',
      name: 'Мария Сидорова',
      role: 'Методист',
      base: 65000,
      bonus: 0,
      paid: true,
    ),
    _SalaryRow(
      initials: 'АК',
      name: 'Алексей Кузнецов',
      role: 'Преподаватель',
      base: 70000,
      bonus: 5000,
      paid: false,
    ),
    _SalaryRow(
      initials: 'ЕВ',
      name: 'Елена Волкова',
      role: 'Администратор',
      base: 55000,
      bonus: 3000,
      paid: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: [
          // ── Заголовок ────────────────────────────────────────────
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Финансы',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Управление доходами, расходами и зарплатами',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── 4 карточки статистики ─────────────────────────────────
          Row(
            children: [
              _statCard(
                'Общий доход',
                '2 450 000 ₽',
                '+12.5%',
                Icons.account_balance_outlined,
                true,
              ),
              const SizedBox(width: 16),
              _statCard(
                'Доход за месяц',
                '420 000 ₽',
                '+5.2%',
                Icons.calendar_today_outlined,
                true,
              ),
              const SizedBox(width: 16),
              _statCard(
                'Расходы',
                '180 000 ₽',
                '-2.1%',
                Icons.trending_down_outlined,
                false,
              ),
              const SizedBox(width: 16),
              _statCard(
                'Долги учеников',
                '55 000 ₽',
                'Внимание',
                Icons.error_outline,
                null,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Тарифы ───────────────────────────────────────────────
          _tariffsSection(),

          const SizedBox(height: 20),

          // ── График ───────────────────────────────────────────────
          _chartCard(),

          const SizedBox(height: 20),

          // ── Таблица зарплат ──────────────────────────────────────
          _salaryTable(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Карточка статистики ───────────────────────────────────────────────────
  Widget _statCard(
    String label,
    String value,
    String trend,
    IconData icon,
    bool? positive,
  ) {
    Color trendColor;
    if (positive == null)
      trendColor = const Color(0xFFED6A2E);
    else if (positive)
      trendColor = const Color(0xFF2ECC8A);
    else
      trendColor = const Color(0xFFED6A2E);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED6A2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFFED6A2E)),
                ),
                const Spacer(),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: trendColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A2233),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Тарифы ───────────────────────────────────────────────────────────────
  final List<_TariffItem> _tariffs = [
    _TariffItem(
      name: 'Базовый',
      price: '5 000',
      period: 'мес',
      duration: '1 Месяц',
      isActive: true,
      isPopular: false,
    ),
    _TariffItem(
      name: 'Продвинутый',
      price: '12 000',
      period: 'мес',
      duration: '3 Месяца',
      isActive: true,
      isPopular: true,
    ),
    _TariffItem(
      name: 'VIP',
      price: '45 000',
      period: 'год',
      duration: '1 Год',
      isActive: false,
      isPopular: false,
    ),
  ];

  Widget _tariffsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Мои тарифы',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2233),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Управление тарифными планами для учеников',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
            const Spacer(),

            ElevatedButton.icon(
              onPressed: () => _openTariffAddDialog(),
              icon: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 16,
              ),
              label: const Text(
                'Добавить тариф',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6A2E),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(width: 15),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TariffPage()),
                );
              },
              icon: Icon(
                Icons.grid_view_outlined,
                size: 15,
                color: Colors.grey[600],
              ),
              label: Text(
                'Все тарифы',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Карточки тарифов
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _tariffs.asMap().entries.map((e) {
            final idx = e.key;
            final t = e.value;
            return Expanded(
              child: Padding(
                padding: idx < _tariffs.length - 1
                    ? const EdgeInsets.only(right: 16)
                    : EdgeInsets.zero,
                child: _tariffCard(t, idx),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _tariffCard(_TariffItem t, int index) {
    final isPopular = t.isPopular;

    return Container(
      decoration: BoxDecoration(
        color: isPopular ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? const Color(0xFFED6A2E)
              : Colors.grey.withOpacity(0.15),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название + иконки
                Row(
                  children: [
                    Text(
                      t.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A2233),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _editTariff(t, index),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _deleteTariff(index),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Статус
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: t.isActive
                        ? const Color(0xFF2ECC8A).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.isActive ? 'АКТИВЕН' : 'НЕАКТИВЕН',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: t.isActive
                          ? const Color(0xFF2ECC8A)
                          : Colors.grey[500],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Цена
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${t.price} ',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                      TextSpan(
                        text: '₽/${t.period}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),
                Text(
                  'Срок: ${t.duration}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                ),

                const SizedBox(height: 16),

                // Кнопка
                SizedBox(
                  width: double.infinity,
                  child: isPopular
                      ? ElevatedButton(
                          onPressed: () => _editTariff(t, index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED6A2E),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Редактировать',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () => _editTariff(t, index),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color(0xFFF8F9FB),
                          ),
                          child: Text(
                            'Редактировать',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // Бейдж "Популярный"
          if (isPopular)
            Positioned(
              top: -1,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFED6A2E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  'ПОПУЛЯРНЫЙ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openTariffAddDialog() {
    showDialog(
      context: context,
      builder: (_) => TariffDialog(
        onSave: (t) {
          setState(() {
            _tariffs.add(_TariffItem(
              name: t.name,
              price: t.price.toStringAsFixed(0),
              period: 'мес',
              duration: t.duration,
              isActive: true,
              isPopular: false,
            ));
          });
        },
      ),
    );
  }

  static const _validDurations = ['1 Месяц', '3 Месяца', '6 Месяцев', '1 Год'];

  String _normalizeDuration(String d) {
    if (_validDurations.contains(d)) return d;
    const map = {
      '1 месяц': '1 Месяц',
      '3 месяца': '3 Месяца',
      '6 месяцев': '6 Месяцев',
      '1 год': '1 Год',
    };
    return map[d.toLowerCase()] ?? '1 Месяц';
  }

  void _editTariff(_TariffItem t, int index) {
    showDialog(
      context: context,
      builder: (_) => TariffDialog(
        tariff: Tariff(
          name: t.name,
          price: double.tryParse(t.price.replaceAll(' ', '')) ?? 0,
          duration: _normalizeDuration(t.duration),
          description: '',
        ),
        onSave: (updated) {
          setState(() {
            _tariffs[index] = _TariffItem(
              name: updated.name,
              price: updated.price.toStringAsFixed(0),
              period: t.period,
              duration: updated.duration,
              isActive: t.isActive,
              isPopular: t.isPopular,
            );
          });
        },
      ),
    );
  }

  void _deleteTariff(int index) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Удалить тариф',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Вы уверены, что хотите удалить этот тариф?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Отмена', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              setState(() => _tariffs.removeAt(index));
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── График ────────────────────────────────────────────────────────────────
  Widget _chartCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Динамика доходов',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Визуализация поступлений средств',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
              const Spacer(),
              // Переключатель Месяц/Год
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F5F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: ['Месяц', 'Год'].map((m) {
                    final isActive = _chartMode == m;
                    return GestureDetector(
                      onTap: () => setState(() => _chartMode = m),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          m,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? const Color(0xFF1A2233)
                                : Colors.grey[500],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 550,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    setState(() {
                      if (response?.spot != null) {
                        _hoveredIndex = response!.spot!.touchedBarGroupIndex;
                      } else {
                        _hoveredIndex = -1;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1A2233),
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${(rod.toY * 1000).toStringAsFixed(0)} ₽',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _months.length)
                          return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _months[idx],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.grey.withOpacity(0.07),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_monthData.length, (i) {
                  final isHovered = _hoveredIndex == i;
                  // Май (index 4) — самый высокий, выделяем оранжевым
                  final isHighlight = i == 4;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: _monthData[i],
                        width: 28,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        color: isHighlight
                            ? const Color(0xFFED6A2E)
                            : isHovered
                            ? const Color(0xFFED6A2E).withOpacity(0.5)
                            : const Color(0xFFED6A2E).withOpacity(0.18),
                      ),
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

  // ── Таблица зарплат ───────────────────────────────────────────────────────
  Widget _salaryTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок таблицы
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Зарплаты сотрудников',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Учет выплат за выбранный период',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const Spacer(),
                // Дата период
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '01.05.2024 - 31.05.2024',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Кнопка отчет
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.download_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                  label: const Text(
                    'Отчет',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED6A2E),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Шапка колонок
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.grey.withOpacity(0.08)),
              ),
            ),
            child: Row(
              children: const [
                Expanded(flex: 4, child: _ColH('СОТРУДНИК')),
                Expanded(flex: 3, child: _ColH('ДОЛЖНОСТЬ')),
                Expanded(flex: 2, child: _ColH('СТАВКА')),
                Expanded(flex: 2, child: _ColH('ПРЕМИЯ')),
                Expanded(flex: 2, child: _ColH('ИТОГО')),
                Expanded(flex: 2, child: _ColH('СТАТУС')),
              ],
            ),
          ),

          // Строки
          ..._employees.map(_salaryRow),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _salaryRow(_SalaryRow s) {
    final colors = [
      const Color(0xFFED6A2E),
      const Color(0xFF6B7FD4),
      const Color(0xFF2ECC8A),
      const Color(0xFFFF9800),
    ];
    final idx =
        (s.initials.codeUnitAt(0) + s.initials.codeUnitAt(1)) % colors.length;
    final color = colors[idx];
    final total = s.base + s.bonus;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          // Сотрудник
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      s.initials,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  s.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233),
                  ),
                ),
              ],
            ),
          ),
          // Должность
          Expanded(
            flex: 3,
            child: Text(
              s.role,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          // Ставка
          Expanded(
            flex: 2,
            child: Text(
              '${_fmt(s.base)} ₽',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2233),
              ),
            ),
          ),
          // Премия
          Expanded(
            flex: 2,
            child: Text(
              s.bonus > 0 ? '+${_fmt(s.bonus)} ₽' : '0 ₽',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: s.bonus > 0 ? const Color(0xFF2ECC8A) : Colors.grey[400],
              ),
            ),
          ),
          // Итого
          Expanded(
            flex: 2,
            child: Text(
              '${_fmt(total)} ₽',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2233),
              ),
            ),
          ),
          // Статус
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: s.paid
                    ? const Color(0xFF2ECC8A).withOpacity(0.1)
                    : const Color(0xFFED6A2E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                s.paid ? 'Выплачено' : 'Ожидает',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: s.paid
                      ? const Color(0xFF2ECC8A)
                      : const Color(0xFFED6A2E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ── Модель строки зарплат ─────────────────────────────────────────────────
class _SalaryRow {
  final String initials;
  final String name;
  final String role;
  final int base;
  final int bonus;
  final bool paid;
  const _SalaryRow({
    required this.initials,
    required this.name,
    required this.role,
    required this.base,
    required this.bonus,
    required this.paid,
  });
}

class _ColH extends StatelessWidget {
  final String text;
  const _ColH(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.grey[400],
        letterSpacing: 0.5,
      ),
    );
  }
}

class _TariffItem {
  final String name;
  final String price;
  final String period;
  final String duration;
  final bool isActive;
  final bool isPopular;
  const _TariffItem({
    required this.name,
    required this.price,
    required this.period,
    required this.duration,
    required this.isActive,
    required this.isPopular,
  });
}
