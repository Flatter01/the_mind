import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/the_mind_groups/widgets/group_row.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/pagination_row.dart';

class GroupsTable extends StatelessWidget {
  final List<GroupModel> groups;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final ValueChanged<int> onPageChanged;

  const GroupsTable({super.key, 
    required this.groups,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Заголовок таблицы
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.12))),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: _HeaderCell('НАЗВАНИЕ')),
                Expanded(flex: 3, child: _HeaderCell('УЧИТЕЛЬ')),
                Expanded(flex: 2, child: _HeaderCell('УЧЕНИКИ')),
                Expanded(flex: 2, child: _HeaderCell('ДНИ')),
                Expanded(flex: 2, child: _HeaderCell('ВРЕМЯ')),
                Expanded(flex: 1, child: _HeaderCell('УРОВЕНЬ')),
                Expanded(flex: 1, child: _HeaderCell('КОМНАТА')),
              ],
            ),
          ),

          // Строки
          Expanded(
            child: groups.isEmpty
                ? Center(
                    child: Text('Нет групп', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                  )
                : ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, i) => GroupRow(group: groups[i]),
                  ),
          ),

          // Пагинация
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.12))),
            ),
            child: Row(
              children: [
                Text(
                  'Показано ${groups.length} из $totalCount групп',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const Spacer(),
                PaginationRow(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: onPageChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF8A9BB8), letterSpacing: 0.3),
    );
  }
}