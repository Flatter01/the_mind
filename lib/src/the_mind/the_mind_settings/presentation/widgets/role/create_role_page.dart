import 'package:flutter/material.dart';

class CreateRolePage extends StatefulWidget {
  const CreateRolePage({super.key});

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

class _RoleData {
  final String name;
  final String description;
  final Map<String, Map<String, bool>> modules;
  _RoleData({required this.name, required this.description, required this.modules});
}

class _Module {
  final String name;
  final String subtitle;
  _Module(this.name, this.subtitle);
}

class _CreateRolePageState extends State<CreateRolePage> {
  int _selectedRole = 0;
  final _ipController = TextEditingController();
  final List<String> _ipList = [];

  final List<_Module> _modules = [
    _Module('Пользователи',  'Управление аккаунтами сотрудников'),
    _Module('Финансы',       'Доступ к кассе и транзакциям'),
    _Module('Занятия',       'Расписание и учебные планы'),
    _Module('Логи системы',  'Журнал действий и аудита'),
    _Module('Отчетность',    'Выгрузка статистики и данных'),
  ];

  final List<_RoleData> _roles = [
    _RoleData(name: 'Админ',    description: 'Полный доступ ко всем функциям системы',
      modules: {
        'Пользователи': {'view': true,  'create': true,  'edit': true,  'delete': true},
        'Финансы':      {'view': true,  'create': true,  'edit': true,  'delete': false},
        'Занятия':      {'view': true,  'create': true,  'edit': true,  'delete': true},
        'Логи системы': {'view': true,  'create': false, 'edit': false, 'delete': false},
        'Отчетность':   {'view': true,  'create': true,  'edit': true,  'delete': true},
      }),
    _RoleData(name: 'Учитель',  description: 'Доступ к занятиям и студентам',
      modules: {
        'Пользователи': {'view': true,  'create': false, 'edit': false, 'delete': false},
        'Финансы':      {'view': false, 'create': false, 'edit': false, 'delete': false},
        'Занятия':      {'view': true,  'create': true,  'edit': true,  'delete': false},
        'Логи системы': {'view': false, 'create': false, 'edit': false, 'delete': false},
        'Отчетность':   {'view': true,  'create': false, 'edit': false, 'delete': false},
      }),
    _RoleData(name: 'Менеджер', description: 'Управление группами и расписанием',
      modules: {
        'Пользователи': {'view': true,  'create': true,  'edit': true,  'delete': false},
        'Финансы':      {'view': true,  'create': true,  'edit': false, 'delete': false},
        'Занятия':      {'view': true,  'create': true,  'edit': true,  'delete': false},
        'Логи системы': {'view': true,  'create': false, 'edit': false, 'delete': false},
        'Отчетность':   {'view': true,  'create': true,  'edit': false, 'delete': false},
      }),
    _RoleData(name: 'Кассир',   description: 'Доступ только к финансам',
      modules: {
        'Пользователи': {'view': false, 'create': false, 'edit': false, 'delete': false},
        'Финансы':      {'view': true,  'create': true,  'edit': true,  'delete': false},
        'Занятия':      {'view': false, 'create': false, 'edit': false, 'delete': false},
        'Логи системы': {'view': false, 'create': false, 'edit': false, 'delete': false},
        'Отчетность':   {'view': true,  'create': false, 'edit': false, 'delete': false},
      }),
  ];

  final List<Map<String, String>> _history = [
    {'time': 'Сегодня, 14:20',  'text': 'Изменено: Админ (Иванов)'},
    {'time': 'Вчера, 09:15',    'text': 'Изменено: Система (Обновление)'},
    {'time': '12 Окт, 18:44',   'text': 'Создано: Админ (Петров)'},
  ];

  _RoleData get _current => _roles[_selectedRole];

