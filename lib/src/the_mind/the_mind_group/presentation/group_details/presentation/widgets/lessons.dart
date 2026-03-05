import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/data/model/student_model.dart';

class Lessons extends StatefulWidget {
  final List<StudentModel> students;
  final List<String> lessonDates;

  const Lessons({
    super.key,
    required this.students,
    required this.lessonDates,
  });

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {

  /// Баллы студент -> дата -> балл
  final Map<String, Map<String, int>> scores = {};

  @override
  Widget build(BuildContext context) {

    return AppCard(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Посещаемость и баллы",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          Flexible(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(

                  columnSpacing: 14,

                  columns: [

                    const DataColumn(
                      label: Text('Студент'),
                    ),

                    ...widget.lessonDates
                        .map((d) => DataColumn(label: Text(d))),

                  ],

                  rows: widget.students
                      .map((s) => _row(context, s))
                      .toList(),

                ),
              ),
            ),
          ),

        ],
      ),
    );
  }



  /// строка таблицы
  DataRow _row(BuildContext context, StudentModel s) {

    return DataRow(

      cells: [

        DataCell(Text(s.name)),

        ...widget.lessonDates.map((date) {

          Attendance? record;

          try {
            record = s.attendanceHistory
                .firstWhere((a) => a.date == date);
          } catch (_) {
            record = null;
          }

          return DataCell(
              _cell(context, s, date, record)
          );

        }),

      ],

    );
  }



  /// ячейка
  Widget _cell(
      BuildContext context,
      StudentModel s,
      String date,
      Attendance? record,
      ) {

    final state = record?.isPresent;

    final score =
        scores[s.name]?[date];

    Color bg = Colors.transparent;

    if (state == true) bg = Colors.green;
    if (state == false) bg = Colors.red;

    return InkWell(

      onTap: () {

        /// используем context прямо отсюда
        _openDialog(context, s, date);

      },

      child: Container(

        width: 80,
        height: 34,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: Colors.grey.shade300),
        ),

        child: score != null
            ? Text(
          score.toString(),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )
            : const SizedBox(),

      ),

    );
  }



  /// диалог (без использования state context)
  void _openDialog(
      BuildContext dialogContext,
      StudentModel s,
      String date,
      ) {

    bool? present;

    int score =
        scores[s.name]?[date] ?? 0;

    showDialog(

      context: dialogContext,

      builder: (ctx) {

        return AlertDialog(

          title: const Text("Урок"),

          content: StatefulBuilder(
            builder: (ctx, setDialog) {

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// посещаемость

                  Row(

                    children: [

                      const Text("Посещаемость"),

                      const Spacer(),

                      IconButton(
                        onPressed: () {
                          setDialog(() {
                            present = true;
                          });
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setDialog(() {
                            present = false;
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  /// баллы

                  Row(
                    children: [

                      const Text("Баллы"),

                      const Spacer(),

                      DropdownButton<int>(

                        value: score,

                        items: List.generate(
                          11,
                              (i) => DropdownMenuItem(
                            value: i,
                            child: Text(i.toString()),
                          ),
                        ),

                        onChanged: (v) {
                          setDialog(() {
                            score = v!;
                          });
                        },

                      ),

                    ],
                  ),

                ],
              );
            },
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.of(ctx).pop();
              },

              child: const Text("Отмена"),

            ),


            ElevatedButton(

              onPressed: () {

                Navigator.of(ctx).pop();

                if (!mounted) return;

                /// посещаемость
                _setValue(s, date, present);

                /// баллы
                scores.putIfAbsent(
                        s.name,
                            () => {});

                scores[s.name]![date] =
                    score;

                setState(() {});

              },

              child: const Text("Сохранить"),

            ),

          ],

        );
      },

    );
  }



  /// запись посещаемости
  void _setValue(
      StudentModel s,
      String date,
      bool? value,
      ) {

    if (!mounted) return;

    final i = s.attendanceHistory
        .indexWhere(
            (a) => a.date == date);

    if (value == null) {

      if (i >= 0) {
        s.attendanceHistory.removeAt(i);
      }

      return;
    }

    if (i >= 0) {

      s.attendanceHistory[i] =
          Attendance(
            date: date,
            isPresent: value,
          );

    }
    else {

      s.attendanceHistory.add(
        Attendance(
          date: date,
          isPresent: value,
        ),
      );

    }

  }

}
