import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _filter = 'Все';

  final List<StudentFeedback> _feedbacks = [
    StudentFeedback(name: 'Александр', surname: 'Иванов', role: 'Студент',
        date: '12 октября 2023', rating: 5, likes: 24, dislikes: 0,
        feedback: 'Отличная платформа для обучения! Программа курса структурирована логично, все материалы доступны в любое время. Особенно порадовала оперативная поддержка кураторов.'),
    StudentFeedback(name: 'Мария', surname: 'Петрова', role: 'Сотрудник',
        date: '10 октября 2023', rating: 4, likes: 12, dislikes: 2,
        feedback: 'Работаю в компании уже второй год. Коллектив замечательный, условия труда на высоком уровне. Иногда бывает высокая нагрузка в отчетные периоды, но это компенсируется бонусами.'),
    StudentFeedback(name: 'Дмитрий', surname: 'Сидоров', role: 'Студент',
        date: '5 октября 2023', rating: 5, likes: 18, dislikes: 1,
        feedback: 'Прекрасные возможности для профессионального роста. Обучающие курсы от компании очень помогают в работе. Рекомендую всем коллегам!'),
    StudentFeedback(name: 'Ali', surname: 'Karimov', role: 'Студент',
        date: '2 октября 2023', rating: 4, likes: 9, dislikes: 0,
        feedback: 'Очень хороший курс, начал лучше понимать Flutter и Bloc.'),
    StudentFeedback(name: 'Madina', surname: 'Rasulova', role: 'Сотрудник',
        date: '1 октября 2023', rating: 3, likes: 5, dislikes: 1,
        feedback: 'Хотелось бы больше практических заданий и живых примеров.'),
  ];

  List<StudentFeedback> get _filtered {
    if (_filter == 'От студентов')  return _feedbacks.where((f) => f.role == 'Студент').toList();
    if (_filter == 'От сотрудников')return _feedbacks.where((f) => f.role == 'Сотрудник').toList();
    if (_filter == 'Новые')         return _feedbacks.take(2).toList();
    return _feedbacks;
  }

  void _showAddDialog() {
    final nameCtrl     = TextEditingController();
    final feedbackCtrl = TextEditingController();
    int rating = 5;
    String role = 'Студент';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Оставить отзыв', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                  const SizedBox(height: 20),
                  _dialogField(nameCtrl, 'Ваше имя'),
                  const SizedBox(height: 12),
                  // Роль
                  _dialogDropdown(['Студент', 'Сотрудник'], role, (v) => setLocal(() => role = v!)),
                  const SizedBox(height: 12),
                  // Рейтинг
                  Row(
                    children: List.generate(5, (i) => GestureDetector(
                      onTap: () => setLocal(() => rating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(i < rating ? Icons.star : Icons.star_border, color: const Color(0xFFED6A2E), size: 28),
                      ),
                    )),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
                    ),
                    child: TextField(
                      controller: feedbackCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Напишите ваш отзыв...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Отмена', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.trim().isEmpty || feedbackCtrl.text.trim().isEmpty) return;
                            final parts = nameCtrl.text.trim().split(' ');
                            setState(() {
                              _feedbacks.insert(0, StudentFeedback(
                                name: parts.first,
                                surname: parts.length > 1 ? parts.last : '',
                                role: role,
                                date: 'Только что',
                                rating: rating,
                                likes: 0, dislikes: 0,
                                feedback: feedbackCtrl.text.trim(),
                              ));
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED6A2E),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Отправить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Фильтры ────────────────────────────────────────
              Row(
                children: ['Все', 'От студентов', 'От сотрудников', 'Новые'].map((f) {
                  final active = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFFED6A2E) : const Color(0xFFED6A2E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(f, style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: active ? Colors.white : const Color(0xFFED6A2E),
                      )),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // ── Список отзывов ──────────────────────────────────
              Expanded(
                child: ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, i) => _FeedbackCard(
                    item: _filtered[i],
                    onLike: () => setState(() => _filtered[i].likes++),
                    onDislike: () => setState(() => _filtered[i].dislikes++),
                  ),
                ),
              ),
            ],
          ),

          // ── Кнопка "Оставить отзыв" ─────────────────────────────
          Positioned(
            right: 0, bottom: 16,
            child: ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text('Оставить отзыв', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6A2E),
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController c, String hint) => Container(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    ),
  );

  Widget _dialogDropdown(List<String> items, String value, ValueChanged<String?> onChanged) => Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FB),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.withOpacity(0.15)),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value, isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[500]),
        style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

// ── Карточка отзыва ───────────────────────────────────────────────────────
class _FeedbackCard extends StatelessWidget {
  final StudentFeedback item;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const _FeedbackCard({required this.item, required this.onLike, required this.onDislike});

  @override
  Widget build(BuildContext context) {
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
          // Шапка
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар с инициалами
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFED6A2E).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${item.name[0]}${item.surname.isNotEmpty ? item.surname[0] : ''}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFFED6A2E)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.name} ${item.surname}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                    const SizedBox(height: 3),
                    Text('${item.date} · ${item.role}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                  ],
                ),
              ),
              // Звёзды
              Row(
                children: List.generate(5, (i) => Icon(
                  i < item.rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFED6A2E), size: 20,
                )),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Текст отзыва
          Text(item.feedback, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.55)),

          const SizedBox(height: 16),

          Divider(color: Colors.grey.withOpacity(0.08), height: 1),
          const SizedBox(height: 12),

          // Лайки/дизлайки
          Row(
            children: [
              _reactionBtn(Icons.thumb_up_outlined, item.likes, onLike),
              const SizedBox(width: 16),
              _reactionBtn(Icons.thumb_down_outlined, item.dislikes, onDislike),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reactionBtn(IconData icon, int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey[400]),
          const SizedBox(width: 5),
          Text('$count', style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Модель ────────────────────────────────────────────────────────────────
class StudentFeedback {
  final String name;
  final String surname;
  final String role;
  final String date;
  final int rating;
  int likes;
  int dislikes;
  final String feedback;

  StudentFeedback({
    required this.name,
    required this.surname,
    required this.role,
    required this.date,
    required this.rating,
    required this.likes,
    required this.dislikes,
    required this.feedback,
  });
}

// Для совместимости с оригинальным кодом
final List<StudentFeedback> feedbackList = [];