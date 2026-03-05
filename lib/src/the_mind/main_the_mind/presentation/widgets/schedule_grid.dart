import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<String> rooms = ['Black', 'Blue', 'Green', 'Orange'];

  final TextEditingController roomController = TextEditingController();

  // базовые цвета комнат
  final Map<String, Color> roomColors = {
    'Black': Colors.black,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Orange': Colors.orange,
  };

  static const double timeColWidth = 110;
  static const double headerHeight = 48;
  static const double rowHeight = 44;

  List<String> generateTimes() {
    return List.generate(24, (i) {
      final hour = 7 + (i ~/ 2);
      final minute = (i % 2) * 30;
      final nextMinute = minute == 0 ? 30 : 0;
      final nextHour = minute == 0 ? hour : hour + 1;

      return '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}'
          ' - '
          '${nextHour.toString().padLeft(2, '0')}:'
          '${nextMinute.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final times = generateTimes();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// header
          Row(
            children: [
              Text(
                "Rooms schedule",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              // const Spacer(),
              // IconButton(
              //   onPressed: _addRoomDialog,
              //   icon: const Icon(Icons.add),
              // )
            ],
          ),

          const SizedBox(height: 12),

          /// table
          SizedBox(
            height: 700,
            child: LayoutBuilder(
              builder: (context, c) {
                final roomWidth = (c.maxWidth - timeColWidth) / rooms.length;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- HEADER ----------
  Widget _buildHeaderRow(double roomWidth) {
    return Row(
      children: [
        _cell('', width: timeColWidth, height: headerHeight, header: true),
        ...rooms.map(
          (r) => _cell(r, width: roomWidth, height: headerHeight, header: true),
        ),
      ],
    );
  }

  /// ---------- TIME ROW ----------
  Widget _buildTimeRow(String time, double roomWidth) {
    return Row(
      children: [
        _cell(time, width: timeColWidth, height: rowHeight, time: true),
        ...List.generate(
          rooms.length,
          (_) => _cell('', width: roomWidth, height: rowHeight),
        ),
      ],
    );
  }

  /// ---------- CELL ----------
  Widget _cell(
    String text, {
    required double width,
    required double height,
    bool header = false,
    bool time = false,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: header
            ? const Color(0xFFF3F4F6)
            : time
            ? const Color(0xFFF9FAFB)
            : Colors.white,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black87,
          fontWeight: header || time ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  /// ---------- EVENTS ----------
  List<Widget> _buildEvents(double roomWidth) {
    return [
      _eventBox(
        roomWidth: roomWidth,
        roomIndex: 1,
        startRow: 4,
        rows: 3,
        title: 'Beginner\nTeacher A',
      ),
      _eventBox(
        roomWidth: roomWidth,
        roomIndex: 2,
        startRow: 10,
        rows: 2,
        title: 'Intermediate\nTeacher B',
      ),
    ];
  }

  Widget _eventBox({
    required double roomWidth,
    required int roomIndex,
    required int startRow,
    required int rows,
    required String title,
  }) {
    final roomName = rooms[roomIndex];
    final baseColor = roomColors[roomName] ?? Colors.grey;
    final darkColor = lighten(baseColor);

    return Positioned(
      top: headerHeight + startRow * rowHeight,
      left: timeColWidth + roomIndex * roomWidth,
      child: Container(
        width: roomWidth,
        height: rows * rowHeight,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: darkColor, // цвет карточки совпадает с комнатой
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 3),
              color: Colors.black26,
            ),
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// функция затемнения цвета
  Color lighten(Color color) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  /// ---------- ADD ROOM ----------
  void _addRoomDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Add room"),
        content: TextField(controller: roomController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (roomController.text.isNotEmpty) {
                setState(() {
                  rooms.add(roomController.text);
                  roomColors[roomController.text] =
                      Colors.primaries[rooms.length % Colors.primaries.length];
                });
                roomController.clear();
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
