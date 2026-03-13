import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseOptionsPage extends StatefulWidget {
  const ExpenseOptionsPage({super.key});

  @override
  State<ExpenseOptionsPage> createState() => _ExpenseOptionsPageState();
}

class _ExpenseOptionsPageState extends State<ExpenseOptionsPage> {
  final _nameController    = TextEditingController();
  final _amountController  = TextEditingController(text: '0.00');
  final _noteController    = TextEditingController();
  final _newCatController  = TextEditingController();

  DateTime? _selectedDate;
  String _selectedCategory = 'Продукты';
  String _historyFilter = 'Все'; // Все / За неделю / За месяц
  bool _showAll = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Продукты',     'icon': Icons.shopping_cart_outlined,  'color': Color(0xFF2ECC8A)},
    {'name': 'Транспорт',    'icon': Icons.directions_car_outlined,  'color': Color(0xFF6B7FD4)},
    {'name': 'Развлечения',  'icon': Icons.sports_esports_outlined,  'color': Color(0xFFFF9800)},
    {'name': 'Жильё',        'icon': Icons.home_outlined,            'color': Color(0xFFED6A2E)},
    {'name': 'Другое',       'icon': Icons.more_horiz,               'color': Color(0xFF9E9E9E)},
  ];

  final List<ExpenseModel> _expenses = [
    ExpenseModel(name: "Супермаркет 'Магнит'",  note: 'Покупка продуктов на неделю', category: 'Продукты',    amount: 1250, date: DateTime(2024, 5, 14)),
    ExpenseModel(name: 'Яндекс Такси',          note: 'Поездка в аэропорт',          category: 'Транспорт',   amount: 890,  date: DateTime(2024, 5, 13)),
    ExpenseModel(name: "Кофейня 'Starbucks'",   note: 'Кофе и десерт',               category: 'Развлечения', amount: 450,  date: DateTime(2024, 5, 12)),
    ExpenseModel(name: 'Аренда квартиры',        note: 'Ежемесячный платёж',          category: 'Жильё',       amount: 35000,date: DateTime(2024, 5, 10)),
  ];

  double get _totalMonth => _expenses.fold(0, (s, e) => s + e.amount);
  double get _limit => 60000;

  List<ExpenseModel> get _filtered {
    final now = DateTime.now();
    return _expenses.where((e) {
      if (_historyFilter == 'За неделю') return now.difference(e.date).inDays <= 7;
      if (_historyFilter == 'За месяц')  return e.date.month == now.month && e.date.year == now.year;
      return true;
    }).toList();
  }

  void _addExpense() {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    if (_nameController.text.trim().isEmpty || amount <= 0) return;
    setState(() {
      _expenses.insert(0, ExpenseModel(
        name: _nameController.text.trim(),
        note: _noteController.text.trim(),
        category: _selectedCategory,
        amount: amount,
        date: _selectedDate ?? DateTime.now(),
      ));
      _nameController.clear();
      _amountController.text = '0.00';
      _noteController.clear();
      _selectedDate = null;
    });
  }

  void _addCategoryDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Новая категория', style: TextStyle(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: _newCatController,
          decoration: InputDecoration(
            hintText: 'Название категории',
            filled: true, fillColor: const Color(0xFFF8F9FB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Отмена', style: TextStyle(color: Colors.grey[600]))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFED6A2E), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              final name = _newCatController.text.trim();
              if (name.isEmpty) return;
              setState(() {
                _categories.add({'name': name, 'icon': Icons.label_outline, 'color': const Color(0xFF9E9E9E)});
                _selectedCategory = name;
              });
              _newCatController.clear();
              Navigator.pop(context);
            },
            child: const Text('Добавить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _catMeta(String name) =>
      _categories.firstWhere((c) => c['name'] == name, orElse: () => {'name': name, 'icon': Icons.label_outline, 'color': Colors.grey});

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _newCatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Левая панель ────────────────────────────────────────
          SizedBox(
            width: 320,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Мини-статы
                  Row(
                    children: [
                      Expanded(child: _miniStat('В этом месяце', '${_fmt(_totalMonth.toInt())} ₽', const Color(0xFFED6A2E))),
                      const SizedBox(width: 12),
                      Expanded(child: _miniStat('Лимит', '${_fmt(_limit.toInt())} ₽', const Color(0xFF1A2233))),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Форма нового расхода
                  _card(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: const Color(0xFFED6A2E), size: 20),
                          const SizedBox(width: 8),
                          const Text('Новый расход', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _fieldLabel('Название'),
                      const SizedBox(height: 6),
                      _inputField(_nameController, hint: 'Напр. Продукты в Магните'),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          // Категория
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Категория'),
                                const SizedBox(height: 6),
                                Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FB),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCategory,
                                      isExpanded: true,
                                      icon: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[500]),
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
                                      items: _categories.map((c) => DropdownMenuItem(value: c['name'] as String, child: Text(c['name'] as String))).toList(),
                                      onChanged: (v) => setState(() => _selectedCategory = v!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Сумма
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Сумма (₽)'),
                                const SizedBox(height: 6),
                                _inputField(_amountController, hint: '0.00', keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel('Дата'),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFFED6A2E))),
                              child: child!,
                            ),
                          );
                          if (d != null) setState(() => _selectedDate = d);
                        },
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.withOpacity(0.15)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null ? 'дд.мм.гггг' : DateFormat('dd.MM.yyyy').format(_selectedDate!),
                                  style: TextStyle(fontSize: 13, color: _selectedDate == null ? Colors.grey[400] : const Color(0xFF1A2233)),
                                ),
                              ),
                              Icon(Icons.calendar_today_outlined, size: 15, color: Colors.grey[400]),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel('Комментарий'),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.withOpacity(0.15)),
                        ),
                        child: TextField(
                          controller: _noteController,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Дополнительные детали...',
                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _addExpense,
                          icon: const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 16),
                          label: const Text('Добавить расход', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED6A2E),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),

          // ── Правая панель — история ─────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
              child: _card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок + фильтры
                  Row(
                    children: [
                      const Text('История операций', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                      const Spacer(),
                      _filterChips(),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Шапка таблицы
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: const [
                        Expanded(flex: 4, child: _ColH('ОПИСАНИЕ')),
                        Expanded(flex: 2, child: _ColH('КАТЕГОРИЯ')),
                        Expanded(flex: 2, child: _ColH('СУММА')),
                        Expanded(flex: 2, child: _ColH('ДАТА')),
                        SizedBox(width: 32),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.1), height: 1),

                  // Строки
                  ...(_showAll ? _filtered : _filtered.take(4)).map(_expenseRow),

                  // Показать ещё
                  if (_filtered.length > 4)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => setState(() => _showAll = !_showAll),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _showAll ? 'Скрыть' : 'Показать ещё',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFED6A2E)),
                              ),
                              const SizedBox(width: 4),
                              Icon(_showAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFFED6A2E), size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expenseRow(ExpenseModel e) {
    final meta = _catMeta(e.category);
    final color = meta['color'] as Color;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.07)))),
      child: Row(
        children: [
          // Описание
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2233))),
                if (e.note.isNotEmpty)
                  Text(e.note, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
              ],
            ),
          ),
          // Категория
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(meta['icon'] as IconData, size: 12, color: color),
                  const SizedBox(width: 5),
                  Flexible(child: Text(e.category, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
          // Сумма
          Expanded(
            flex: 2,
            child: Text(
              '-${_fmt(e.amount.toInt())} ₽',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2233)),
            ),
          ),
          // Дата
          Expanded(
            flex: 2,
            child: Text(_fmtDate(e.date), style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ),
          // Меню
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[400]),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit',   child: Text('Редактировать')),
              const PopupMenuItem(value: 'delete', child: Text('Удалить', style: TextStyle(color: Colors.red))),
            ],
            onSelected: (v) {
              if (v == 'delete') setState(() => _expenses.remove(e));
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return Row(
      children: ['Все', 'За неделю', 'За месяц'].map((f) {
        final active = _historyFilter == f;
        return GestureDetector(
          onTap: () => setState(() => _historyFilter = f),
          child: Container(
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFED6A2E).withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: active ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.2)),
            ),
            child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? const Color(0xFFED6A2E) : Colors.grey[600])),
          ),
        );
      }).toList(),
    );
  }

  Widget _miniStat(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: valueColor)),
        ],
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

  Widget _fieldLabel(String text) => Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A2233)));

  Widget _inputField(TextEditingController c, {required String hint, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: TextField(
        controller: c,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  static const _months = ['янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _ColH extends StatelessWidget {
  final String text;
  const _ColH(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5));
}

class ExpenseModel {
  final String name;
  final String note;
  final String category;
  final double amount;
  final DateTime date;

  ExpenseModel({required this.name, required this.note, required this.category, required this.amount, required this.date});
}