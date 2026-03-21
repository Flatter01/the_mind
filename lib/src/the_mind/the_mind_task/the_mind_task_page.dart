import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_task/widgets/list_row.dart';

const _orange = Color(0xFFED6A2E);
const _bg = Color(0xFFF2F5F7);
const _white = Colors.white;
const _text = Color(0xFF1A2233);
const _grey = Color(0xFF8A94A6);

enum TaskStatus { todo, inProgress, review, done }

class TaskModel {
  String title;
  String description;
  String tag;
  Color tagColor;
  TaskStatus status;
  double? progress;
  String? deadline;
  bool deadlineSoon;
  bool done;

  TaskModel({
    required this.title,
    required this.description,
    required this.tag,
    required this.tagColor,
    required this.status,
    this.progress,
    this.deadline,
    this.deadlineSoon = false,
    this.done = false,
  });
}

class TheMindTaskPage extends StatefulWidget {
  const TheMindTaskPage({super.key});

  @override
  State<TheMindTaskPage> createState() => _TheMindTaskPageState();
}

class _TheMindTaskPageState extends State<TheMindTaskPage> {
  String _view = 'board';

  final List<TaskModel> _tasks = [
    TaskModel(
      title: 'Обновить баннеры для соцсетей',
      description:
          'Создать сет из 5 баннеров для рекламной кампании "Осень 2023".',
      tag: 'ДИЗАЙН',
      tagColor: Color(0xFFFF9800),
      status: TaskStatus.todo,
      deadline: '26 Окт',
    ),
    TaskModel(
      title: 'Статья в блог: Тренды UI',
      description:
          'Написать лонгрид про актуальные тренды в дизайне интерфейсов.',
      tag: 'КОПИРАЙТ',
      tagColor: Color(0xFF6B7FD4),
      status: TaskStatus.todo,
      deadline: 'Завтра',
      deadlineSoon: true,
    ),
    TaskModel(
      title: 'SEO аудит лендинга',
      description: 'Провести полный SEO аудит и составить список правок.',
      tag: 'МАРКЕТИНГ',
      tagColor: Color(0xFF2ECC8A),
      status: TaskStatus.todo,
      deadline: '30 Окт',
    ),
    TaskModel(
      title: 'Интеграция Stripe API',
      description: 'Настройка платежной системы для новых тарифов подписки.',
      tag: 'РАЗРАБОТКА',
      tagColor: Color(0xFF2ECC8A),
      status: TaskStatus.inProgress,
      progress: 0.65,
      deadline: '28 Окт',
    ),
    TaskModel(
      title: 'Фикс багов верстки Лендинга',
      description:
          'Исправить отображение карточек на мобильных устройствах до 360px.',
      tag: 'QA',
      tagColor: Color(0xFF9B59B6),
      status: TaskStatus.review,
    ),
    TaskModel(
      title: 'Редизайн страницы о компании',
      description: 'Обновить визуал и текстовый контент страницы About.',
      tag: 'ДИЗАЙН',
      tagColor: Color(0xFFFF9800),
      status: TaskStatus.review,
    ),
    TaskModel(
      title: 'Настройка CI/CD',
      description: 'Автоматизировать деплой на тестовый сервер.',
      tag: 'DEVOPS',
      tagColor: Color(0xFF6B7FD4),
      status: TaskStatus.done,
      done: true,
    ),
    TaskModel(
      title: 'Обновить документацию API',
      description: 'Дополнить Swagger актуальными эндпоинтами.',
      tag: 'РАЗРАБОТКА',
      tagColor: Color(0xFF2ECC8A),
      status: TaskStatus.done,
      done: true,
    ),
  ];

  static const _statusLabels = [
    'Нужно сделать',
    'В работе',
    'На проверке',
    'Выполнено',
  ];

  static const _statusColors = [
    Color(0xFF6B7FD4),
    Color(0xFFFF9800),
    Color(0xFF9B59B6),
    Color(0xFF2ECC8A),
  ];

  static const _cols = [
    {
      'status': TaskStatus.todo,
      'label': 'НУЖНО СДЕЛАТЬ',
      'color': Color(0xFF6B7FD4),
    },
    {
      'status': TaskStatus.inProgress,
      'label': 'В РАБОТЕ',
      'color': Color(0xFFFF9800),
    },
    {
      'status': TaskStatus.review,
      'label': 'НА ПРОВЕРКЕ',
      'color': Color(0xFF9B59B6),
    },
    {
      'status': TaskStatus.done,
      'label': 'ВЫПОЛНЕНО',
      'color': Color(0xFF2ECC8A),
    },
  ];

