import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  int _currentPage = 1;
  final int _perPage = 5;

  final List<TransactionModel> _allTransactions = [
    TransactionModel(firstName: 'Иван', lastName: 'Петров', group: 'WEB-24-01', method: 'card', amount: 12500, date: DateTime(2024, 5, 14), status: 'done'),
    TransactionModel(firstName: 'Мария', lastName: 'Сидорова', group: 'DESIGN-24-03', method: 'cash', amount: 8000, date: DateTime(2024, 5, 14), status: 'done'),
    TransactionModel(firstName: 'Артем', lastName: 'Кузнецов', group: 'QA-24-02', method: 'card', amount: 15000, date: DateTime(2024, 5, 13), status: 'pending'),
    TransactionModel(firstName: 'Елена', lastName: 'Васильева', group: 'WEB-24-01', method: 'card', amount: 12500, date: DateTime(2024, 5, 13), status: 'done'),
    TransactionModel(firstName: 'Дмитрий', lastName: 'Михайлов', group: 'DESIGN-24-03', method: 'cash', amount: 4500, date: DateTime(2024, 5, 12), status: 'declined'),
    TransactionModel(firstName: 'Анна', lastName: 'Смирнова', group: 'WEB-24-01', method: 'card', amount: 12500, date: DateTime(2024, 5, 11), status: 'done'),
    TransactionModel(firstName: 'Сергей', lastName: 'Морозов', group: 'QA-24-02', method: 'cash', amount: 9000, date: DateTime(2024, 5, 10), status: 'done'),
  ];

  List<TransactionModel> get _filtered {
    final q = _searchController.text.toLowerCase();
    return _allTransactions.where((t) {
      final matchSearch = q.isEmpty ||
          '${t.firstName} ${t.lastName}'.toLowerCase().contains(q) ||
          t.group.toLowerCase().contains(q);
      final matchDate = _selectedDate == null ||
          (t.date.year == _selectedDate!.year &&
              t.date.month == _selectedDate!.month &&
              t.date.day == _selectedDate!.day);
      return matchSearch && matchDate;
    }).toList();
  }

  List<TransactionModel> get _pageItems {
    final f = _filtered;
    return f.skip((_currentPage - 1) * _perPage).take(_perPage).toList();
  }

  int get _totalPages => (_filtered.length / _perPage).ceil().clamp(1, 999);

  int get _todayAmount {
    final now = DateTime.now();
    return _allTransactions
        .where((t) => t.date.year == now.year && t.date.month == now.month && t.date.day == now.day)
        .fold(0, (s, t) => s + t.amount);
  }

  int get _monthAmount {
    final now = DateTime.now();
    return _allTransactions
        .where((t) => t.date.year == now.year && t.date.month == now.month)
        .fold(0, (s, t) => s + t.amount);
  }

  int get _totalAmount => _allTransactions.fold(0, (s, t) => s + t.amount);
  int get _cashAmount => _allTransactions.where((t) => t.method == 'cash').fold(0, (s, t) => s + t.amount);
  int get _cardAmount => _allTransactions.where((t) => t.method == 'card').fold(0, (s, t) => s + t.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: [
          // ── Заголовок ────────────────────────────────────────────
          const Text('Транзакции', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
          const SizedBox(height: 4),
          Text('История платежей и поступлений', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 24),

          // ── Верхние карточки ──────────────────────────────────────
          Row(
            children: [
              Expanded(child: _topCard('За сегодня', _todayAmount, '+5.2%', false)),
              const SizedBox(width: 16),
              Expanded(child: _topCard('За месяц', _monthAmount, '+12.4%', false)),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: _topCardOrange('Всего получено', _totalAmount, '+8.1% к прошлому году')),
            ],
          ),

          const SizedBox(height: 20),

          // ── Категории + Фильтр ────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Категории
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _categoryCard(Icons.account_balance_wallet_outlined, 'Наличные', _cashAmount, const Color(0xFFED6A2E)),
                    const SizedBox(height: 10),
                    _categoryCard(Icons.credit_card_outlined, 'Карта', _cardAmount, const Color(0xFF6B7FD4)),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Фильтр поиска
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          // Поиск
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Поиск студента', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                const SizedBox(height: 6),
                                Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FB),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (_) => setState(() => _currentPage = 1),
                                    decoration: InputDecoration(
                                      hintText: 'Имя, фамилия или ID',
                                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                                      prefixIcon: Icon(Icons.search, size: 17, color: Colors.grey[400]),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Дата
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Дата', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                const SizedBox(height: 6),
                                Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FB),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 12),
                                      Icon(Icons.calendar_today_outlined, size: 15, color: Colors.grey[400]),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedDate == null
                                              ? 'дд.мм.гггг'
                                              : DateFormat('dd.MM.yyyy').format(_selectedDate!),
                                          style: TextStyle(fontSize: 13, color: _selectedDate == null ? Colors.grey[400] : const Color(0xFF1A2233)),
                                        ),
                                      ),
                                      if (_selectedDate != null)
                                        GestureDetector(
                                          onTap: () => setState(() { _selectedDate = null; _currentPage = 1; }),
                                          child: Icon(Icons.close, size: 14, color: Colors.grey[400]),
                                        ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: _pickDate,
                                        child: Icon(Icons.edit_calendar_outlined, size: 15, color: Colors.grey[400]),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Кнопка применить
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: ElevatedButton.icon(
                              onPressed: () => setState(() => _currentPage = 1),
                              icon: const Icon(Icons.tune, color: Colors.white, size: 15),
                              label: const Text('Применить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFED6A2E),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Таблица транзакций ────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                // Заголовок
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Row(
                    children: [
                      const Text('Последние транзакции', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Icon(Icons.download_outlined, size: 15, color: Color(0xFFED6A2E)),
                            const SizedBox(width: 6),
                            const Text('Скачать отчет', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFED6A2E))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Шапка
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.withOpacity(0.08))),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 4, child: _ColH('ИМЯ И ФАМИЛИЯ')),
                      Expanded(flex: 3, child: _ColH('ГРУППА')),
                      Expanded(flex: 2, child: _ColH('ДАТА')),
                      Expanded(flex: 2, child: _ColH('ТИП ОПЛАТЫ')),
                      Expanded(flex: 2, child: _ColH('СУММА')),
                      Expanded(flex: 2, child: _ColH('СТАТУС')),
                    ],
                  ),
                ),

                // Строки
                ..._pageItems.map(_transactionRow),

                // Пагинация
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                  child: Row(
                    children: [
                      Text('Показано ${_pageItems.length} из ${_filtered.length} транзакций', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                      const Spacer(),
                      _buildPagination(),
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

  // ── Верхние карточки ──────────────────────────────────────────────────────
  Widget _topCard(String label, int amount, String trend, bool highlight) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              const Spacer(),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: const Color(0xFFED6A2E).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFFED6A2E)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_fmt(amount), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.trending_up, size: 14, color: Color(0xFF2ECC8A)),
              const SizedBox(width: 4),
              Text(trend, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2ECC8A))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topCardOrange(String label, int amount, String sub) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFED6A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
              const Spacer(),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.account_balance_wallet_outlined, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_fmt(amount), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.trending_up, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text(sub, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(IconData icon, String label, int amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              const SizedBox(height: 2),
              Text(_fmt(amount), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
            ],
          ),
        ],
      ),
    );
  }

  // ── Строка транзакции ─────────────────────────────────────────────────────
  Widget _transactionRow(TransactionModel t) {
    final colors = [const Color(0xFFED6A2E), const Color(0xFF6B7FD4), const Color(0xFF2ECC8A), const Color(0xFFFF9800)];
    final idx = (t.firstName.codeUnitAt(0) + t.lastName.codeUnitAt(0)) % colors.length;
    final color = colors[idx];
    final initials = '${t.firstName[0]}${t.lastName[0]}'.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.06)))),
      child: Row(
        children: [
          // Имя
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(initials, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color))),
                ),
                const SizedBox(width: 10),
                Text('${t.firstName} ${t.lastName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2233))),
              ],
            ),
          ),
          // Группа
          Expanded(flex: 3, child: Text(t.group, style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
          // Дата
          Expanded(flex: 2, child: Text(DateFormat('dd.MM.yyyy').format(t.date), style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
          // Тип оплаты
          Expanded(
            flex: 2,
            child: _methodBadge(t.method),
          ),
          // Сумма
          Expanded(flex: 2, child: Text('${_fmt(t.amount)} ₽', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2233)))),
          // Статус
          Expanded(flex: 2, child: _statusWidget(t.status)),
        ],
      ),
    );
  }

  Widget _methodBadge(String method) {
    final isCard = method == 'card';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isCard ? const Color(0xFF6B7FD4).withOpacity(0.1) : const Color(0xFFED6A2E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isCard ? Icons.credit_card_outlined : Icons.account_balance_wallet_outlined, size: 12, color: isCard ? const Color(0xFF6B7FD4) : const Color(0xFFED6A2E)),
          const SizedBox(width: 5),
          Text(isCard ? 'КАРТА' : 'НАЛИЧНЫЕ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: isCard ? const Color(0xFF6B7FD4) : const Color(0xFFED6A2E), letterSpacing: 0.3)),
        ],
      ),
    );
  }

  Widget _statusWidget(String status) {
    Color color;
    String label;
    switch (status) {
      case 'done': color = const Color(0xFF2ECC8A); label = 'Выполнено'; break;
      case 'pending': color = const Color(0xFFFF9800); label = 'В обработке'; break;
      default: color = const Color(0xFFED6A2E); label = 'Отклонено'; break;
    }
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
      ],
    );
  }

  // ── Пагинация ─────────────────────────────────────────────────────────────
  Widget _buildPagination() {
    return Row(
      children: [
        _pgBtn(Icons.chevron_left, _currentPage > 1 ? () => setState(() => _currentPage--) : null),
        const SizedBox(width: 4),
        ...List.generate(_totalPages.clamp(0, 5), (i) {
          final p = i + 1;
          final active = p == _currentPage;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () => setState(() => _currentPage = p),
              child: Container(
                width: 32, height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFED6A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: active ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.25)),
                ),
                child: Text('$p', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : Colors.black87)),
              ),
            ),
          );
        }),
        _pgBtn(Icons.chevron_right, _currentPage < _totalPages ? () => setState(() => _currentPage++) : null),
      ],
    );
  }

  Widget _pgBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.25))),
        child: Icon(icon, size: 16, color: onTap == null ? Colors.grey[300] : Colors.black87),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFED6A2E), onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() { _selectedDate = picked; _currentPage = 1; });
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${buf.toString()} ₽';
  }
}

class TransactionModel {
  final String firstName;
  final String lastName;
  final String group;
  final String method;
  final int amount;
  final DateTime date;
  final String status;

  TransactionModel({
    required this.firstName,
    required this.lastName,
    required this.group,
    required this.method,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class _ColH extends StatelessWidget {
  final String text;
  const _ColH(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5));
  }
}