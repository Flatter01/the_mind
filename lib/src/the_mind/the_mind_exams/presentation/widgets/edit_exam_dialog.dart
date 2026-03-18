import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/models/exam_model.dart';
import 'package:srm/src/the_mind/the_mind_group/data/datasources/group_api_service.dart';

// Статус студента
enum StudentStatus { present, absent, waiting }

// Модель строки студента
class ExamStudentRow {
  final String firstName;
  final String lastName;
  StudentStatus status;
  int? score;
  final TextEditingController controller;

  ExamStudentRow({
    required this.firstName,
    required this.lastName,
    this.status = StudentStatus.waiting,
    this.score,
  }) : controller = TextEditingController(text: score?.toString() ?? '');
}

class EditExamDialog extends StatefulWidget {
  final ExamModel exam;
  final VoidCallback onSave;

  const EditExamDialog({
    super.key,
    required this.exam,
    required this.onSave,
  });

  @override
  State<EditExamDialog> createState() => _EditExamDialogState();
}

class _EditExamDialogState extends State<EditExamDialog> {
  int _currentPage = 1;
  final int _perPage = 5;
  String _examStatus = 'planned';

  final List<ExamStudentRow> _students = [];

  @override
  void initState() {
    super.initState();
    _examStatus = widget.exam.status;
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final data = await GroupRepository().getGroupStudents(widget.exam.group);
      final rows = data.map((s) {
        final map = s as Map<String, dynamic>;
        final name = (map['student_name'] as String? ?? '').trim();
        final parts = name.split(' ');
        return ExamStudentRow(
          firstName: parts.isNotEmpty ? parts[0] : '',
          lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
        );
      }).toList();
      if (mounted) {
        setState(() {
          _students
            ..clear()
            ..addAll(rows);
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final s in _students) {
      s.controller.dispose();
    }
    super.dispose();
  }

  int get _totalStudents => _students.length;
  int get _passed => _students.where((s) => (s.score ?? 0) >= widget.exam.passScore).length;
  double get _avgScore {
    final scored = _students.where((s) => s.score != null && s.score! > 0).toList();
    if (scored.isEmpty) return 0;
    return scored.fold<double>(0, (sum, s) => sum + s.score!) / scored.length;
  }

  List<ExamStudentRow> get _pageItems =>
      _students.skip((_currentPage - 1) * _perPage).take(_perPage).toList();

  int get _totalPages => (_students.length / _perPage).ceil().clamp(1, 999);

  @override
  Widget build(BuildContext context) {
    final e = widget.exam;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Заголовок ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Управление процессом проведения экзамена и ведомость успеваемости группы ${e.groupName}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Начать экзамен
                ElevatedButton.icon(
                  onPressed: _examStatus == 'finished'
                      ? null
                      : () => setState(() => _examStatus = 'started'),
                  icon: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
                  label: const Text(
                    'Начать экзамен',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED6A2E),
                    disabledBackgroundColor: Colors.grey[300],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 10),

                // Завершить
                OutlinedButton.icon(
                  onPressed: _examStatus == 'planned'
                      ? null
                      : () => setState(() => _examStatus = 'finished'),
                  icon: Icon(Icons.stop_outlined, size: 16, color: Colors.grey[700]),
                  label: Text(
                    'Завершить',
                    style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Инфо карточки ──
            Row(
              children: [
                _infoCard('ЭКЗАМЕН', e.title),
                const SizedBox(width: 12),
                _infoCard('ГРУППА', e.groupName),
                const SizedBox(width: 12),
                _infoCard('ПРЕПОДАВАТЕЛЬ', e.teacherName),
                const SizedBox(width: 12),
                _infoCard('ДАТА ПРОВЕДЕНИЯ', e.examDate),
                const SizedBox(width: 12),
                _infoCard(
                  'ВРЕМЯ',
                  '${e.startTime.length >= 5 ? e.startTime.substring(0, 5) : e.startTime}'
                  ' — '
                  '${e.endTime.length >= 5 ? e.endTime.substring(0, 5) : e.endTime}',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Таблица студентов ──
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
                    child: Row(
                      children: [
                        const Text(
                          'Список студентов',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A2233),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.info_outline, size: 15, color: Color(0xFFED6A2E)),
                        const SizedBox(width: 6),
                        Text(
                          'Проходной балл: ${e.passScore}${e.isPercentage ? '%' : ''}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),

                  // Шапка колонок
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      ),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 40, child: _ColH('№')),
                        Expanded(flex: 4, child: _ColH('Имя')),
                        Expanded(flex: 4, child: _ColH('Фамилия')),
                        Expanded(flex: 3, child: _ColH('Статус')),
                        Expanded(flex: 2, child: _ColH('Баллы (0-100)')),
                      ],
                    ),
                  ),

                  // Строки студентов
                  _students.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text(
                              'Студенты не найдены',
                              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                            ),
                          ),
                        )
                      : Column(
                          children: List.generate(_pageItems.length, (i) {
                            final s = _pageItems[i];
                            final globalIndex = (_currentPage - 1) * _perPage + i + 1;
                            return _studentRow(globalIndex, s);
                          }),
                        ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                    child: Row(
                      children: [
                        Text(
                          _students.isEmpty
                              ? '0 студентов'
                              : 'Показано ${(_currentPage - 1) * _perPage + 1}-'
                                '${(_currentPage - 1) * _perPage + _pageItems.length} '
                                'из $_totalStudents студентов',
                          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                        const Spacer(),
                        if (_students.isNotEmpty) _buildPagination(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Статистика ──
            Row(
              children: [
                _statCard(Icons.people_outlined, 'ВСЕГО СТУДЕНТОВ', '$_totalStudents'),
                const SizedBox(width: 12),
                _statCard(Icons.how_to_reg_outlined, 'СДАЛИ ЭКЗАМЕН', '$_passed'),
                const SizedBox(width: 12),
                _statCard(Icons.bar_chart_outlined, 'СРЕДНИЙ БАЛЛ', _avgScore.toStringAsFixed(1)),
                const SizedBox(width: 12),
                _statCard(Icons.assignment_outlined, 'РЕЗУЛЬТАТОВ', '${e.resultsCount}'),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.grey[400],
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2233),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentRow(int index, ExamStudentRow s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.07))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text('$index', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ),
          Expanded(
            flex: 4,
            child: Text(s.firstName, style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233))),
          ),
          Expanded(
            flex: 4,
            child: Text(s.lastName, style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233))),
          ),
          Expanded(flex: 3, child: _statusDropdown(s)),
          Expanded(
            flex: 2,
            child: s.status == StudentStatus.waiting
                ? Text('—', style: TextStyle(color: Colors.grey[400], fontSize: 16))
                : SizedBox(
                    width: 80,
                    height: 36,
                    child: TextField(
                      controller: s.controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFED6A2E)),
                        ),
                      ),
                      onChanged: (v) {
                        final val = int.tryParse(v);
                        setState(() => s.score = val?.clamp(0, 100));
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusDropdown(ExamStudentRow s) {
    final info = _statusDisplay(s.status);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _pickStatus(s),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: info['bg'] as Color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            info['label'] as String,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: info['color'] as Color,
            ),
          ),
        ),
      ),
    );
  }

  void _pickStatus(ExamStudentRow s) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(300, 300, 0, 0),
      items: [
        _statusMenuItem(s, StudentStatus.present, 'Присутствует'),
        _statusMenuItem(s, StudentStatus.absent, 'Отсутствует'),
        _statusMenuItem(s, StudentStatus.waiting, 'Ожидает'),
      ],
    );
  }

  PopupMenuItem<StudentStatus> _statusMenuItem(
    ExamStudentRow s,
    StudentStatus status,
    String label,
  ) {
    return PopupMenuItem(
      value: status,
      onTap: () => setState(() => s.status = status),
      child: Text(label),
    );
  }

  Map<String, dynamic> _statusDisplay(StudentStatus status) {
    switch (status) {
      case StudentStatus.present:
        return {
          'label': 'Присутствует',
          'color': const Color(0xFF2ECC8A),
          'bg': const Color(0xFF2ECC8A).withOpacity(0.1),
        };
      case StudentStatus.absent:
        return {
          'label': 'Отсутствует',
          'color': const Color(0xFFED6A2E),
          'bg': const Color(0xFFED6A2E).withOpacity(0.1),
        };
      case StudentStatus.waiting:
        return {
          'label': 'Ожидает',
          'color': const Color(0xFF8A9BB8),
          'bg': const Color(0xFF8A9BB8).withOpacity(0.1),
        };
    }
  }

  Widget _statCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFED6A2E).withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFED6A2E).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: const Color(0xFFED6A2E)),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500],
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2233),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFED6A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  '$p',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Colors.black87,
                  ),
                ),
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
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Icon(icon, size: 16, color: onTap == null ? Colors.grey[300] : Colors.black87),
      ),
    );
  }
}

class _ColH extends StatelessWidget {
  final String text;
  const _ColH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFFED6A2E),
        letterSpacing: 0.3,
      ),
    );
  }
}