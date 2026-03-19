import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/model/teacher_model.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_cubit.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_state.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/the_mind_teacher_group_page.dart';

class TheMindTeacherPage extends StatelessWidget {
  const TheMindTeacherPage({super.key});

  static const _orange = Color(0xFFED6A2E);

  @override
  Widget build(BuildContext context) {
    // ✅ main.dart даги мавжуд TeacherCubit — янги BlocProvider йўқ
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: BlocBuilder<TeacherCubit, TeacherState>(
        builder: (context, state) {
          if (state is TeacherLoading) {
            return const Center(
                child: CircularProgressIndicator(color: _orange));
          }

          if (state is TeacherError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: _orange, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: _orange),
                    onPressed: () =>
                        context.read<TeacherCubit>().getTeachers(),
                    child: const Text('Повторить',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          // Journal юкланаётганда аввалги state ни кўрсатамиз
          final loaded = state is TeacherLoaded
              ? state
              : state is TeacherJournalLoading
                  ? state.previous
                  : null;

          final dashboard = loaded?.dashboard;
          final teachers = loaded?.teachers ?? [];

          return RefreshIndicator(
            color: _orange,
            onRefresh: () => context.read<TeacherCubit>().getTeachers(),
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              children: [
                _buildHeader(teachers),
                const SizedBox(height: 24),
                _buildStats(dashboard),
                const SizedBox(height: 28),
                if (dashboard != null && dashboard.groups.isNotEmpty) ...[
                  _buildGroupsSection(context, dashboard.groups),
                  const SizedBox(height: 28),
                ],
                _buildTodayLessons(dashboard),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Заголовок ─────────────────────────────────────────────────────────────
  Widget _buildHeader(List<TeacherModel> teachers) {
    final teacher = teachers.isNotEmpty ? teachers.first : null;
    final name = (teacher?.fullName.isNotEmpty == true)
        ? teacher!.fullName
        : teacher?.username ?? 'Учитель';

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Добро пожаловать, $name!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2233),
                )),
            const SizedBox(height: 4),
            Text(_todayString(),
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
        const Spacer(),
        Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04), blurRadius: 8)
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.search, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text('Поиск...',
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey[400])),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04), blurRadius: 8)
            ],
          ),
          child: Stack(
            children: [
              Center(
                  child: Icon(Icons.notifications_outlined,
                      size: 18, color: Colors.grey[600])),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: Color(0xFFED6A2E),
                      shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Статистика ────────────────────────────────────────────────────────────
  Widget _buildStats(TeacherDashboardModel? d) {
    return Row(
      children: [
        _statCard('БАЛАНС', d != null ? '${d.balance} ₽' : '—',
            Icons.account_balance_wallet_outlined, true),
        const SizedBox(width: 16),
        _statCard('ШТРАФЫ', d != null ? '${d.fine} ₽' : '—',
            Icons.warning_amber_outlined, false),
        const SizedBox(width: 16),
        _statCard('УРОКИ (МЕС)',
            d != null ? '${d.lessonsThisMonth}' : '—',
            Icons.menu_book_outlined, true),
        const SizedBox(width: 16),
        _statCard('ВСЕГО СТУДЕНТОВ',
            d != null ? '${d.studentsCount}' : '—',
            Icons.people_outlined, true),
      ],
    );
  }

  Widget _statCard(
      String label, String value, IconData icon, bool positive) {
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
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[400],
                        letterSpacing: 0.5)),
                const Spacer(),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED6A2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(icon, size: 16, color: const Color(0xFFED6A2E)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2233))),
          ],
        ),
      ),
    );
  }

  // ── Мои группы ────────────────────────────────────────────────────────────
  Widget _buildGroupsSection(
      BuildContext context, List<TeacherGroupItemModel> groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Мои группы',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2233))),
            const Spacer(),
            Text('Смотреть все',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400])),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(groups.length, (i) {
            return Expanded(
              child: Padding(
                padding: i < groups.length - 1
                    ? const EdgeInsets.only(right: 16)
                    : EdgeInsets.zero,
                child: _GroupCard(
                  group: groups[i],
                  index: i,
                  onManage: () {
                    context
                        .read<TeacherCubit>()
                        .getJournal(groups[i].id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TheMindTeacherGroupPage()),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Ближайшие уроки ───────────────────────────────────────────────────────
  Widget _buildTodayLessons(TeacherDashboardModel? d) {
    final lessons = d?.todayLessons ?? [];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Ближайшие уроки сегодня',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233))),
              const Spacer(),
              Icon(Icons.more_horiz, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(flex: 2, child: _th('ВРЕМЯ')),
                Expanded(flex: 4, child: _th('ГРУППА / СТУДЕНТ')),
                Expanded(flex: 3, child: _th('ТИП')),
                Expanded(flex: 2, child: _th('СТАТУС')),
                Expanded(flex: 2, child: _th('ДЕЙСТВИЕ')),
              ],
            ),
          ),
          if (lessons.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Сегодня уроков нет',
                    style:
                        TextStyle(color: Colors.grey[400], fontSize: 14)),
              ),
            )
          else
            ...lessons.map(_lessonRow),
        ],
      ),
    );
  }

  Widget _th(String t) => Text(t,
      style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.grey[400],
          letterSpacing: 0.5));

  Widget _lessonRow(TodayLessonModel l) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.08)))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(l.time,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233)))),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233))),
                Text(l.subtitle,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[400])),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: Text(l.type,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[600]))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(l.status,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF9800))),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: l.isGroup
                    ? const Color(0xFFED6A2E)
                    : const Color(0xFFFFEDE6),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                l.isGroup ? 'Начать урок' : 'Материалы',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: l.isGroup
                        ? Colors.white
                        : const Color(0xFFED6A2E)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _todayString() {
    final now = DateTime.now();
    const days = [
      'понедельник', 'вторник', 'среда',
      'четверг', 'пятница', 'суббота', 'воскресенье'
    ];
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return 'Сегодня ${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }
}

// ─── Карточка группы ──────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  final TeacherGroupItemModel group;
  final int index;
  final VoidCallback onManage;

  const _GroupCard(
      {required this.group, required this.index, required this.onManage});

  static const _colors = [
    Color(0xFFE8623A),
    Color(0xFF6B7FD4),
    Color(0xFF2ECC8A),
    Color(0xFFED8C6A),
    Color(0xFFEDAA8A),
  ];

  Color get _color => _colors[index % _colors.length];

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
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  _color.withOpacity(0.85),
                  _color.withOpacity(0.5)
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
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('ГРУППА #${group.id}',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _color,
                        letterSpacing: 0.5)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people_outlined,
                        size: 13, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text('${group.studentCount} студентов',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onManage,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFED6A2E)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Управление',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFED6A2E))),
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