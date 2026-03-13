import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_workers/the_mind_workes_profile.dart';
import 'package:srm/src/the_mind/the_mind_workers/widgets/add_worker_dialog.dart';
import 'package:srm/src/the_mind/the_mind_workers/widgets/build_workers_table.dart';
import 'package:srm/src/the_mind/the_mind_workers/widgets/edit_worker_dialog.dart';

class TheMindWorkersPage extends StatefulWidget {
  const TheMindWorkersPage({super.key});

  @override
  State<TheMindWorkersPage> createState() => _TheMindWorkersPageState();
}

class _TheMindWorkersPageState extends State<TheMindWorkersPage> {
  final List<BuildWorkersTableItem> _workers = [
    BuildWorkersTableItem(
      name: 'Александр',
      surname: 'Волков',
      role: 'Учитель',
      phone: '+7 (900) 123-45-67',
      isActive: true,
    ),
    BuildWorkersTableItem(
      name: 'Елена',
      surname: 'Соколова',
      role: 'Администратор',
      phone: '+7 (911) 987-65-43',
      isActive: true,
    ),
    BuildWorkersTableItem(
      name: 'Дмитрий',
      surname: 'Петров',
      role: 'Менеджер',
      phone: '+7 (922) 555-12-12',
      isActive: false,
    ),
    BuildWorkersTableItem(
      name: 'Марина',
      surname: 'Иванова',
      role: 'Учитель',
      phone: '+7 (950) 444-33-22',
      isActive: true,
    ),
    BuildWorkersTableItem(
      name: 'Сергей',
      surname: 'Морозов',
      role: 'Администратор',
      phone: '+7 (933) 222-11-00',
      isActive: true,
    ),
  ];

  String _search = '';
  String _roleFilter =
      'Все'; // 'Все' | 'Учителя' | 'Администраторы' | 'Менеджеры'
  String _sortBy = 'По алфавиту';

  List<BuildWorkersTableItem> get _filtered {
    var list = _workers.where((w) {
      final q = _search.toLowerCase();
      final matchSearch =
          w.name.toLowerCase().contains(q) ||
          w.surname.toLowerCase().contains(q) ||
          w.phone.toLowerCase().contains(q);
      final matchRole =
          _roleFilter == 'Все' ||
          (_roleFilter == 'Учителя' && w.role == 'Учитель') ||
          (_roleFilter == 'Администраторы' && w.role == 'Администратор') ||
          (_roleFilter == 'Менеджеры' && w.role == 'Менеджер');
      return matchSearch && matchRole;
    }).toList();

    if (_sortBy == 'По алфавиту') {
      list.sort((a, b) => a.surname.compareTo(b.surname));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Заголовок ──────────────────────────────────────────────
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Сотрудники',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A2233),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Управление командой и правами доступа',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _openAddDialog,
                  icon: const Icon(
                    Icons.person_add_outlined,
                    color: Colors.white,
                    size: 17,
                  ),
                  label: const Text(
                    'Добавить сотрудника',
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
              ],
            ),

            const SizedBox(height: 24),

            // ── Поиск + фильтры ────────────────────────────────────────
            Row(
              children: [
                // Поиск
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        hintText: 'Поиск по имени, фамилии или телефону...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Фильтр-чипы
                ...[
                  ('Все', 'Все'),
                  ('Учителя', 'Учителя'),
                  ('Администраторы', 'Администраторы'),
                  ('Менеджеры', 'Менеджеры'),
                ].map((item) {
                  final isActive = _roleFilter == item.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _roleFilter = item.$1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFED6A2E)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFFED6A2E)
                                : Colors.grey.withOpacity(0.2),
                          ),
                          boxShadow: isActive
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                  ),
                                ],
                        ),
                        child: Text(
                          item.$2,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 12),

            // ── Сортировка ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Сортировать:',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        _sortBy,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Грид карточек ──────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.55,
                ),
                itemCount:
                    filtered.length + 1, // +1 для кнопки "Новый сотрудник"
                itemBuilder: (_, i) {
                  if (i == filtered.length) return _addNewCard();
                  return _workerCard(filtered[i]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Карточка сотрудника ───────────────────────────────────────────────────
  Widget _workerCard(BuildWorkersTableItem w) {
    final roleColor = _roleColor(w.role);

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
          // Аватар + имя + статус
          Row(
            children: [
              _avatar(w),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Статус
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: w.isActive
                                ? const Color(0xFF2ECC8A)
                                : Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          w.isActive ? 'Активен' : 'Не активен',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: w.isActive
                                ? const Color(0xFF2ECC8A)
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${w.name} ${w.surname}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      w.role,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: roleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Телефон
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14,
                color: w.isActive ? Colors.grey[500] : Colors.grey[350],
              ),
              const SizedBox(width: 6),
              Text(
                w.phone,
                style: TextStyle(
                  fontSize: 12,
                  color: w.isActive ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Email
          Row(
            children: [
              Icon(
                Icons.mail_outline,
                size: 14,
                color: w.isActive ? Colors.grey[500] : Colors.grey[350],
              ),
              const SizedBox(width: 6),
              Text(
                '${w.name.toLowerCase()}@center.ru',
                style: TextStyle(
                  fontSize: 12,
                  color: w.isActive ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ],
          ),

          const Spacer(),

          // Кнопки
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TheMindWorkesProfile()),
                    );
                  },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F5F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Профиль',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F5F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          const Text('Редактировать'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Color(0xFFED6A2E),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Удалить',
                            style: TextStyle(color: Color(0xFFED6A2E)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'edit') _openEditDialog(w);
                    if (v == 'delete') _deleteWorker(w);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Аватар ───────────────────────────────────────────────────────────────
  Widget _avatar(BuildWorkersTableItem w) {
    final colors = [
      const Color(0xFFED6A2E),
      const Color(0xFF6B7FD4),
      const Color(0xFF2ECC8A),
      const Color(0xFFFF9800),
      const Color(0xFF9C59D1),
    ];
    final idx =
        (w.name.codeUnitAt(0) + w.surname.codeUnitAt(0)) % colors.length;
    final color = w.isActive ? colors[idx] : Colors.grey[400]!;
    final initials = '${w.name[0]}${w.surname[0]}'.toUpperCase();

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }

  // ── Карточка "Новый сотрудник" ────────────────────────────────────────────
  Widget _addNewCard() {
    return GestureDetector(
      onTap: _openAddDialog,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, size: 22, color: Color(0xFF8A9BB8)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Новый сотрудник',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8A9BB8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'Администратор':
        return const Color(0xFFED6A2E);
      case 'Учитель':
        return const Color(0xFFED6A2E);
      case 'Менеджер':
        return Colors.grey;
      default:
        return const Color(0xFFED6A2E);
    }
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddWorkerDialog(
        onAdd: (worker) => setState(() => _workers.add(worker)),
      ),
    );
  }

  void _openEditDialog(BuildWorkersTableItem worker) {
    showDialog(
      context: context,
      builder: (_) =>
          EditWorkerDialog(worker: worker, onSave: () => setState(() {})),
    );
  }

  void _deleteWorker(BuildWorkersTableItem worker) {
    setState(() => _workers.remove(worker));
  }
}
