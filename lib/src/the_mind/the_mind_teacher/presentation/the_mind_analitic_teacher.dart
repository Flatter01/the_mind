import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/the_mind_teacher_page.dart';

class TheMindAnaliticTeacher extends StatefulWidget {
  const TheMindAnaliticTeacher({super.key});

  @override
  State<TheMindAnaliticTeacher> createState() =>
      _TheMindAnaliticTeacherState();
}

class _TheMindAnaliticTeacherState extends State<TheMindAnaliticTeacher> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';
  int _currentPage = 1;
  final int _perPage = 5;
  String _selectedMonth = 'Март 2026';

  static const _orange = Color(0xFFED6A2E);
  static const _orangeLight = Color(0xFFFFF3EE);
  static const _bg = Color(0xFFF2F5F7);
  static const _text = Color(0xFF1A2233);
  static const _grey = Color(0xFF8A94A6);
  static const _green = Color(0xFF2ECC8A);

  // Мок-данные учителей
  final List<Map<String, dynamic>> _teachers = [
    {
      'name': 'ZiyoMuhammad',
      'initials': 'ZM',
      'course': 'IELTS Advanced',
      'students': 24,
      'price': 1200000,
      'income': 28800000,
      'salary': 11520000,
      'profit': 17280000,
      'color': const Color(0xFFED6A2E),
    },
    {
      'name': 'Abdullox',
      'initials': 'AB',
      'course': 'General English',
      'students': 18,
      'price': 800000,
      'income': 14400000,
      'salary': 5760000,
      'profit': 8640000,
      'color': const Color(0xFF6B7FD4),
    },
    {
      'name': 'Dilshod Yusupov',
      'initials': 'DY',
      'course': 'Math & Science',
      'students': 32,
      'price': 950000,
      'income': 30400000,
      'salary': 12160000,
      'profit': 18240000,
      'color': const Color(0xFF2ECC8A),
    },
    {
      'name': 'Malika Rahimova',
      'initials': 'MR',
      'course': 'Kids English',
      'students': 15,
      'price': 700000,
      'income': 10500000,
      'salary': 4200000,
      'profit': 6300000,
      'color': const Color(0xFFFF9800),
    },
    {
      'name': 'Sardor Nazarov',
      'initials': 'SN',
      'course': 'TOEFL Prep',
      'students': 20,
      'price': 1100000,
      'income': 22000000,
      'salary': 8800000,
      'profit': 13200000,
      'color': const Color(0xFF9C59D1),
    },
    {
      'name': 'Nodira Xasanova',
      'initials': 'NX',
      'course': 'Business English',
      'students': 12,
      'price': 1500000,
      'income': 18000000,
      'salary': 7200000,
      'profit': 10800000,
      'color': const Color(0xFFED6A2E),
    },
  ];

  final List<String> _months = [
    'Январь 2026',
    'Февраль 2026',
    'Март 2026',
    'Апрель 2026',
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_search.isEmpty) return _teachers;
    return _teachers.where((t) {
      return t['name'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          t['course'].toString().toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  int get _totalIncome =>
      _teachers.fold(0, (s, t) => s + (t['income'] as int));
  int get _totalSalary =>
      _teachers.fold(0, (s, t) => s + (t['salary'] as int));
  int get _totalProfit =>
      _teachers.fold(0, (s, t) => s + (t['profit'] as int));

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalPages = (filtered.length / _perPage).ceil().clamp(1, 999);
    final pageItems = filtered
        .skip((_currentPage - 1) * _perPage)
        .take(_perPage)
        .toList();

    return Scaffold(
      backgroundColor: _bg,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: [
          // ── Заголовок ──
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Аналитика доходов учителей',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Отслеживание финансовой эффективности преподавательского состава',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              const Spacer(),

              // Выбор месяца
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMonth,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _text,
                    ),
                    items: _months
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 14, color: _grey),
                                const SizedBox(width: 8),
                                Text(m),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedMonth = v!),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Экспорт
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined,
                    size: 16, color: Colors.white),
                label: const Text(
                  'Экспорт отчёта',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Карточки ──
          Row(
            children: [
              Expanded(
                child: _topCard(
                  'Общий доход',
                  _totalIncome,
                  Icons.attach_money_rounded,
                  const Color(0xFF6B7FD4),
                  '+12% vs прошлый месяц',
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _topCard(
                  'Выплачено зарплат',
                  _totalSalary,
                  Icons.payments_outlined,
                  _orange,
                  '${(_totalSalary * 100 ~/ _totalIncome)}% от выручки',
                  null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _topCard(
                  'Общая прибыль',
                  _totalProfit,
                  Icons.pie_chart_outline_rounded,
                  _green,
                  '+8.4% рост маржи',
                  true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Таблица ──
          Container(
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
              children: [
                // Заголовок таблицы + поиск
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Финансовая ведомость учителей',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      const Spacer(),
                      // Поиск
                      SizedBox(
                        width: 240,
                        height: 40,
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() {
                            _search = v;
                            _currentPage = 1;
                          }),
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Поиск учителя...',
                            hintStyle:
                                TextStyle(fontSize: 13, color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.search,
                                size: 16, color: Colors.grey[400]),
                            filled: true,
                            fillColor: const Color(0xFFF8F9FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: _orange, width: 1.5),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Шапка таблицы
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    border: Border.symmetric(
                      horizontal: BorderSide(
                          color: Colors.grey.withOpacity(0.1)),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: _ColH('ИМЯ УЧИТЕЛЯ')),
                      Expanded(flex: 3, child: _ColH('КУРС')),
                      Expanded(flex: 2, child: _ColH('СТУДЕНТОВ')),
                      Expanded(flex: 2, child: _ColH('ЦЕНА')),
                      Expanded(flex: 3, child: _ColH('ДОХОД')),
                      Expanded(flex: 3, child: _ColH('ЗАРПЛАТА')),
                      Expanded(flex: 3, child: _ColH('ПРИБЫЛЬ')),
                      SizedBox(width: 40),
                    ],
                  ),
                ),

                // Строки
                if (pageItems.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Text('Учителя не найдены',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 14)),
                    ),
                  )
                else
                  ...pageItems.map(_teacherRow),

                // Пагинация
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: Colors.grey.withOpacity(0.1)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Показано ${pageItems.length} из ${filtered.length} учителей',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                      const Spacer(),
                      _buildPagination(totalPages),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Строка учителя ────────────────────────────────────────────────────────

  Widget _teacherRow(Map<String, dynamic> t) {
    return InkWell(
      onTap: (){
        Navigator.push(context,   
          MaterialPageRoute(builder: (_) => TheMindTeacherPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.07)),
          ),
        ),
        child: Row(
          children: [
            // Имя
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: (t['color'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        t['initials'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: t['color'] as Color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t['name'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _text,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
      
            // Курс
            Expanded(
              flex: 3,
              child: Text(
                t['course'] as String,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
      
            // Студентов
            Expanded(
              flex: 2,
              child: Text(
                '${t['students']}',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: _text),
              ),
            ),
      
            // Цена
            Expanded(
              flex: 2,
              child: Text(
                _fmt(t['price'] as int),
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
      
            // Доход
            Expanded(
              flex: 3,
              child: Text(
                _fmt(t['income'] as int),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _text,
                ),
              ),
            ),
      
            // Зарплата
            Expanded(
              flex: 3,
              child: Text(
                _fmt(t['salary'] as int),
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
      
            // Прибыль
            Expanded(
              flex: 3,
              child: Text(
                '+${_fmt(t['profit'] as int)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _green,
                ),
              ),
            ),
      
            // Действие
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.remove_red_eye_outlined,
                    size: 18, color: Colors.grey[400]),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Карточки ─────────────────────────────────────────────────────────────

  Widget _topCard(
    String label,
    int amount,
    IconData icon,
    Color color,
    String sub,
    bool? subPositive,
  ) {
    final subColor = subPositive == true
        ? _green
        : subPositive == false
            ? _orange
            : Colors.grey[500]!;

    return Container(
      padding: const EdgeInsets.all(20),
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
              Text(label,
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey[500])),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _fmt(amount),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: subPositive == null ? _text : color,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                subPositive == true
                    ? Icons.trending_up
                    : Icons.info_outline,
                size: 13,
                color: subColor,
              ),
              const SizedBox(width: 4),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: subColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Пагинация ─────────────────────────────────────────────────────────────

  Widget _buildPagination(int totalPages) {
    return Row(
      children: [
        _pgBtn('Назад',
            _currentPage > 1 ? () => setState(() => _currentPage--) : null),
        const SizedBox(width: 8),
        ...List.generate(totalPages.clamp(0, 5), (i) {
          final p = i + 1;
          final active = p == _currentPage;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () => setState(() => _currentPage = p),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? _orange : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active
                        ? _orange
                        : Colors.grey.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  '$p',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 4),
        _pgBtn(
            'Далее',
            _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null),
      ],
    );
  }

  Widget _pgBtn(String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: onTap == null ? Colors.grey[300] : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ── Форматирование ────────────────────────────────────────────────────────

  String _fmt(int n) {
    if (n == 0) return '0 сум';
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${buf.toString()} сум';
  }
}

// ── Заголовок колонки ─────────────────────────────────────────────────────────

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