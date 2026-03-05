import 'package:flutter/material.dart';

class TheMindTeacherPage extends StatelessWidget {
  const TheMindTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              _header(),
              const SizedBox(height: 24),
              _stats(),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _groups()),
                  const SizedBox(width: 24),
                  Expanded(child: _todayLessons()),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// ===== HEADER =====

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Панель учителя',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 12),
            Text(
              'Aliyev Bekzod',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  /// ===== STATS =====

  Widget _stats() {
    return Row(
      children: const [
        Expanded(child: _StatCard(title: 'Баланс', value: '2 400 000 сум')),
        SizedBox(width: 16),
        Expanded(child: _StatCard(title: 'Штраф', value: '50 000 сум')),
        SizedBox(width: 16),
        Expanded(child: _StatCard(title: 'Уроков в месяц', value: '18')),
        SizedBox(width: 16),
        Expanded(child: _StatCard(title: 'Ученики', value: '32')),
      ],
    );
  }

  /// ===== GROUPS =====

  Widget _groups() {
    return _Block(
      title: 'Мои группы',
      child: Column(
        children: List.generate(
          4,
          (i) => _GroupTile(
            name: 'Flutter группа ${i + 1}',
            students: ['Ali', 'Vali', 'Sardor', 'Jamshid'],
          ),
        ),
      ),
    );
  }

  /// ===== TODAY LESSONS =====

  Widget _todayLessons() {
    return _Block(
      title: 'Сегодня',
      child: Column(
        children: List.generate(
          3,
          (i) => _LessonTile(time: '18:0$i', group: 'Flutter группа ${i + 1}'),
        ),
      ),
    );
  }
}

/// ================= COMPONENTS =================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _grey()),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// ================= GROUP =================

class _GroupTile extends StatefulWidget {
  final String name;
  final List<String> students;

  const _GroupTile({required this.name, required this.students});

  @override
  State<_GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<_GroupTile> {

  /// посещаемость
  late Map<String, bool?> attendance;

  /// оценки
  late Map<String, int> ratings;

  @override
  void initState() {
    super.initState();

    attendance = {for (var s in widget.students) s: null};
    ratings = {for (var s in widget.students) s: 0};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _card(),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('${widget.students.length} учеников', style: _grey()),
          children: widget.students.map(_studentRow).toList(),
        ),
      ),
    );
  }

  /// ================= STUDENT ROW =================

  Widget _studentRow(String student) {

    final state = attendance[student];
    final rating = ratings[student]!;

    Color bg = Colors.transparent;
    Widget? icon;

    if (state == true) {
      bg = Colors.green;
      icon = const Icon(Icons.check, color: Colors.white, size: 18);
    } else if (state == false) {
      bg = Colors.red;
      icon = const Icon(Icons.close, color: Colors.white, size: 18);
    }

    return ListTile(

      title: Text(student),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// ===== ОЦЕНКА 0-10 =====

          PopupMenuButton<int>(
            onSelected: (v) => setState(() => ratings[student] = v),
            itemBuilder: (_) => List.generate(
              11,
              (i) => PopupMenuItem(
                value: i,
                child: Text(i.toString()),
              ),
            ),
            child: Container(
              width: 50,
              height: 34,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                rating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          /// ===== ПОСЕЩАЕМОСТЬ =====

          PopupMenuButton<bool?>(
            onSelected: (v) => setState(() => attendance[student] = v),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: true,
                child: Icon(Icons.check, color: Colors.green),
              ),
              PopupMenuItem(
                value: false,
                child: Icon(Icons.close, color: Colors.red),
              ),
              PopupMenuItem(
                value: null,
                child: Text('Очистить'),
              ),
            ],
            child: Container(
              width: 70,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: icon ?? const SizedBox(),
            ),
          ),

        ],
      ),
    );
  }
}

/// ================= LESSON =================

class _LessonTile extends StatelessWidget {

  final String time;
  final String group;

  const _LessonTile({
    required this.time,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(group)),
        ],
      ),
    );
  }
}

/// ================= BLOCK =================

class _Block extends StatelessWidget {

  final String title;
  final Widget child;

  const _Block({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }
}

/// ================= STYLE =================

BoxDecoration _card() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Color(0x11000000),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  );
}

TextStyle _grey() {
  return const TextStyle(
    color: Colors.grey,
    fontSize: 13,
  );
}
