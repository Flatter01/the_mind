import 'package:flutter/material.dart';

// ── Модели ────────────────────────────────────────────────────────────────
class _StudentRow {
  final String firstName;
  final String lastName;
  bool? attended; // true = был, false = не был, null = не отмечено
  String lessonScore; // '-', '1'-'5'
  String hwScore; // 'Н/А', '1'-'5'
  String comment;

  _StudentRow({
    required this.firstName,
    required this.lastName,
    this.attended,
    this.lessonScore = '-',
    this.hwScore = 'Н/А',
    this.comment = '',
  });

  String get initials =>
      '${firstName[0]}${lastName[0]}'.toUpperCase();
}

class TheMindTeacherGroupPage extends StatefulWidget {
  const TheMindTeacherGroupPage({super.key});

  @override
  State<TheMindTeacherGroupPage> createState() =>
      _TheMindTeacherGroupPageState();
}

class _TheMindTeacherGroupPageState extends State<TheMindTeacherGroupPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';

  final List<_StudentRow> _students = [
    _StudentRow(
      firstName: 'Иван',
      lastName: 'Иванов',
      attended: true,
      lessonScore: '5',
      hwScore: '4',
      comment: 'Активно работал на занятии',
    ),
    _StudentRow(
      firstName: 'Мария',
      lastName: 'Сидорова',
      attended: false,
      lessonScore: '-',
      hwScore: 'Н/А',
      comment: 'Болеет',
    ),
    _StudentRow(
      firstName: 'Алексей',
      lastName: 'Петров',
      attended: true,
      lessonScore: '4',
      hwScore: '5',
      comment: '',
    ),
    _StudentRow(
      firstName: 'Елена',
      lastName: 'Волкова',
      attended: true,
      lessonScore: '5',
      hwScore: '3',
      comment: 'Нужно подтянуть теорию циклов',
    ),
  ];

  final List<String> _scoreOptions = ['-', '1', '2', '3', '4', '5'];
  final List<String> _hwOptions = ['Н/А', '1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_StudentRow> get _filtered => _students
      .where((s) =>
          '${s.firstName} ${s.lastName}'
              .toLowerCase()
              .contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupHeader(),
            const SizedBox(height: 20),
            _buildTabs(),
            const SizedBox(height: 20),
            Expanded(child: _buildJournal()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ── Шапка группы ─────────────────────────────────────────────────────────
  Widget _buildGroupHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC8A).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'АКТИВНАЯ',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2ECC8A), letterSpacing: 0.5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('ID: PY-204', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Группа: Программирование Python',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A2233)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: const Color(0xFFED6A2E)),
                    const SizedBox(width: 6),
                    Text(
                      'Понедельник, Среда • 18:00 - 19:30',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined, size: 15, color: Colors.grey[700]),
            label: Text('Редактировать', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_outlined, size: 15, color: Colors.white),
            label: const Text('Сохранить изменения', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Табы ─────────────────────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFFED6A2E),
        unselectedLabelColor: Colors.grey[500],
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        indicatorColor: const Color(0xFFED6A2E),
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.grey.withOpacity(0.1),
        isScrollable: false,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_outlined, size: 15),
                const SizedBox(width: 8),
                const Text('Журнал посещаемости'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_outlined, size: 15),
                const SizedBox(width: 8),
                const Text('Материалы курса'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_outlined, size: 15),
                const SizedBox(width: 8),
                const Text('История занятий'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Журнал ────────────────────────────────────────────────────────────────
  Widget _buildJournal() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Строка с датой, темой и поиском
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Text(
                  'Занятие: 14 Октября, 2023',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2233)),
                ),
                Container(width: 1, height: 18, color: Colors.grey.withOpacity(0.3), margin: const EdgeInsets.symmetric(horizontal: 16)),
                Text('Тема: Функции и декораторы', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                const Spacer(),
                Text('Быстрый поиск:', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                const SizedBox(width: 10),
                Container(
                  width: 180,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Имя студента...',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, size: 15, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
              border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.withOpacity(0.08))),
            ),
            child: Row(
              children: [
                const Expanded(flex: 4, child: _ColH('СТУДЕНТ')),
                const Expanded(flex: 3, child: _ColH('ПОСЕЩАЕМОСТЬ')),
                const Expanded(flex: 3, child: _ColH('ОЦЕНКА ЗА УРОК')),
                const Expanded(flex: 3, child: _ColH('ОЦЕНКА ЗА ДЗ')),
                const Expanded(flex: 5, child: _ColH('КОММЕНТАРИЙ')),
              ],
            ),
          ),

          // Строки студентов
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _studentRow(_filtered[i]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Строка студента ───────────────────────────────────────────────────────
  Widget _studentRow(_StudentRow s) {
    // Цвет аватара
    final colors = [
      const Color(0xFFED6A2E),
      const Color(0xFF6B7FD4),
      const Color(0xFF2ECC8A),
      const Color(0xFFFF9800),
    ];
    final colorIndex = (s.firstName.codeUnitAt(0) + s.lastName.codeUnitAt(0)) % colors.length;
    final avatarColor = colors[colorIndex];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.06))),
      ),
      child: Row(
        children: [
          // Студент
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(s.initials, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: avatarColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${s.firstName} ${s.lastName}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A2233))),
              ],
            ),
          ),

          // Посещаемость
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _attendBtn('Был', true, s),
                const SizedBox(width: 6),
                _attendBtn('Нет', false, s),
              ],
            ),
          ),

          // Оценка за урок
          Expanded(
            flex: 3,
            child: _scoreDropdown(
              value: s.lessonScore,
              options: _scoreOptions,
              onChanged: (v) => setState(() => s.lessonScore = v!),
              wide: true,
            ),
          ),

          // Оценка за ДЗ
          Expanded(
            flex: 3,
            child: _scoreDropdown(
              value: s.hwScore,
              options: _hwOptions,
              onChanged: (v) => setState(() => s.hwScore = v!),
              wide: false,
            ),
          ),

          // Комментарий
          Expanded(
            flex: 5,
            child: _CommentField(
              initial: s.comment,
              onChanged: (v) => s.comment = v,
            ),
          ),
        ],
      ),
    );
  }

  // ── Кнопка посещаемости ──────────────────────────────────────────────────
  Widget _attendBtn(String label, bool value, _StudentRow s) {
    final isActive = s.attended == value;
    return GestureDetector(
      onTap: () => setState(() => s.attended = isActive ? null : value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? (value ? const Color(0xFF2ECC8A).withOpacity(0.12) : const Color(0xFFED6A2E).withOpacity(0.12))
              : const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? (value ? const Color(0xFF2ECC8A) : const Color(0xFFED6A2E)).withOpacity(0.4)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive
                ? (value ? const Color(0xFF2ECC8A) : const Color(0xFFED6A2E))
                : Colors.grey[500],
          ),
        ),
      ),
    );
  }

  // ── Дропдаун оценки ──────────────────────────────────────────────────────
  Widget _scoreDropdown({
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool wide = true,
  }) {
    return SizedBox(
      height: 36,
      width: wide ? 100 : 90,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.18)),
        ),
        child: DropdownButton<String>(
          value: value,
          items: options
              .map((o) => DropdownMenuItem(
                    value: o,
                    child: Text(o,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ))
              .toList(),
          onChanged: onChanged,
          underline: const SizedBox(),
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down,
              size: 16, color: Colors.grey[400]),
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A2233)),
        ),
      ),
    );
  }

  // ── Футер ─────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Text(
            'Последнее сохранение: Сегодня в 14:32',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[400]),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFEEF0F5),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Отменить', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 15),
            label: const Text('Завершить и Сохранить', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColH extends StatelessWidget {
  final String text;
  const _ColH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5),
    );
  }
}

// ── Поле комментария со стабильным контроллером ───────────────────────────
class _CommentField extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onChanged;
  const _CommentField({required this.initial, required this.onChanged});

  @override
  State<_CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<_CommentField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      onChanged: widget.onChanged,
      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
      decoration: InputDecoration(
        hintText: 'Комментарий...',
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );
  }
}