import 'package:flutter/material.dart';

enum SmsSendType { group, manual }
enum SmsCategory { newUsers, debtors, dueSoon, allUser }

class SmsNewUsersPage extends StatefulWidget {
  const SmsNewUsersPage({super.key});

  @override
  State<SmsNewUsersPage> createState() => _SmsNewUsersPageState();
}

class _Student {
  final String name;
  final String group;
  bool selected;
  _Student({required this.name, required this.group, this.selected = true});
}

class _SmsNewUsersPageState extends State<SmsNewUsersPage> {
  final _messageController = TextEditingController();

  SmsCategory _selectedCategory = SmsCategory.allUser;
  String _selectedGroup = '';

  final List<String> _groups = ['Курс 1', 'Курс 2', 'Дизайнеры', 'Разработчики'];

  final List<_Student> _students = [
    _Student(name: 'Александр Иванов',  group: 'Б-ИНФ-21'),
    _Student(name: 'Елена Смирнова',    group: 'Д-ГРАФ-22'),
    _Student(name: 'Дмитрий Петров',    group: 'Б-ИНФ-21'),
    _Student(name: 'Мария Соколова',    group: 'М-МАРК-20'),
    _Student(name: 'Игорь Кузнецов',    group: 'Б-ИНФ-21'),
    _Student(name: 'Анна Волкова',      group: 'Д-ГРАФ-22'),
    _Student(name: 'Сергей Морозов',    group: 'М-МАРК-20'),
  ];

  int get _selectedCount => _students.where((s) => s.selected).length;
  bool get _allSelected  => _students.every((s) => s.selected);

  String get _charCount => '${_messageController.text.length} / 160 символов (1 SMS)';
  double get _estimatedCost => _selectedCount * 2.0; // 2 сум за SMS

  String _getCategoryLabel(SmsCategory c) {
    switch (c) {
      case SmsCategory.allUser:   return 'Все студенты (1,240)';
      case SmsCategory.newUsers:  return 'Новые пользователи';
      case SmsCategory.debtors:   return 'Должники';
      case SmsCategory.dueSoon:   return 'Подходит срок оплаты';
    }
  }

  void _send() {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите текст сообщения')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SMS отправлено $_selectedCount получателям ✅')));
    _messageController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Левая колонка ────────────────────────────────────────
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              child: Column(
                children: [
                  // Выбор получателей
                  _card(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Выбор получателей',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                      const SizedBox(height: 6),
                      Text('Выберите категорию или группу',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      const SizedBox(height: 14),

                      // Дропдаун категории
                      Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.15)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SmsCategory>(
                            value: _selectedCategory,
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
                            style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233)),
                            items: SmsCategory.values.map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(_getCategoryLabel(c)),
                            )).toList(),
                            onChanged: (v) => setState(() => _selectedCategory = v!),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Чипы групп
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: _groups.map((g) {
                          final active = _selectedGroup == g;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedGroup = active ? '' : g),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: active ? const Color(0xFFED6A2E).withOpacity(0.1) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: active ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (active) ...[
                                    const Icon(Icons.check_circle, size: 14, color: Color(0xFFED6A2E)),
                                    const SizedBox(width: 5),
                                  ],
                                  Text(g, style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600,
                                    color: active ? const Color(0xFFED6A2E) : Colors.grey[700],
                                  )),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )),

                  const SizedBox(height: 14),

                  // Список студентов
                  _card(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Список студентов',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                          const Spacer(),
                          Text('Выбрано: $_selectedCount',
                              style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Шапка
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            _headerCheckbox(),
                            const SizedBox(width: 16),
                            Expanded(child: Text('ФИО Студента', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[400]))),
                            Text('Группа', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[400])),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey.withOpacity(0.08), height: 1),

                      ..._students.map(_studentRow),
                    ],
                  )),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // ── Правая колонка — сообщение ────────────────────────────
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              child: _card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Текст сообщения',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                  const SizedBox(height: 16),

                  Text('Содержание SMS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                  const SizedBox(height: 8),

                  // Поле ввода
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 8,
                      maxLength: 160,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
                      decoration: InputDecoration(
                        hintText: 'Введите текст сообщения здесь...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Счётчик + шаблон
                  Row(
                    children: [
                      Text(_charCount, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _messageController.text = 'Здравствуйте, {имя}! '),
                        child: Row(
                          children: [
                            Icon(Icons.auto_fix_high_outlined, size: 13, color: const Color(0xFFED6A2E)),
                            const SizedBox(width: 4),
                            const Text('Использовать шаблон',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFED6A2E))),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Параметры персонализации
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFED6A2E).withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFED6A2E).withOpacity(0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 16, color: const Color(0xFFED6A2E)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Параметры персонализации',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                              const SizedBox(height: 4),
                              Text('Используйте {имя} для подстановки имени студента автоматически.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Стоимость
                  Row(
                    children: [
                      Text('Примерная стоимость:', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                      const Spacer(),
                      Text('~ ${_estimatedCost.toStringAsFixed(2)} сум',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Кнопка отправить
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _send,
                      icon: const Icon(Icons.send_outlined, color: Colors.white, size: 18),
                      label: const Text('Отправить рассылку',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED6A2E),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      'Нажимая кнопку, вы подтверждаете согласие с правилами обработки\nперсональных данных и антиспам-политикой сервиса.',
                      style: TextStyle(fontSize: 10, color: Colors.grey[400], height: 1.5),
                      textAlign: TextAlign.center,
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

  Widget _headerCheckbox() {
    return GestureDetector(
      onTap: () => setState(() {
        final v = !_allSelected;
        for (final s in _students) s.selected = v;
      }),
      child: Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          color: _allSelected ? const Color(0xFFED6A2E) : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: _allSelected ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.4)),
        ),
        child: _allSelected ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
      ),
    );
  }

  Widget _studentRow(_Student s) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.06)))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => s.selected = !s.selected),
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: s.selected ? const Color(0xFFED6A2E) : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: s.selected ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.4)),
              ),
              child: s.selected ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A2233))),
          ),
          Text(s.group, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
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
}