import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/kurs/lid_kurs_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_group_model.dart';

/// =====================
/// BOOK MODEL
/// =====================

class BookModel {
  final String name;

  BookModel(this.name);
}

/// =====================
/// MODEL
/// =====================

class LidData {
  final String? source;
  final String? gender;
  final String? region;

  final LidGroupModel? group;
  final LidKursModel? kurs;

  final String? comment;
  final String? status;

  final DateTime? date;
  final DateTime? testDate;
  final TimeOfDay? testTime;

  final List<BookModel> books;

  LidData({
    this.source,
    this.gender,
    this.region,
    this.group,
    this.kurs,
    this.comment,
    this.status,
    this.date,
    this.testDate,
    this.testTime,
    this.books = const [],
  });
}

/// =====================
/// DIALOG
/// =====================

Future<void> showAddLidDialog({
  required BuildContext context,
  required List<LidGroupModel> groups,
  required List<LidKursModel> kursList,
  required List<BookModel> booksList,
  required void Function(LidData) onSave,
  required List<String> branches,
}) async {
  final commentController = TextEditingController();

  String? source;
  String? gender = "Erkak";
  String? region;
  String? status;

  LidGroupModel? selectedGroup;
  LidKursModel? selectedKurs;

  DateTime? selectedDate;
  DateTime? testDate;
  TimeOfDay? testTime;

  bool giveBooks = false;

  List<BookModel?> selectedBooks = [null];

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 220, vertical: 40),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

        child: Container(
          padding: const EdgeInsets.all(28),

          color: AppColors.bgColor,

          child: StatefulBuilder(
            builder: (context, setState) {
              /// DATE приход
              Future<void> pickDate() async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  setState(() => selectedDate = date);
                }
              }

              /// TEST DATE
              Future<void> pickTestDate() async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  setState(() => testDate = date);
                }
              }

              /// TEST TIME
              Future<void> pickTestTime() async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time != null) {
                  setState(() => testTime = time);
                }
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// HEADER
                    Row(
                      children: [
                        const Text(
                          "Yangi lid qo'shish",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// DATE
                    _label("Sana"),

                    InkWell(
                      onTap: pickDate,

                      child: _dateContainer(
                        selectedDate == null
                            ? "Sanani tanlang"
                            : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BRANCH
                    _label("Filial"),

                    _stringDropdown(
                      value: region,
                      items: branches,
                      onChanged: (v) => setState(() => region = v),
                    ),

                    const SizedBox(height: 20),

                    /// STATUS
                    _label("Qayerga qo'shilsin"),

                    _stringDropdown(
                      value: status,

                      items: const [
                        "Test",
                        "Probniy guruh",
                        "Faol o'quvchilar",
                      ],

                      onChanged: (v) {
                        setState(() {
                          status = v;

                          selectedGroup = null;
                          testDate = null;
                          testTime = null;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    /// TEST
                    if (status == "Test") ...[
                      _label("Test sanasi"),

                      InkWell(
                        onTap: pickTestDate,

                        child: _dateContainer(
                          testDate == null
                              ? "Test sanasini tanlang"
                              : "${testDate!.day}.${testDate!.month}.${testDate!.year}",
                        ),
                      ),

                      const SizedBox(height: 20),

                      _label("Test vaqti"),

                      InkWell(
                        onTap: pickTestTime,

                        child: _dateContainer(
                          testTime == null
                              ? "Test vaqtini tanlang"
                              : "${testTime!.hour}:${testTime!.minute.toString().padLeft(2, '0')}",
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],

                    /// GROUP
                    if (status == "Probniy guruh") ...[
                      _label("Guruh"),

                      _groupDropdown(
                        groups: groups,
                        value: selectedGroup,
                        onChanged: (g) => setState(() => selectedGroup = g),
                      ),

                      if (selectedGroup?.isExamNow == true) ...[
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),

                            border: Border.all(color: Colors.red),

                            borderRadius: BorderRadius.circular(4),
                          ),

                          child: const Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red),

                              SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  "Diqqat! Hozir ushbu guruhda imtihon bo‘lyapti.",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                    ],

                    /// SOURCE
                    _label("Manba"),

                    _stringDropdown(
                      value: source,
                      items: const ["Instagram", "Telegram", "Call"],
                      onChanged: (v) => setState(() => source = v),
                    ),

                    const SizedBox(height: 20),

                    /// GENDER
                    _label("Jins"),

                    _stringDropdown(
                      value: gender,
                      items: const ["Erkak", "Ayol"],
                      onChanged: (v) => setState(() => gender = v),
                    ),

                    const SizedBox(height: 20),

                    /// KURS
                    _label("Kurs"),

                    _kursDropdown(
                      kursList: kursList,
                      value: selectedKurs,
                      onChanged: (k) => setState(() => selectedKurs = k),
                    ),

                    const SizedBox(height: 25),

                    /// BOOKS
                    Row(
                      children: [
                        Checkbox(
                          value: giveBooks,
                          onChanged: (v) {
                            setState(() => giveBooks = v!);
                          },
                        ),

                        const Text(
                          "Kitob berish",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    if (giveBooks) ...[
                      const SizedBox(height: 15),

                      ...List.generate(selectedBooks.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),

                          child: DropdownButtonFormField<BookModel>(
                            value: selectedBooks[index],

                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),

                            items: booksList.map((b) {
                              return DropdownMenuItem(
                                value: b,
                                child: Text(b.name),
                              );
                            }).toList(),

                            onChanged: (v) {
                              setState(() => selectedBooks[index] = v);
                            },
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 25),

                    /// COMMENT
                    _label("Izoh"),

                    _input(commentController, maxLines: 3),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                      ),

                      onPressed: () {
                        onSave(
                          LidData(
                            source: source,
                            gender: gender,
                            region: region,

                            group: selectedGroup,
                            kurs: selectedKurs,

                            comment: commentController.text,

                            status: status,

                            date: selectedDate,
                            testDate: testDate,
                            testTime: testTime,

                            books: giveBooks
                                ? selectedBooks.whereType<BookModel>().toList()
                                : [],
                          ),
                        );

                        Navigator.pop(context);
                      },

                      child: const Text(
                        "Saqlash",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

/// =====================
/// WIDGETS
/// =====================

Widget _label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),

    child: Text(
      text,

      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    ),
  );
}

Widget _dateContainer(String text) {
  return Container(
    height: 50,

    alignment: Alignment.centerLeft,

    padding: const EdgeInsets.symmetric(horizontal: 12),

    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffd0d5dd)),

      borderRadius: BorderRadius.circular(4),
    ),

    child: Text(text),
  );
}

Widget _input(TextEditingController? controller, {int maxLines = 1}) {
  return TextField(
    controller: controller,

    maxLines: maxLines,

    decoration: const InputDecoration(border: OutlineInputBorder()),
  );
}

Widget _stringDropdown({
  required List<String> items,

  required ValueChanged<String?> onChanged,

  String? value,
}) {
  return DropdownButtonFormField<String>(
    value: value,

    isExpanded: true,

    decoration: const InputDecoration(border: OutlineInputBorder()),

    items: items.map((e) {
      return DropdownMenuItem(value: e, child: Text(e));
    }).toList(),

    onChanged: onChanged,
  );
}

Widget _kursDropdown({
  required List<LidKursModel> kursList,

  required LidKursModel? value,

  required ValueChanged<LidKursModel?> onChanged,
}) {
  return DropdownButtonFormField<LidKursModel>(
    value: value,

    isExpanded: true,

    decoration: const InputDecoration(border: OutlineInputBorder()),

    items: kursList.map((k) {
      return DropdownMenuItem(value: k, child: Text(k.kursName));
    }).toList(),

    onChanged: onChanged,
  );
}

Widget _groupDropdown({
  required List<LidGroupModel> groups,

  required LidGroupModel? value,

  required ValueChanged<LidGroupModel?> onChanged,
}) {
  return DropdownButtonFormField<LidGroupModel>(
    value: value,

    isExpanded: true,

    decoration: const InputDecoration(border: OutlineInputBorder()),

    items: groups.map((g) {
      return DropdownMenuItem(
        value: g,

        child: Text(
          "Group:${g.name} • ${g.lessonTime}",
          style: TextStyle(color: g.isExamNow ? Colors.red : Colors.black),
        ),
      );
    }).toList(),

    onChanged: onChanged,
  );
}
