import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_state.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/create_group_page.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/the_mind_groups/widgets/filter/filter_dropdown.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/the_mind_groups/widgets/groups_table.dart';

class TheMindGroup extends StatefulWidget {
  const TheMindGroup({super.key});

  @override
  State<TheMindGroup> createState() => _TheMindGroupState();
}

class _TheMindGroupState extends State<TheMindGroup> {
  String _searchQuery = '';
  String? _selectedTeacher;
  String? _selectedLevel;
  bool? _selectedActive;
  int _currentPage = 1;
  final int _perPage = 5;

  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Заголовок + кнопка ───────────────────────────────
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Группы',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1A2233)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Управление учебными группами и расписанием',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const CreateGroupPage(),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text('Создать группу', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED6A2E),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ── Поиск + фильтры ──────────────────────────────────
            BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                // Собираем список учителей из загруженных групп
                final teachers = state is GroupLoaded
                    ? state.groups
                        .map((g) => g.teacherName ?? '')
                        .where((t) => t.isNotEmpty)
                        .toSet()
                        .toList()
                    : <String>[];

                final levels = state is GroupLoaded
                    ? state.groups
                        .map((g) => g.levelDisplay ?? g.level ?? '')
                        .where((l) => l.isNotEmpty)
                        .toSet()
                        .toList()
                    : <String>[];

                return Row(
                  children: [
                    // Поиск
                    Container(
                      width: 260,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() {
                          _searchQuery = v;
                          _currentPage = 1;
                        }),
                        decoration: InputDecoration(
                          hintText: 'Поиск по названию группы...',
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Все учителя (динамически из данных)
                    FilterDropdown(
                      hint: 'Все учителя',
                      value: _selectedTeacher,
                      items: {for (final t in teachers) t: t},
                      onChanged: (v) => setState(() {
                        _selectedTeacher = v;
                        _currentPage = 1;
                      }),
                    ),

                    const SizedBox(width: 12),

                    // Все уровни (динамически из данных)
                    FilterDropdown(
                      hint: 'Все курсы',
                      value: _selectedLevel,
                      items: {for (final l in levels) l: l},
                      onChanged: (v) => setState(() {
                        _selectedLevel = v;
                        _currentPage = 1;
                      }),
                    ),

                    const SizedBox(width: 12),

                    // Активные / неактивные
                    FilterDropdown(
                      hint: 'Все дни',
                      value: _selectedActive == null ? null : (_selectedActive! ? 'active' : 'finished'),
                      items: const {'active': 'Активные', 'finished': 'Завершённые'},
                      onChanged: (v) => setState(() {
                        _selectedActive = v == null ? null : v == 'active';
                        _currentPage = 1;
                      }),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Таблица ──────────────────────────────────────────
            Expanded(
              child: BlocBuilder<GroupCubit, GroupState>(
                builder: (context, state) {
                  if (state is GroupLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFED6A2E)));
                  }
                  if (state is GroupError) {
                    print(state.message);
                    return Center(child: Text(state.message));
                  }
                  if (state is GroupLoaded) {
                    final filtered = state.groups.where((g) {
                      final matchSearch = (g.name ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
                      final matchTeacher = _selectedTeacher == null ||
                          (g.teacherName ?? '') == _selectedTeacher;
                      final matchLevel = _selectedLevel == null ||
                          (g.levelDisplay ?? g.level ?? '') == _selectedLevel;
                      final matchActive = _selectedActive == null ||
                          g.isActive == _selectedActive;
                      return matchSearch && matchTeacher && matchLevel && matchActive;
                    }).toList();

                    final totalPages = (filtered.length / _perPage).ceil().clamp(1, 999);
                    final pageItems = filtered
                        .skip((_currentPage - 1) * _perPage)
                        .take(_perPage)
                        .toList();

                    return GroupsTable(
                      groups: pageItems,
                      totalCount: filtered.length,
                      currentPage: _currentPage,
                      totalPages: totalPages,
                      perPage: _perPage,
                      onPageChanged: (p) => setState(() => _currentPage = p),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}