  List<TaskModel> _byStatus(TaskStatus s) =>
      _tasks.where((t) => t.status == s).toList();

  void _showCreateDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String tag = 'ДИЗАЙН';
    TaskStatus status = TaskStatus.todo;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 32,
          ),
          elevation: 0,
          child: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(28, 24, 16, 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add_task_rounded,
                          color: _orange,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Создать задачу',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dLabel('НАЗВАНИЕ'),
                        const SizedBox(height: 8),
                        _dField(
                          titleCtrl,
                          'Название задачи',
                          Icons.title_rounded,
                        ),
                        const SizedBox(height: 16),
                        _dLabel('ОПИСАНИЕ'),
                        const SizedBox(height: 8),
                        _dArea(descCtrl),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dLabel('ТЕГ'),
                                  const SizedBox(height: 8),
                                  _dDropdown(
                                    [
                                      'ДИЗАЙН',
                                      'РАЗРАБОТКА',
                                      'КОПИРАЙТ',
                                      'QA',
                                      'МАРКЕТИНГ',
                                      'DEVOPS',
                                    ],
                                    tag,
                                    (v) => setLocal(() => tag = v!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dLabel('СТАТУС'),
                                  const SizedBox(height: 8),
                                  _dDropdown(
                                    _statusLabels,
                                    _statusLabels[status.index],
                                    (v) => setLocal(
                                      () => status = TaskStatus
                                          .values[_statusLabels.indexOf(v!)],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.12)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Отмена',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (titleCtrl.text.trim().isEmpty) return;
                            setState(
                              () => _tasks.insert(
                                0,
                                TaskModel(
                                  title: titleCtrl.text.trim(),
                                  description: descCtrl.text.trim(),
                                  tag: tag,
                                  tagColor: _orange,
                                  status: status,
                                ),
                              ),
                            );
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Создать',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Задачи отдела маркетинга',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: _text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Сегодня: 24 Октября, 2023',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // ── Статистика ──
                      ...TaskStatus.values.map((s) {
                        final count = _byStatus(s).length;
                        final color = _statusColors[s.index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: color.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(width: 4),
                      _CreateButton(onTap: _showCreateDialog),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _viewBtn(Icons.grid_view_rounded, 'Доска', 'board'),
                      const SizedBox(width: 4),
                      _viewBtn(Icons.list_rounded, 'Список', 'list'),
                    ],
                  ),
                  Divider(color: Colors.grey.withOpacity(0.12), height: 20),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
              child: _view == 'board' ? _boardView() : _listView(),
            ),
          ),
        ],
      ),
    );
  }

  // ── ДОСКА ─────────────────────────────────────────────────────────────────

  Widget _boardView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _cols.map((col) {
        final status = col['status'] as TaskStatus;
        final label = col['label'] as String;
        final color = col['color'] as Color;
        final tasks = _byStatus(status);
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14, right: 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[500],
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${tasks.length}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(right: 12),
                  children: tasks.map((t) => _taskCard(t)).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _taskCard(TaskModel t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tagChip(t.tag, t.tagColor),
              const Spacer(),
              if (!t.done && t.deadlineSoon)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.priority_high,
                    size: 12,
                    color: _orange,
                  ),
                ),
              const SizedBox(width: 4),

              // ✅ Три точки с меню смены статуса
              PopupMenuButton<TaskStatus>(
                onSelected: (selected) {
                  setState(() {
                    t.status = selected;
                    t.done = selected == TaskStatus.done;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                itemBuilder: (_) => TaskStatus.values.map((s) {
                  return PopupMenuItem<TaskStatus>(
                    value: s,
                    padding: EdgeInsets.zero,
                    child: _StatusMenuItem(
                      label: _statusLabels[s.index],
                      color: _statusColors[s.index],
                      isActive: t.status == s,
                    ),
                  );
                }).toList(),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(
            t.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.35,
              decoration: t.done ? TextDecoration.lineThrough : null,
              color: t.done ? Colors.grey[400] : _text,
            ),
          ),
          if (t.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              t.description,
              style: TextStyle(
                fontSize: 12,
                color: t.done ? Colors.grey[400] : Colors.grey[500],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (t.progress != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Прогресс',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _text,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(t.progress! * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: t.progress,
                minHeight: 5,
                backgroundColor: Colors.grey.withOpacity(0.12),
                valueColor: const AlwaysStoppedAnimation<Color>(_orange),
              ),
            ),
          ],
          if (t.deadline != null ||
              t.done ||
              t.status == TaskStatus.review) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: t.tagColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 13,
                    color: t.tagColor,
                  ),
                ),
                const Spacer(),
                if (t.status == TaskStatus.review)
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Проверяется',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  )
                else if (t.done)
                  Text(
                    'ГОТОВО',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[400],
                      letterSpacing: 0.5,
                    ),
                  )
                else if (t.deadline != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: t.deadlineSoon ? _orange : Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        t.deadline!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: t.deadlineSoon ? _orange : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── СПИСОК (улучшенный UI) ────────────────────────────────────────────────

  Widget _listView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
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
          // ── Заголовок ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 34), // под чекбокс
                SizedBox(width: 14),
                Expanded(flex: 5, child: _CH('ЗАДАЧА')),
                Expanded(flex: 2, child: _CH('ТЕГ')),
                Expanded(flex: 2, child: _CH('СТАТУС')),
                Expanded(flex: 2, child: _CH('ДЕДЛАЙН')),
                SizedBox(width: 40),
              ],
            ),
          ),

          // ── Строки ──
          Expanded(
            child: ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.grey.withOpacity(0.07), height: 1),
              itemBuilder: (_, i) {
                final t = _tasks[i];
                return ListRow(
                  task: t,
                  onStatusChanged: (selected) {
                    setState(() {
                      t.status = selected;
                      t.done = selected == TaskStatus.done;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Хелперы ───────────────────────────────────────────────────────────────

  Widget _tagChip(String tag, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      tag,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _viewBtn(IconData icon, String label, String mode) {
    final active = _view == mode;
    return GestureDetector(
      onTap: () => setState(() => _view = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? _orange : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: active ? _orange : Colors.grey[500]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? _orange : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon) => Container(
    width: 38,
    height: 38,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.withOpacity(0.15)),
    ),
    child: Icon(icon, size: 18, color: Colors.grey[600]),
  );

  Widget _dLabel(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: _grey,
      letterSpacing: 0.8,
    ),
  );

  Widget _dField(TextEditingController c, String hint, IconData icon) =>
      TextFormField(
        controller: c,
        style: const TextStyle(fontSize: 13, color: _text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: _grey),
          prefixIcon: Icon(icon, size: 17, color: _grey),
          filled: true,
          fillColor: const Color(0xFFF7F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _orange, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      );

  Widget _dArea(TextEditingController c) => TextFormField(
    controller: c,
    maxLines: 3,
    style: const TextStyle(fontSize: 13, color: _text),
    decoration: InputDecoration(
      hintText: 'Описание задачи...',
      hintStyle: const TextStyle(fontSize: 13, color: _grey),
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _orange, width: 1.5),
      ),
      contentPadding: const EdgeInsets.all(14),
    ),
  );

  Widget _dDropdown(
    List<String> items,
    String value,
    ValueChanged<String?> on,
  ) => DropdownButtonFormField<String>(
    value: value,
    style: const TextStyle(fontSize: 13, color: _text),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _orange, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: _grey),
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: on,
  );
}

// ─── Элемент меню статусов ────────────────────────────────────────────────────

class _StatusMenuItem extends StatefulWidget {
  final String label;
  final Color color;
  final bool isActive;

  const _StatusMenuItem({
    required this.label,
    required this.color,
    required this.isActive,
  });

  @override
  State<_StatusMenuItem> createState() => _StatusMenuItemState();
}

class _StatusMenuItemState extends State<_StatusMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        if (!_hovered) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        color: _hovered ? const Color(0xFFFFFAF8) : const Color(0x00FFFAF8),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: widget.isActive
                      ? FontWeight.w700
                      : FontWeight.normal,
                  color: _hovered || widget.isActive
                      ? widget.color
                      : const Color(0xFF1A1F36),
                ),
              ),
            ),
            if (widget.isActive)
              Icon(Icons.check, size: 14, color: widget.color),
          ],
        ),
      ),
    );
  }
}

// ─── Кнопка создать ───────────────────────────────────────────────────────────

class _CreateButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CreateButton({required this.onTap});

  @override
  State<_CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<_CreateButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        if (!_hovered) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _hovered ? _orange.withOpacity(0.9) : _orange,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _orange.withOpacity(_hovered ? 0.4 : 0.25),
                blurRadius: _hovered ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 17, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Создать задачу',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CH extends StatelessWidget {
  final String text;
  const _CH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF8A9BB8),
        letterSpacing: 0.3,
      ),
    );
  }
}
