import 'package:flutter/material.dart';

class TheMindTaskPage extends StatefulWidget {
  const TheMindTaskPage({super.key});

  @override
  State<TheMindTaskPage> createState() => _TheMindTaskPageState();
}

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
    final statusLabels = [
      'Нужно сделать',
      'В работе',
      'На проверке',
      'Выполнено',
    ];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Создать задачу',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _dLabel('Название'),
                  const SizedBox(height: 6),
                  _dField(titleCtrl, 'Название задачи'),
                  const SizedBox(height: 12),
                  _dLabel('Описание'),
                  const SizedBox(height: 6),
                  _dArea(descCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _dLabel('Тег'),
                            const SizedBox(height: 6),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _dLabel('Статус'),
                            const SizedBox(height: 6),
                            _dDropdown(
                              statusLabels,
                              statusLabels[status.index],
                              (v) => setLocal(
                                () => status =
                                    TaskStatus.values[statusLabels.indexOf(v!)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
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
                                  tagColor: const Color(0xFFED6A2E),
                                  status: status,
                                ),
                              ),
                            );
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED6A2E),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Заголовок ─────────────────────────────────────────
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
                              color: Color(0xFF1A2233),
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
                      ElevatedButton.icon(
                        onPressed: _showCreateDialog,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Создать задачу',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
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
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ── Переключатель ──────────────────────────────────────
                  Row(
                    children: [
                      _viewBtn(Icons.grid_view_rounded, 'Доска', 'board'),
                      const SizedBox(width: 4),
                      _viewBtn(Icons.list_rounded, 'Список', 'list'),
                      const Spacer(),
                      _iconBtn(Icons.filter_list_rounded),
                      const SizedBox(width: 8),
                      _iconBtn(Icons.sort_rounded),
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

  // ── ДОСКА ──────────────────────────────────────────────────────────────
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
                    const Spacer(),
                    Icon(Icons.more_horiz, size: 16, color: Colors.grey[400]),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(right: 12),
                  children: tasks.map(_taskCard).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── СПИСОК ─────────────────────────────────────────────────────────────
  Widget _listView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 4, child: _CH('ЗАДАЧА')),
                Expanded(flex: 2, child: _CH('ТЕГ')),
                Expanded(flex: 2, child: _CH('СТАТУС')),
                Expanded(flex: 2, child: _CH('ДЕДЛАЙН')),
              ],
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.08), height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.grey.withOpacity(0.06), height: 1),
              itemBuilder: (_, i) {
                final t = _tasks[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                decoration: t.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: const Color(0xFF1A2233),
                              ),
                            ),
                            if (t.description.isNotEmpty)
                              Text(
                                t.description,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[400],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: _tagChip(t.tag, t.tagColor)),
                      Expanded(flex: 2, child: _statusChip(t.status)),
                      Expanded(
                        flex: 2,
                        child: t.deadline != null
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 12,
                                    color: t.deadlineSoon
                                        ? const Color(0xFFED6A2E)
                                        : Colors.grey[400],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    t.deadline!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: t.deadlineSoon
                                          ? const Color(0xFFED6A2E)
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Карточка задачи ────────────────────────────────────────────────────
  Widget _taskCard(TaskModel t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                const Icon(
                  Icons.priority_high,
                  size: 16,
                  color: Color(0xFFED6A2E),
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
              color: t.done ? Colors.grey[400] : const Color(0xFF1A2233),
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
                    color: Color(0xFF1A2233),
                  ),
                ),
                const Spacer(),
                Text(
                  '${(t.progress! * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFED6A2E),
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
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFED6A2E),
                ),
              ),
            ),
          ],
          if (t.status == TaskStatus.review ||
              t.deadline != null ||
              t.done) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: t.tagColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 14,
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
                        color: t.deadlineSoon
                            ? const Color(0xFFED6A2E)
                            : Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        t.deadline!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: t.deadlineSoon
                              ? const Color(0xFFED6A2E)
                              : Colors.grey[500],
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

  Widget _statusChip(TaskStatus s) {
    final labels = ['Нужно сделать', 'В работе', 'На проверке', 'Выполнено'];
    final colors = [
      const Color(0xFF6B7FD4),
      const Color(0xFFFF9800),
      const Color(0xFF9B59B6),
      const Color(0xFF2ECC8A),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: colors[s.index].withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        labels[s.index],
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: colors[s.index],
        ),
      ),
    );
  }

  Widget _viewBtn(IconData icon, String label, String mode) {
    final active = _view == mode;
    return GestureDetector(
      onTap: () => setState(() => _view = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFFED6A2E) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? const Color(0xFFED6A2E) : Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? const Color(0xFFED6A2E) : Colors.grey[600],
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
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
      ],
    ),
    child: Icon(icon, size: 18, color: Colors.grey[600]),
  );

  Widget _dLabel(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1A2233),
    ),
  );

  Widget _dField(TextEditingController c, String hint) => Container(
    height: 44,
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FB),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.withOpacity(0.15)),
    ),
    child: TextField(
      controller: c,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    ),
  );

  Widget _dArea(TextEditingController c) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FB),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.withOpacity(0.15)),
    ),
    child: TextField(
      controller: c,
      maxLines: 3,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Описание задачи...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(12),
      ),
    ),
  );

  Widget _dDropdown(
    List<String> items,
    String value,
    ValueChanged<String?> on,
  ) => Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FB),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.withOpacity(0.15)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: Colors.grey[500],
        ),
        style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: on,
      ),
    ),
  );
}

class _CH extends StatelessWidget {
  final String text;
  const _CH(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Colors.grey[400],
      letterSpacing: 0.5,
    ),
  );
}
