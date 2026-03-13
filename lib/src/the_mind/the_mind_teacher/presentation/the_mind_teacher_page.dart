import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/the_mind_teacher_group_page.dart';

class TheMindTeacherPage extends StatelessWidget {
  const TheMindTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: [
          _header(),
          const SizedBox(height: 24),
          _stats(),
          const SizedBox(height: 28),
          _groupsSection(),
          const SizedBox(height: 28),
          _todayLessons(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Заголовок ────────────────────────────────────────────────────────────
  Widget _header() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добро пожаловать, Александр!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A2233),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Сегодня вторник, 24 октября. У вас 4 занятия сегодня.',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ),
        const Spacer(),
        // Поиск
        Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.search, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text(
                'Поиск...',
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Уведомления
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.notifications_outlined,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFED6A2E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Статистика ───────────────────────────────────────────────────────────
  Widget _stats() {
    return Row(
      children: [
        _statCard(
          'БАЛАНС',
          '45 000 ₽',
          '+12%',
          Icons.account_balance_wallet_outlined,
          true,
        ),
        const SizedBox(width: 16),
        _statCard('ШТРАФЫ', '0 ₽', '0%', Icons.warning_amber_outlined, false),
        const SizedBox(width: 16),
        _statCard('УРОКИ (МЕС)', '48', '+5%', Icons.menu_book_outlined, true),
        const SizedBox(width: 16),
        _statCard('ВСЕГО СТУДЕНТОВ', '12', '+2%', Icons.people_outlined, true),
      ],
    );
  }

  Widget _statCard(
    String label,
    String value,
    String trend,
    IconData icon,
    bool positive,
  ) {
    return Expanded(
      child: Container(
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
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[400],
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED6A2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFFED6A2E)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2233),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: positive
                          ? const Color(0xFF2ECC8A)
                          : const Color(0xFFED6A2E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Мои группы ───────────────────────────────────────────────────────────
  Widget _groupsSection() {
    final groups = [
      _GroupData(
        'English Breakfast (B1)',
        'INTERMEDIATE',
        6,
        'Пн, Ср, Пт — 10:00',
      ),
      _GroupData('Night Owls (C1)', 'ADVANCED', 4, 'Вт, Чт — 20:00'),
      _GroupData('Starting Point (A2)', 'ELEMENTARY', 8, 'Сб, Вс — 11:30'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Мои группы',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A2233),
              ),
            ),
            const Spacer(),
            Text(
              'Смотреть все',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFED6A2E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: groups
              .map(
                (g) => Expanded(
                  child: Padding(
                    padding: groups.indexOf(g) < groups.length - 1
                        ? const EdgeInsets.only(right: 16)
                        : EdgeInsets.zero,
                    child: _GroupCard(data: g),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ── Ближайшие уроки ──────────────────────────────────────────────────────
  Widget _todayLessons() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              const Text(
                'Ближайшие уроки сегодня',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2233),
                ),
              ),
              const Spacer(),
              Icon(Icons.more_horiz, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          // Шапка таблицы
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(flex: 2, child: _tableHeader('ВРЕМЯ')),
                Expanded(flex: 4, child: _tableHeader('ГРУППА / СТУДЕНТ')),
                Expanded(flex: 3, child: _tableHeader('ТИП')),
                Expanded(flex: 2, child: _tableHeader('СТАТУС')),
                Expanded(flex: 2, child: _tableHeader('ДЕЙСТВИЕ')),
              ],
            ),
          ),
          _lessonRow(
            '14:00',
            'English Breakfast',
            'Групповой, Level B1',
            'Онлайн (Zoom)',
            true,
            true,
          ),
          const SizedBox(height: 8),
          _lessonRow(
            '16:30',
            'Марина Ковалева',
            'Индивидуальный',
            'Онлайн (Skype)',
            true,
            false,
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.grey[400],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _lessonRow(
    String time,
    String name,
    String sub,
    String type,
    bool waiting,
    bool isGroup,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.08))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2233),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233),
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              type,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Ожидается',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF9800),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isGroup
                    ? const Color(0xFFED6A2E)
                    : const Color(0xFFFFEDE6),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                isGroup ? 'Начать урок' : 'Материалы',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isGroup ? Colors.white : const Color(0xFFED6A2E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Данные группы ─────────────────────────────────────────────────────────
class _GroupData {
  final String name;
  final String level;
  final int students;
  final String schedule;
  _GroupData(this.name, this.level, this.students, this.schedule);
}

// ── Карточка группы ───────────────────────────────────────────────────────
class _GroupCard extends StatelessWidget {
  final _GroupData data;
  const _GroupCard({required this.data});

  Color get _levelColor {
    switch (data.level) {
      case 'ADVANCED':
        return const Color(0xFFE8623A);
      case 'INTERMEDIATE':
        return const Color(0xFFED8C6A);
      default:
        return const Color(0xFFEDAA8A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Градиентная шапка
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [
                  _levelColor.withOpacity(0.85),
                  _levelColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.level,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _levelColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),

          // Контент
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people_outlined,
                      size: 13,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${data.students} студентов',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 13,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.schedule,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TheMindTeacherGroupPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFED6A2E)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Управление',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFED6A2E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
