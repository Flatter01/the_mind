import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsItem {
  final String title;
  final String excerpt;
  final String category;
  final Color categoryColor;
  final String date;
  final int views;
  final int comments;
  final bool isDraft;

  _NewsItem({
    required this.title,
    required this.excerpt,
    required this.category,
    required this.categoryColor,
    required this.date,
    required this.views,
    required this.comments,
    this.isDraft = false,
  });
}

class _NewsPageState extends State<NewsPage> {
  String _filter = 'Все'; // Все / Опубликовано / Черновики

  final _titleController = TextEditingController();
  final _textController  = TextEditingController();
  String _sendTo         = 'Всем';
  String _selectedGroup  = 'Все студенты';
  String _selectedRole   = 'Студент';

  final List<String> _sendTypes = ['Всем', 'По группе', 'По роли'];
  final List<String> _groups    = ['Все студенты', 'Flutter 1', 'Flutter 2', 'Backend'];
  final List<String> _roles     = ['Студент', 'Учитель', 'Менеджер'];

  final List<_NewsItem> _news = [
    _NewsItem(
      title:    'Запуск инновационной платформы для анализа больших данных в реальном времени',
      excerpt:  'Новая архитектура позволяет обрабатывать до 10 петабайт информации в секунду, обеспечивая беспрецедентную скорость принятия бизнес-решений.',
      category: 'ТЕХНОЛОГИИ', categoryColor: Color(0xFFED6A2E),
      date: '24 Окт, 2023', views: 1200, comments: 42,
    ),
    _NewsItem(
      title:    'Квартальный отчет: Рост прибыли компании составил 15% вопреки рыночным трендам',
      excerpt:  'Успешная диверсификация портфеля активов и выход на новые азиатские рынки стали ключевыми драйверами финансового успеха в этом сезоне.',
      category: 'БИЗНЕС', categoryColor: Color(0xFF2ECC8A),
      date: '22 Окт, 2023', views: 856, comments: 18,
    ),
    _NewsItem(
      title:    'План развития корпоративной культуры на 2024 год: главные тезисы',
      excerpt:  'Подготовка к масштабной реорганизации отделов и внедрение системы гибридной работы для всех сотрудников фронт-офиса.',
      category: 'ВНУТРЕННЕЕ', categoryColor: Color(0xFF6B7FD4),
      date: 'Изменено вчера', views: 0, comments: 0, isDraft: true,
    ),
  ];

  List<_NewsItem> get _filtered {
    if (_filter == 'Опубликовано') return _news.where((n) => !n.isDraft).toList();
    if (_filter == 'Черновики')    return _news.where((n) => n.isDraft).toList();
    return _news;
  }

  int get _publishedCount => _news.where((n) => !n.isDraft).length;

  void _publishNews() {
    final title = _titleController.text.trim();
    final text  = _textController.text.trim();
    if (title.isEmpty || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')));
      return;
    }
    setState(() {
      _news.insert(0, _NewsItem(
        title: title, excerpt: text,
        category: 'НОВОЕ', categoryColor: const Color(0xFFED6A2E),
        date: 'Только что', views: 0, comments: 0,
      ));
      _titleController.clear();
      _textController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Новость опубликована ✅')));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Список новостей ──────────────────────────────────────
          Expanded(
            flex: 3,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                // Заголовок + фильтры
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Управление новостями',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                        const SizedBox(height: 4),
                        Text('Всего опубликовано $_publishedCount материала за этот месяц',
                            style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                      ],
                    ),
                    const Spacer(),
                    // Фильтры
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                      ),
                      child: Row(
                        children: ['Все', 'Опубликовано', 'Черновики'].map((f) {
                          final active = _filter == f;
                          return GestureDetector(
                            onTap: () => setState(() => _filter = f),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: active ? const Color(0xFF1A2233) : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(f, style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600,
                                color: active ? Colors.white : Colors.grey[600],
                              )),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Карточки новостей
                ..._filtered.map(_newsCard),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // ── Форма добавления ─────────────────────────────────────
          SizedBox(
            width: 300,
            child: _card(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Новая новость',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                const SizedBox(height: 16),

                _fieldLabel('Заголовок'),
                const SizedBox(height: 6),
                _inputField(_titleController, hint: 'Например: Новый модуль доступен'),

                const SizedBox(height: 14),

                _fieldLabel('Текст новости'),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Введите текст новости...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                _fieldLabel('Кому отправить'),
                const SizedBox(height: 6),
                _dropdown(_sendTypes, _sendTo, (v) => setState(() => _sendTo = v!)),

                if (_sendTo == 'По группе') ...[
                  const SizedBox(height: 10),
                  _dropdown(_groups, _selectedGroup, (v) => setState(() => _selectedGroup = v!)),
                ],
                if (_sendTo == 'По роли') ...[
                  const SizedBox(height: 10),
                  _dropdown(_roles, _selectedRole, (v) => setState(() => _selectedRole = v!)),
                ],

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _publishNews,
                    icon: const Icon(Icons.campaign_outlined, color: Colors.white, size: 16),
                    label: const Text('Опубликовать', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED6A2E),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  // ── Карточка новости ───────────────────────────────────────────
  Widget _newsCard(_NewsItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Превью-блок вместо фото
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            child: Stack(
              children: [
                Container(
                  width: 220, height: 180,
                  color: item.isDraft
                      ? Colors.grey[200]
                      : const Color(0xFF1A2233).withOpacity(0.08),
                  child: Center(
                    child: Icon(
                      item.isDraft ? Icons.article_outlined : Icons.newspaper_outlined,
                      size: 48,
                      color: item.isDraft ? Colors.grey[400] : const Color(0xFF1A2233).withOpacity(0.15),
                    ),
                  ),
                ),
                if (item.isDraft)
                  Positioned(
                    bottom: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('ЧЕРНОВИК',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                    ),
                  ),
              ],
            ),
          ),

          // Контент
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Категория + дата
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(item.category,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: item.categoryColor, letterSpacing: 0.3)),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(item.date, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Заголовок
                  Text(item.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2233), height: 1.4)),

                  const SizedBox(height: 8),

                  // Описание
                  Text(item.excerpt,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.5),
                      maxLines: 2, overflow: TextOverflow.ellipsis),

                  const SizedBox(height: 12),

                  // Нижняя строка
                  Row(
                    children: [
                      if (!item.isDraft) ...[
                        Icon(Icons.visibility_outlined, size: 13, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(_fmtK(item.views), style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                        const SizedBox(width: 12),
                        Icon(Icons.chat_bubble_outline, size: 13, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text('${item.comments}', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                      ] else
                        Text('Не опубликовано', style: TextStyle(fontSize: 12, color: Colors.grey[400])),

                      const Spacer(),

                      // Кнопка публикации для черновиков
                      if (item.isDraft)
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFED6A2E)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              minimumSize: Size.zero,
                            ),
                            child: const Text('Опубликовать',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFED6A2E))),
                          ),
                        ),

                      Icon(Icons.edit_outlined, size: 16, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Icon(Icons.delete_outline, size: 16, color: Colors.grey[400]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: child,
  );

  Widget _fieldLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A2233)));

  Widget _inputField(TextEditingController c, {required String hint}) => Container(
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
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    ),
  );

  Widget _dropdown(List<String> items, String value, ValueChanged<String?> onChanged) => Container(
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
        icon: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[500]),
        style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    ),
  );

  String _fmtK(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}