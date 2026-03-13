import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/data/model/student_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/data/model/teacher_model.dart';

class GroupDetails extends StatefulWidget {
  const GroupDetails({super.key});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final int pricePerStudent = 450;

  final List<StudentModel> groupStudents = [
    StudentModel(name: 'Артем Никитин', phone: '+998 90 111 22 33', tariff: 'Standart', balance: 2400, tariffPrice: 800000, discount: 0, lesson: 51, bal: 4, arrivalDate: DateTime(2026, 2, 20), activationDate: DateTime(2026, 2, 21)),
    StudentModel(name: 'Марина Соколова', phone: '+998 93 444 55 66', tariff: 'Premium', balance: -850, tariffPrice: 800000, discount: 0, lesson: 51, bal: 0, arrivalDate: DateTime(2026, 2, 20), activationDate: DateTime(2026, 2, 21)),
    StudentModel(name: 'Дмитрий Волков', phone: '+998 99 777 88 99', tariff: 'Basic', balance: 1200, tariffPrice: 800000, discount: 0, lesson: 51, bal: 3, arrivalDate: DateTime(2026, 2, 20), activationDate: DateTime(2026, 2, 21)),
  ];

  final List<TeacherModel> teachers = [
    TeacherModel(name: 'Александр Громов', balance: 24800),
    TeacherModel(name: 'Елена Петрова', balance: 18500),
  ];

  late TeacherModel currentTeacher;

  final Map<String, bool> _attendance = {};
  final Map<String, int?> _grades = {};
  final Map<String, TextEditingController> _hwControllers = {};

  final String _lessonDate = '12.10.2023';
  final int _lessonNumber = 14;
  final int _totalLessons = 24;

  @override
  void initState() {
    super.initState();
    currentTeacher = teachers.first;
    for (final s in groupStudents) {
      _attendance[s.name] = s.bal > 0; // был если есть оценка
      _grades[s.name] = s.bal > 0 ? s.bal : null;
      _hwControllers[s.name] = TextEditingController(text: '');
    }
  }

  @override
  void dispose() {
    for (final c in _hwControllers.values) c.dispose();
    super.dispose();
  }

