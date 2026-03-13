import 'package:flutter/material.dart';

class BranchManagerPage extends StatefulWidget {
  const BranchManagerPage({super.key});

  @override
  State<BranchManagerPage> createState() => _BranchManagerPageState();
}

class _Branch {
  final String name;
  final String address;
  final String manager;
  final String phone;
  bool isCurrent;

  _Branch({required this.name, required this.address, required this.manager, required this.phone, this.isCurrent = false});
}

class _BranchManagerPageState extends State<BranchManagerPage> {
  String _filter = 'Все ветки';

  final _nameCtrl    = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  String _selectedStaff = 'Выберите сотрудника';

  final List<String> _staff = ['Выберите сотрудника', 'Александр Петров', 'Елена Сидорова', 'Иван Волков', 'Мария Иванова'];

  final List<_Branch> _branches = [
    _Branch(name: 'Центральный офис', address: 'ул. Ленина, д. 10, Москва',        manager: 'Александр Петров', phone: '+7 (495) 123-45-67', isCurrent: true),
    _Branch(name: 'Филиал Север',     address: 'пр. Мира, д. 42, Санкт-Петербург', manager: 'Елена Сидорова',   phone: '+7 (812) 987-65-43'),
    _Branch(name: 'Южный Хаб',        address: 'ул. Садовая, д. 15, Краснодар',    manager: 'Иван Волков',      phone: '+7 (861) 555-01-99'),
  ];

  List<_Branch> get _filtered {
    if (_filter == 'Мои ветки')  return _branches.where((b) => b.isCurrent).toList();
    if (_filter == 'Активные')   return _branches;
    return _branches;
  }

  void _switchTo(_Branch b) => setState(() {
    for (final br in _branches) br.isCurrent = false;
    b.isCurrent = true;
  });

  void _create() {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() {
      _branches.add(_Branch(
        name: _nameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        manager: _selectedStaff == 'Выберите сотрудника' ? '' : _selectedStaff,
        phone: _phoneCtrl.text.trim(),
      ));
      _nameCtrl.clear(); _addressCtrl.clear(); _phoneCtrl.clear();
      _selectedStaff = 'Выберите сотрудника';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Филиал создан ✅')));
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _addressCtrl.dispose(); _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Вкладки ─────────────────────────────────────────────
          Row(
            children: ['Все ветки', 'Мои ветки', 'Активные'].map((f) {
              final active = _filter == f;
              return GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: active ? const Color(0xFFED6A2E) : Colors.transparent,
                      width: 2,
                    )),
                  ),
                  child: Text(f, style: TextStyle(
                    fontSize: 14, fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? const Color(0xFFED6A2E) : Colors.grey[600],
                  )),
                ),
              );
            }).toList(),
          ),
          Divider(color: Colors.grey.withOpacity(0.15), height: 1),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Список филиалов ────────────────────────────────
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFED6A2E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.list_alt_outlined, size: 16, color: Color(0xFFED6A2E)),
                          ),
                          const SizedBox(width: 10),
                          const Text('Список активных филиалов',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) => _branchCard(_filtered[i]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // ── Правая панель ──────────────────────────────────
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      // Форма
                      _card(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_circle_outline, color: const Color(0xFFED6A2E), size: 18),
                              const SizedBox(width: 8),
                              const Text('Новая ветка',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _fl('Название филиала'),
                          const SizedBox(height: 6),
                          _input(_nameCtrl, 'Напр. Восток-1'),

                          const SizedBox(height: 12),
                          _fl('Адрес'),
                          const SizedBox(height: 6),
                          _input(_addressCtrl, 'Город, улица, дом'),

                          const SizedBox(height: 12),
                          _fl('Телефон'),
                          const SizedBox(height: 6),
                          _input(_phoneCtrl, '+7 (___) ___-_-__', keyboard: TextInputType.phone),

                          const SizedBox(height: 12),
                          _fl('Ответственное лицо'),
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
                                value: _selectedStaff,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[500]),
                                style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
                                items: _staff.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                onChanged: (v) => setState(() => _selectedStaff = v!),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _create,
                              icon: const Icon(Icons.store_outlined, color: Colors.white, size: 16),
                              label: const Text('Создать филиал',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFED6A2E), elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: TextButton(
                              onPressed: () {
                                _nameCtrl.clear(); _addressCtrl.clear(); _phoneCtrl.clear();
                                setState(() => _selectedStaff = 'Выберите сотрудника');
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF2F5F7),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Отмена', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      )),

                      const SizedBox(height: 14),

                      // Совет
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFED6A2E).withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFED6A2E).withOpacity(0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('СОВЕТ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFED6A2E), letterSpacing: 0.5)),
                            const SizedBox(height: 8),
                            Text(
                              'Используйте кнопку "Переключиться" для быстрой смены контекста работы между филиалами. Все данные будут фильтроваться по выбранному объекту.',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _branchCard(_Branch b) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: b.isCurrent ? Border.all(color: const Color(0xFFED6A2E).withOpacity(0.3)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(b.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
              const SizedBox(width: 10),
              if (b.isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED6A2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('CURRENT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFFED6A2E), letterSpacing: 0.5)),
                ),
              const Spacer(),
              if (!b.isCurrent)
                OutlinedButton(
                  onPressed: () => _switchTo(b),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Переключиться', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                ),
              const SizedBox(width: 8),
              Icon(Icons.edit_outlined, size: 16, color: Colors.grey[400]),
              if (!b.isCurrent) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _branches.remove(b)),
                  child: Icon(Icons.more_vert, size: 16, color: Colors.grey[400]),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(b.address, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 10),
          Row(
            children: [
              if (b.manager.isNotEmpty) ...[
                Icon(Icons.person_outline, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(b.manager, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(width: 16),
              ],
              if (b.phone.isNotEmpty) ...[
                Icon(Icons.phone_outlined, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(b.phone, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: child,
  );

  Widget _fl(String text) => Text(text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A2233)));

  Widget _input(TextEditingController c, String hint, {TextInputType keyboard = TextInputType.text}) =>
      Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        child: TextField(
          controller: c,
          keyboardType: keyboard,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      );
}