  void _reset() => setState(() {});

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Изменения сохранены ✅')));
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Заголовок ──────────────────────────────────────────
            const Text('Роли пользователей',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
            const SizedBox(height: 4),
            Text('Создание и редактирование прав доступа для сотрудников организации',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),

            const SizedBox(height: 20),

            // ── Вкладки ролей ──────────────────────────────────────
            Row(
              children: List.generate(_roles.length, (i) {
                final active = _selectedRole == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRole = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: active ? const Color(0xFFED6A2E) : Colors.transparent,
                        width: 2,
                      )),
                    ),
                    child: Text(_roles[i].name, style: TextStyle(
                      fontSize: 14, fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      color: active ? const Color(0xFFED6A2E) : Colors.grey[600],
                    )),
                  ),
                );
              }),
            ),
            Divider(color: Colors.grey.withOpacity(0.15), height: 1),

            const SizedBox(height: 20),

            // ── Карточка разрешений ────────────────────────────────
            _card(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2233)),
                            children: [
                              const TextSpan(text: 'Настройка разрешений: '),
                              TextSpan(text: _current.name,
                                  style: const TextStyle(color: Color(0xFFED6A2E))),
                            ],
                          )),
                          const SizedBox(height: 4),
                          Text(_current.description, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _reset,
                      child: Text('Сбросить', style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED6A2E), elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Сохранить изменения', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Шапка таблицы
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: const [
                      Expanded(flex: 4, child: _CH('МОДУЛЬ')),
                      Expanded(flex: 2, child: _CH('ПРОСМОТР')),
                      Expanded(flex: 2, child: _CH('СОЗДАНИЕ')),
                      Expanded(flex: 2, child: _CH('РЕДАКТИРОВАНИЕ')),
                      Expanded(flex: 2, child: _CH('УДАЛЕНИЕ')),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.withOpacity(0.08), height: 1),

                // Строки модулей
                ..._modules.map((m) {
                  final perms = _current.modules[m.name] ?? {'view': false, 'create': false, 'edit': false, 'delete': false};
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.06)))),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                              Text(m.subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: _permBox(perms['view']!, () => setState(() => perms['view'] = !perms['view']!))),
                        Expanded(flex: 2, child: _permBox(perms['create']!, () => setState(() => perms['create'] = !perms['create']!))),
                        Expanded(flex: 2, child: _permBox(perms['edit']!, () => setState(() => perms['edit'] = !perms['edit']!))),
                        Expanded(flex: 2, child: _permBox(perms['delete']!, () => setState(() => perms['delete'] = !perms['delete']!))),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Нижняя строка
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 6),
                    Text('Изменения вступят в силу после перезахода пользователя в систему.',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400], fontStyle: FontStyle.italic)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 14, color: Colors.red[400]),
                          const SizedBox(width: 4),
                          Text('Удалить роль', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red[400])),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),

            const SizedBox(height: 16),

            // ── Нижние карточки ────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ограничения по IP
                Expanded(
                  child: _card(child: Column(
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
                            child: const Icon(Icons.security_outlined, size: 16, color: Color(0xFFED6A2E)),
                          ),
                          const SizedBox(width: 10),
                          const Text('Ограничения по IP',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Разрешить доступ к этой роли только с определённых IP-адресов или подсетей.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.5)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FB),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.withOpacity(0.15)),
                              ),
                              child: TextField(
                                controller: _ipController,
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: '192.168.1.1',
                                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_ipController.text.trim().isNotEmpty) {
                                  setState(() {
                                    _ipList.add(_ipController.text.trim());
                                    _ipController.clear();
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A2233), elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Добавить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                      if (_ipList.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6, runSpacing: 6,
                          children: _ipList.map((ip) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFED6A2E).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(ip, style: const TextStyle(fontSize: 12, color: Color(0xFFED6A2E))),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => setState(() => _ipList.remove(ip)),
                                  child: const Icon(Icons.close, size: 12, color: Color(0xFFED6A2E)),
                                ),
                              ],
                            ),
                          )).toList(),
                        ),
                      ],
                    ],
                  )),
                ),

                const SizedBox(width: 16),

                // История изменений
                Expanded(
                  child: _card(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B7FD4).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.history, size: 16, color: Color(0xFF6B7FD4)),
                          ),
                          const SizedBox(width: 10),
                          const Text('История изменений роли',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._history.map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            Text(h['time']!, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                            const Spacer(),
                            Text(h['text']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                          ],
                        ),
                      )),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Показать все логи',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFED6A2E))),
                      ),
                    ],
                  )),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _permBox(bool value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          color: value ? const Color(0xFFED6A2E) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: value ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.3), width: 1.5),
        ),
        child: value ? const Icon(Icons.check, size: 15, color: Colors.white) : null,
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: child,
  );
}

class _CH extends StatelessWidget {
  final String text;
  const _CH(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5));
}