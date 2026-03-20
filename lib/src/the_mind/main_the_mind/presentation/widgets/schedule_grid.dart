import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

const _orange = Color(0xFFED6A2E);
const _bg = Color(0xFFF7F8FA);
const _border = Color(0xFFE8EAF0);
const _text = Color(0xFF1A1F36);
const _grey = Color(0xFF8A94A6);

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> rooms = ['Black', 'Blue', 'Green', 'Orange'];
  final _roomCtrl = TextEditingController();

  final Map<String, Color> roomColors = {
    'Black': const Color(0xFF1A2233),
    'Blue': const Color(0xFF6B7FD4),
    'Green': const Color(0xFF2ECC8A),
    'Orange': const Color(0xFFED6A2E),
  };

  static const double _timeColWidth = 120;
  static const double _headerHeight = 52;
  static const double _rowHeight = 46;

  List<String> _generateTimes() {
    return List.generate(24, (i) {
      final hour = 7 + (i ~/ 2);
      final minute = (i % 2) * 30;
      final nextMinute = minute == 0 ? 30 : 0;
      final nextHour = minute == 0 ? hour : hour + 1;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'
          ' — '
          '${nextHour.toString().padLeft(2, '0')}:${nextMinute.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _roomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final times = _generateTimes();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: _orange,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Расписание комнат',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  Text(
                    '${rooms.length} комнат',
                    style: const TextStyle(fontSize: 12, color: _grey),
                  ),
                ],
              ),
              const Spacer(),

              // ── Легенда комнат ──
              ...rooms.map((r) {
                final color = roomColors[r] ?? Colors.grey;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          r,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(width: 16),

              // ── Кнопка добавить комнату ──
              _AddRoomButton(onTap: _showAddRoomDialog),
            ],
          ),

          const SizedBox(height: 20),

          // ── Таблица ──
          SizedBox(
            height: 620,
            child: LayoutBuilder(
              builder: (context, c) {
                final roomWidth = (c.maxWidth - _timeColWidth) / rooms.length;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: _border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              _buildHeaderRow(roomWidth),
                              ...times.map((t) => _buildTimeRow(t, roomWidth)),
                            ],
                          ),
                          ..._buildEvents(roomWidth),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Заголовок ──────────────────────────────────────────────────────────────

  Widget _buildHeaderRow(double roomWidth) {
    return SizedBox(
      height: _headerHeight,
      child: Row(
        children: [
          SizedBox(
            width: _timeColWidth,
            child: Container(
              height: _headerHeight,
              alignment: Alignment.center,
              color: _bg,
              child: const Text(
                'ВРЕМЯ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _grey,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Container(width: 1, height: _headerHeight, color: _border),
          ...rooms.map((r) {
            final color = roomColors[r] ?? Colors.grey;
            return Expanded(
              child: Container(
                height: _headerHeight,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.06),
                  border: Border(
                    bottom: BorderSide(color: _border),
                    left: BorderSide(color: Colors.grey.withOpacity(0.08)),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  r.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {required double width}) {
    return Container(
      width: width,
      height: _headerHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Строка времени ─────────────────────────────────────────────────────────

  Widget _buildTimeRow(String time, double roomWidth) {
    return SizedBox(
      height: _rowHeight,
      child: Row(
        children: [
          // ── Время ──
          SizedBox(
            width: _timeColWidth,
            child: Container(
              height: _rowHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _bg,
                border: Border(
                  // ← убрали right border, он добавляет 1px
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.06)),
                ),
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: _grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // ── Разделитель между временем и комнатами ──
          Container(width: 1, height: _rowHeight, color: _border),

          // ── Ячейки комнат ──
          ...List.generate(rooms.length, (i) {
            return Expanded(
              // ← Expanded вместо фиксированной ширины
              child: Container(
                height: _rowHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: i == 0
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.withOpacity(0.08)),
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.06)),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  // ── Ивенты ─────────────────────────────────────────────────────────────────

  List<Widget> _buildEvents(double roomWidth) {
    return [
      _eventBox(
        roomWidth: roomWidth,
        roomIndex: 1,
        startRow: 4,
        rows: 3,
        title: 'Beginner',
        subtitle: 'Teacher A',
      ),
      _eventBox(
        roomWidth: roomWidth,
        roomIndex: 2,
        startRow: 10,
        rows: 2,
        title: 'Intermediate',
        subtitle: 'Teacher B',
      ),
      _eventBox(
        roomWidth: roomWidth,
        roomIndex: 0,
        startRow: 6,
        rows: 4,
        title: 'IELTS 7.0',
        subtitle: 'Teacher C',
      ),
    ];
  }

  Widget _eventBox({
    required double roomWidth,
    required int roomIndex,
    required int startRow,
    required int rows,
    required String title,
    required String subtitle,
  }) {
    final roomName = rooms[roomIndex];
    final color = roomColors[roomName] ?? Colors.grey;

    return Positioned(
      top: _headerHeight + startRow * _rowHeight + 3,
      left: _timeColWidth + roomIndex * roomWidth + 4,
      child: Container(
        width: roomWidth - 8,
        height: rows * _rowHeight - 6,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (rows > 1) ...[
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Диалог добавить комнату ────────────────────────────────────────────────

  void _showAddRoomDialog() {
    String? selectedColor;
    final colorOptions = {
      'Красный': const Color(0xFFE53E3E),
      'Оранжевый': _orange,
      'Зелёный': const Color(0xFF2ECC8A),
      'Синий': const Color(0xFF6B7FD4),
      'Серый': const Color(0xFF8A9BB8),
      'Тёмный': const Color(0xFF1A2233),
    };

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 32,
          ),
          elevation: 0,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 18),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.meeting_room_outlined,
                          color: _orange,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Добавить комнату',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Название
                      const Text(
                        'НАЗВАНИЕ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _grey,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _roomCtrl,
                        style: const TextStyle(fontSize: 13, color: _text),
                        decoration: InputDecoration(
                          hintText: 'Например: Red Room',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: _grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.meeting_room_outlined,
                            size: 17,
                            color: _grey,
                          ),
                          filled: true,
                          fillColor: _bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: _orange,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Цвет
                      const Text(
                        'ЦВЕТ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _grey,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: colorOptions.entries.map((e) {
                          final isSelected = selectedColor == e.key;
                          return GestureDetector(
                            onTap: () =>
                                setDialogState(() => selectedColor = e.key),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? e.value.withOpacity(0.12)
                                    : _bg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? e.value : _border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: e.value,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    e.key,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isSelected ? e.value : _grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.12)),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Отмена',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (_roomCtrl.text.trim().isEmpty) return;
                          setState(() {
                            final name = _roomCtrl.text.trim();
                            rooms.add(name);
                            roomColors[name] = selectedColor != null
                                ? colorOptions[selectedColor]!
                                : Colors.primaries[rooms.length %
                                      Colors.primaries.length];
                          });
                          _roomCtrl.clear();
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: _orange,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: _orange.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 15, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Добавить',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Кнопка добавить комнату ──────────────────────────────────────────────────

class _AddRoomButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AddRoomButton({required this.onTap});

  @override
  State<_AddRoomButton> createState() => _AddRoomButtonState();
}

class _AddRoomButtonState extends State<_AddRoomButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) {
        if (!_hovered) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _hovered ? _orange : _orange.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _orange.withOpacity(_hovered ? 0.4 : 0.2),
                blurRadius: _hovered ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 15, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'Комната',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
