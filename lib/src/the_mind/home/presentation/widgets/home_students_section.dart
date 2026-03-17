import 'package:flutter/material.dart';

import 'package:srm/src/core/assets/assets.gen.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/students_list_widget.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';

class HomeStudentsSection extends StatelessWidget {
  const HomeStudentsSection({super.key});

  static final List<BuildStudentsTableItem> _trialLesson = [
    BuildStudentsTableItem(
      id: 0,
      name: "Марина Ковалева",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "Английский",
      balance: "0",
      status: "Probniy dars",
      called: false,
      missedLessons: 0,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Артем Сидоров",
      phone: "+998 90 111 22 33",
      teacher: "Aziz",
      group: "Программирование",
      balance: "0",
      status: "Probniy dars",
      called: false,
      missedLessons: 0,
    ),
    BuildStudentsTableItem(
      id: 2,
      name: "Анна Лебедева",
      phone: "+998 90 444 55 66",
      teacher: "Aziz",
      group: "Дизайн",
      balance: "0",
      status: "Probniy dars",
      called: false,
      missedLessons: 0,
    ),
  ];

  static final List<BuildStudentsTableItem> _debtors = [
    BuildStudentsTableItem(
      id: 0,
      name: "Виктор Петров",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "Frontend Developer",
      balance: "12 400 ₽",
      status: "Qarzdor",
      called: true,
      missedLessons: 4,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Елена Кравц",
      phone: "+998 90 777 88 99",
      teacher: "Aziz",
      group: "UX/UI Design",
      balance: "5 800 ₽",
      status: "Qarzdor",
      called: true,
      missedLessons: 12,
    ),
    BuildStudentsTableItem(
      id: 2,
      name: "Иван Макаров",
      phone: "+998 90 555 66 77",
      teacher: "Aziz",
      group: "Java Start",
      balance: "15 000 ₽",
      status: "Qarzdor",
      called: false,
      missedLessons: 2,
    ),
  ];

  static final List<BuildStudentsTableItem> _didntCome = [
    BuildStudentsTableItem(
      id: 0,
      name: "Сергей Новиков",
      phone: "+998 90 999 11 22",
      teacher: "Aziz",
      group: "Английский",
      balance: "0",
      status: "Kelmadi",
      called: false,
      missedLessons: 1,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Ольга Разумовская",
      phone: "+998 90 333 44 55",
      teacher: "Aziz",
      group: "Математика",
      balance: "0",
      status: "Kelmadi",
      called: false,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 2,
      name: "Дмитрий Кузин",
      phone: "+998 90 666 77 88",
      teacher: "Aziz",
      group: "Дизайн",
      balance: "0",
      status: "Kelmadi",
      called: false,
      missedLessons: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StudentsListWidget(
            title: 'Записанные на пробный',
            icons: Assets.icons.arrived.svg(),
            quantity: '${_trialLesson.length}',
            blockType: StudentsBlockType.trial,
            students: _trialLesson,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StudentsListWidget(
            title: 'Должники',
            icons: Assets.icons.debtor.svg(),
            quantity: '${_debtors.length}',
            blockType: StudentsBlockType.debtors,
            students: _debtors,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StudentsListWidget(
            title: 'Не пришедшие',
            icons: Assets.icons.didntCome.svg(),
            quantity: '${_didntCome.length}',
            blockType: StudentsBlockType.absent,
            students: _didntCome,
          ),
        ),
      ],
    );
  }
}
