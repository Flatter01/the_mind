import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';

const _orange = Color(0xFFED6A2E);

enum StudentsBlockType { trial, debtors, absent }

class StudentsListWidget extends StatelessWidget {
  final String title;
  final Widget icons;
  final String quantity;
  final List<BuildStudentsTableItem> students;
  final StudentsBlockType blockType;

  const StudentsListWidget({
    super.key,
    required this.title,
    required this.icons,
    required this.quantity,
    required this.blockType,
    this.students = const [],
  });

  Color get _badgeColor {
    switch (blockType) {
      case StudentsBlockType.trial:
        return const Color(0xFF6B7FD4);
      case StudentsBlockType.debtors:
        return const Color(0xFFED6A2E);
      case StudentsBlockType.absent:
        return const Color(0xFF8A9BB8);
    }
  }

  void _showAllStudents(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _StudentsListDialog(
        title: title,
        students: students,
        blockType: blockType,
        badgeColor: _badgeColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              icons,
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // ✅ Кликабельный бейдж
              GestureDetector(
                onTap: () => _showAllStudents(context),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          quantity,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _badgeColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: _badgeColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // ── Список ──
          students.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Нет данных',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(students.length, (index) {
                    final student = students[index];
                    return _buildStudentTile(student, index);
                  }),
                ),

          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Разослать напоминания',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTile(BuildStudentsTableItem student, int index) {
    switch (blockType) {
      case StudentsBlockType.trial:
        return _TrialStudentTile(student: student, index: index);
      case StudentsBlockType.debtors:
        return _DebtorStudentTile(student: student);
      case StudentsBlockType.absent:
        return _AbsentStudentTile(student: student);
    }
  }
}

// ─── Диалог всех студентов ────────────────────────────────────────────────────

class _StudentsListDialog extends StatefulWidget {
  final String title;
  final List<BuildStudentsTableItem> students;
  final StudentsBlockType blockType;
  final Color badgeColor;

  const _StudentsListDialog({
    required this.title,
    required this.students,
    required this.blockType,
    required this.badgeColor,
  });

  @override
  State<_StudentsListDialog> createState() => _StudentsListDialogState();
}

class _StudentsListDialogState extends State<_StudentsListDialog> {
  String _search = '';

  List<BuildStudentsTableItem> get _filtered {
    if (_search.isEmpty) return widget.students;
    return widget.students
        .where((s) =>
            s.name.toLowerCase().contains(_search.toLowerCase()) ||
            s.group.toLowerCase().contains(_search.toLowerCase()) ||
            s.phone.contains(_search))
        .toList();
  }

  IconData get _headerIcon {
    switch (widget.blockType) {
      case StudentsBlockType.trial:
        return Icons.school_outlined;
      case StudentsBlockType.debtors:
        return Icons.warning_amber_rounded;
      case StudentsBlockType.absent:
        return Icons.person_off_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      elevation: 0,
      child: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 16, 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.12)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: widget.badgeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _headerIcon,
                      color: widget.badgeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1F36),
                        ),
                      ),
                      Text(
                        '${widget.students.length} студентов',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8A94A6)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close,
                        color: Colors.grey[400], size: 20),
                  ),
                ],
              ),
            ),

            // ── Поиск ──
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.2)),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF1A1F36)),
                  decoration: InputDecoration(
                    hintText: 'Поиск по имени или группе...',
                    hintStyle: const TextStyle(
                        fontSize: 13, color: Color(0xFF8A94A6)),
                    prefixIcon: Icon(Icons.search,
                        size: 18, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ── Список ──
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: _filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.person_search_outlined,
                              size: 40, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'Студентов не найдено',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding:
                          const EdgeInsets.fromLTRB(28, 8, 28, 20),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      itemBuilder: (_, i) => _DialogStudentTile(
                        student: _filtered[i],
                        index: i,
                        blockType: widget.blockType,
                        badgeColor: widget.badgeColor,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Тайл в диалоге ──────────────────────────────────────────────────────────

class _DialogStudentTile extends StatefulWidget {
  final BuildStudentsTableItem student;
  final int index;
  final StudentsBlockType blockType;
  final Color badgeColor;

  const _DialogStudentTile({
    required this.student,
    required this.index,
    required this.blockType,
    required this.badgeColor,
  });

  @override
  State<_DialogStudentTile> createState() => _DialogStudentTileState();
}

class _DialogStudentTileState extends State<_DialogStudentTile> {
  bool _hovered = false;

  static const _avatarColors = [
    Color(0xFFED6A2E),
    Color(0xFF6B7FD4),
    Color(0xFF2ECC8A),
    Color(0xFF8A9BB8),
  ];

  @override
  Widget build(BuildContext context) {
    final avatarColor =
        _avatarColors[widget.index % _avatarColors.length];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        if (!_hovered) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: _hovered
            ? widget.badgeColor.withOpacity(0.04)
            : Colors.transparent,
        child: Row(
          children: [
            // Аватар
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarColor.withOpacity(0.15),
              child: Text(
                widget.student.name.isNotEmpty
                    ? widget.student.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: avatarColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Инфо
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${widget.student.group} · ${widget.student.phone}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF8A94A6)),
                  ),
                ],
              ),
            ),

            // Правая часть в зависимости от типа
            if (widget.blockType == StudentsBlockType.debtors)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.student.balance,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _orange,
                  ),
                ),
              )
            else if (widget.blockType == StudentsBlockType.absent)
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Colors.grey.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Позвонить',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B7FD4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Пробный',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7FD4),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Тайлы (без изменений) ────────────────────────────────────────────────────

class _TrialStudentTile extends StatelessWidget {
  final BuildStudentsTableItem student;
  final int index;

  const _TrialStudentTile({required this.student, required this.index});

  static const _avatarColors = [
    Color(0xFFD4A5A5),
    Color(0xFFED6A2E),
    Color(0xFFB0C4D8),
  ];

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColors[index % _avatarColors.length];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarColor,
            child: Text(
              student.name.isNotEmpty ? student.name[0] : '?',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${student.group} · 18:00',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: Colors.grey[400], size: 18),
        ],
      ),
    );
  }
}

class _DebtorStudentTile extends StatelessWidget {
  final BuildStudentsTableItem student;
  const _DebtorStudentTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(student.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              Text(student.balance,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFFED6A2E))),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text('Курс: ${student.group}',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey[600])),
              const Spacer(),
              Text('просрочено 4 д.',
                  style:
                      TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _AbsentStudentTile extends StatelessWidget {
  final BuildStudentsTableItem student;
  const _AbsentStudentTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFFED6A2E),
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Text('Курс: ${student.group}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side:
                      BorderSide(color: Colors.grey.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Позвонить',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      ),
    );
  }
}