  int get _presentCount => groupStudents.where((s) => _attendance[s.name] == true).length;
  int get _dailyIncome => _presentCount * pricePerStudent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildInfoAndFinance(),
                const SizedBox(height: 20),
                Expanded(child: _buildAttendanceTable()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Шапка ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A2233)),
                  children: [
                    TextSpan(text: 'Группа: Продвинутый уровень '),
                    TextSpan(text: 'A2', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text('ID: GR-204  |  Расписание: Пн, Ср, Пт 18:00', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ],
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.edit_outlined, size: 15, color: Colors.grey[700]),
          label: Text('Редактировать', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 15, color: Colors.white),
          label: const Text('Добавить студента', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFED6A2E),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // ── Информация + Финансы ──────────────────────────────────────────────────
  Widget _buildInfoAndFinance() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Карточка информации
          Container(
            width: 310,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.info_outline, size: 15, color: Color(0xFFED6A2E)),
                    SizedBox(width: 8),
                    Text('Информация', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                  ],
                ),
                const SizedBox(height: 18),
                _infoRow('Основной учитель', currentTeacher.name, const Color(0xFF1A2233)),
                const SizedBox(height: 14),
                _infoRow('Замена', 'Елена Петрова (до 15.10)', const Color(0xFFED6A2E)),
                const SizedBox(height: 14),
                _infoRow('Учебная комната', '304 (Синяя)', const Color(0xFF1A2233)),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Карточка финансов
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.account_balance_wallet_outlined, size: 15, color: Color(0xFFED6A2E)),
                      SizedBox(width: 8),
                      Text('Финансы преподавателя', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _financeStat('СТАВКА ЗА УЧЕНИКА', '$pricePerStudent Сум', Colors.black87),
                      const SizedBox(width: 40),
                      _financeStat('ДОХОД ЗА ДЕНЬ', '$_dailyIncome Сум', const Color(0xFFED6A2E)),
                      const SizedBox(width: 40),
                      _financeStat('ТЕКУЩИЙ БАЛАНС', '${currentTeacher.balance} Сум', const Color(0xFF2ECC8A)),
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

  Widget _infoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor)),
      ],
    );
  }

  Widget _financeStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor)),
      ],
    );
  }

  // ── Таблица посещаемости ──────────────────────────────────────────────────
  Widget _buildAttendanceTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Color(0xFF1A2233)),
                    children: [
                      const TextSpan(text: 'Посещаемость и успеваемость: ', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: _lessonDate, style: const TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 6),
                Text('Урок №$_lessonNumber из $_totalLessons', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
          ),

          // Шапка колонок
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.withOpacity(0.1))),
            ),
            child: Row(
              children: const [
                SizedBox(width: 40), // аватар
                SizedBox(width: 12),
                Expanded(flex: 4, child: _ColHeader('ИМЯ СТУДЕНТА')),
                Expanded(flex: 3, child: _ColHeader('СТАТУС')),
                Expanded(flex: 3, child: _ColHeader('БАЛАНС')),
                Expanded(flex: 2, child: _ColHeader('БЫЛ/НЕТ')),
                Expanded(flex: 2, child: _ColHeader('ОЦЕНКА')),
                Expanded(flex: 3, child: _ColHeader('ДЗ')),
              ],
            ),
          ),

          // Строки студентов
          Expanded(
            child: ListView.builder(
              itemCount: groupStudents.length,
              itemBuilder: (context, i) => _buildStudentRow(groupStudents[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRow(StudentModel s) {
    final isPresent = _attendance[s.name] ?? false;
    final isDebtor = s.balance < 0;
    final grade = _grades[s.name];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.07))),
      ),
      child: Row(
        children: [
          // Аватар
          _avatar(s.name),
          const SizedBox(width: 12),

          // Имя
          Expanded(
            flex: 4,
            child: Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2233))),
          ),

          // Статус
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDebtor ? const Color(0xFFED6A2E).withOpacity(0.1) : const Color(0xFF2ECC8A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isDebtor ? 'Долг' : 'Активен',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDebtor ? const Color(0xFFED6A2E) : const Color(0xFF2ECC8A),
                  ),
                ),
              ),
            ),
          ),

          // Баланс
          Expanded(
            flex: 3,
            child: Text(
              '${s.balance} Сум',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDebtor ? const Color(0xFFED6A2E) : const Color(0xFF1A2233),
              ),
            ),
          ),

          // Чекбокс
          Expanded(
            flex: 2,
            child: Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: isPresent,
                activeColor: const Color(0xFFED6A2E),
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                side: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.5),
                onChanged: (v) => setState(() => _attendance[s.name] = v ?? false),
              ),
            ),
          ),

          // Оценка
          Expanded(
            flex: 2,
            child: isPresent
                ? _gradeDropdown(s.name, grade)
                : Text('—', style: TextStyle(color: Colors.grey[300], fontSize: 14)),
          ),

          // ДЗ
          Expanded(
            flex: 3,
            child: isPresent
                ? _hwField(s.name)
                : Text('—', style: TextStyle(color: Colors.grey[300], fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String name) {
    final parts = name.trim().split(' ');
    final initials = parts.length >= 2 ? '${parts[0][0]}${parts[1][0]}'.toUpperCase() : name[0].toUpperCase();
    const colors = [Color(0xFFED6A2E), Color(0xFF6B7FD4), Color(0xFF2ECC8A), Color(0xFF8A9BB8)];
    final color = colors[name.length % colors.length];
    return CircleAvatar(
      radius: 18,
      backgroundColor: color.withOpacity(0.15),
      child: Text(initials, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }

  // ── Оценка: число если выбрано, стрелка если нет ─────────────────────────
  Widget _gradeDropdown(String name, int? grade) {
    return SizedBox(
      height: 34,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: grade,
          isDense: true,
          // Показываем число если выбрано, иначе стрелку-вниз
          hint: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[400]),
          icon: grade != null
              ? Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[400])
              : const SizedBox.shrink(),
          selectedItemBuilder: (_) => List.generate(5, (i) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${i + 1}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2233)),
              ),
            );
          }),
          items: List.generate(5, (i) {
            final v = i + 1;
            return DropdownMenuItem(
              value: v,
              child: Text('$v', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            );
          }),
          onChanged: (v) => setState(() => _grades[name] = v),
        ),
      ),
    );
  }

  // ── ДЗ поле со стабильным контроллером ───────────────────────────────────
  Widget _hwField(String name) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: _hwControllers[name],
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Нет',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
      ),
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String text;
  const _ColHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF8A9BB8), letterSpacing: 0.4));
  }
}