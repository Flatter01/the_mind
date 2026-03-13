import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/history_item.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/info_field.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/profile_header.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/score_metric.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/section_card.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/students_details/table_header.dart';

class StudentDetailsPage extends StatefulWidget {
  final StudentModel student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  int _selectedTab = 0;

  // Скидка — редактируемая
  int _discountAmount = 0;
  bool _editingDiscount = false;
  late TextEditingController _discountCtrl;

  final List<Map<String, dynamic>> history = const [
    {
      "type": "payment",
      "title": "Частичная оплата",
      "description": "Поступление 5 000 Сум на счет через терминал.",
      "date": "24 ОКТЯБРЯ",
      "color": Color(0xFFED6A2E),
      "icon": Icons.account_balance_wallet_outlined,
    },
    {
      "type": "absence",
      "title": "Пропуск занятия",
      "description": "Занятие: \"События в DOM\". Причина не указана.",
      "date": "21 ОКТЯБРЯ",
      "color": Colors.redAccent,
      "icon": Icons.cancel_outlined,
    },
    {
      "type": "group_add",
      "title": "Зачисление в группу",
      "description": "Добавлен в основную группу \"Веб-разработка (Level 2)\".",
      "date": "1 СЕНТЯБРЯ",
      "color": Color(0xFF6B7FD4),
      "icon": Icons.group_add_outlined,
    },
    {
      "type": "profile",
      "title": "Создание профиля",
      "description": "Студент зарегистрирован в базе данных системы.",
      "date": "31 АВГУСТА",
      "color": Color(0xFF8A9BB8),
      "icon": Icons.person_add_outlined,
    },
  ];

  final List<Map<String, dynamic>> payments = const [
    {
      "date": "12.10.2023",
      "purpose": "Оплата обучения (Октябрь)",
      "amount": "8 500 Сум",
      "status": "Успешно",
    },
    {
      "date": "15.09.2023",
      "purpose": "Учебные материалы",
      "amount": "1 200 Сум",
      "status": "Успешно",
    },
  ];

  final List<Map<String, dynamic>> grades = const [
    {"label": "5", "subject": "Вёрстка (HTML)", "color": Color(0xFF2ECC8A)},
    {"label": "5-", "subject": "CSS Grid Test", "color": Color(0xFFED6A2E)},
    {"label": "5", "subject": "Анимации", "color": Color(0xFF2ECC8A)},
    {"label": "4", "subject": "JS Basic", "color": Color(0xFFED6A2E)},
  ];

  @override
  void initState() {
    super.initState();
    _discountCtrl = TextEditingController(text: _discountAmount.toString());
  }

  @override
  void dispose() {
    _discountCtrl.dispose();
    super.dispose();
  }

  // Баланс с учётом скидки
  int get _rawBalance {
    final raw = widget.student.balance.replaceAll(RegExp(r'[^0-9\-]'), '');
    return int.tryParse(raw) ?? 0;
  }

  // Долг = отрицательный баланс
  int get _debtAmount => _rawBalance < 0 ? _rawBalance.abs() : 0;

  // Долг после скидки
  int get _debtAfterDiscount {
    final debt = _debtAmount - _discountAmount;
    return debt < 0 ? 0 : debt;
  }

  // Итоговый баланс после скидки
  int get _balanceAfterDiscount {
    if (_rawBalance < 0) {
      return -_debtAfterDiscount;
    }
    return _rawBalance;
  }

  String get _balanceDisplay {
    final v = _rawBalance;
    return v < 0 ? '-${v.abs()} Сум' : '$v Сум';
  }

  String get _debtAfterDiscountDisplay {
    return _debtAfterDiscount > 0 ? '-$_debtAfterDiscount Сум' : '0 Сум';
  }

  void _saveDiscount() {
    final val = int.tryParse(_discountCtrl.text) ?? 0;
    setState(() {
      _discountAmount = val;
      _editingDiscount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final isDebtor = _balanceAfterDiscount < 0;
    final balanceColor = isDebtor
        ? const Color(0xFFED6A2E)
        : const Color(0xFF2ECC8A);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(student: s, isDebtor: isDebtor),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Левая колонка ──────────────────────────────────────
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          SectionCard(
                            title: 'Личные данные',
                            trailing: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InfoField(
                                        label: 'ИМЯ ФАМИЛИЯ',
                                        value:
                                            '${s.lastName ?? ''} ${s.firstName ?? ''}',
                                      ),
                                    ),
                                    Expanded(
                                      child: InfoField(
                                        label: 'ДАТА РОЖДЕНИЯ',
                                        value: s.birthDate ?? '—',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InfoField(
                                        label: 'ПОЛ',
                                        value: s.gender ?? '—',
                                      ),
                                    ),
                                    Expanded(
                                      child: InfoField(
                                        label: 'ТЕЛЕФОН',
                                        value: s.phone ?? '—',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InfoField(
                                        label: 'ОСНОВНАЯ ГРУППА',
                                        value: s.groupName ?? '—',
                                        valueColor: const Color(0xFFED6A2E),
                                      ),
                                    ),
                                    Expanded(
                                      child: InfoField(
                                        label: 'ПРЕПОДАВАТЕЛЬ',
                                        value: s.teacherName ?? '—',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Финансовое состояние
                          SectionCard(
                            title: 'Финансовое состояние',
                            trailing: _debtAfterDiscount > 0
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.warning_amber_rounded,
                                        size: 14,
                                        color: Color(0xFFED6A2E),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Долг: $_debtAfterDiscountDisplay',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFED6A2E),
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                            child: Column(
                              children: [
                                const SizedBox(height: 16),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ── Общий баланс (сколько есть денег) ──
                                    Expanded(
                                      child: InfoField(
                                        label: 'ОБЩИЙ БАЛАНС',
                                        value:
                                            _balanceDisplay, // всегда оригинальный баланс
                                        valueColor: _rawBalance < 0
                                            ? const Color(0xFFED6A2E)
                                            : const Color(0xFF2ECC8A),
                                        valueBold: true,
                                        valueFontSize: 22,
                                      ),
                                    ),

                                    // ── Персональная скидка (редактируемая) ──
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ПЕРСОНАЛЬНАЯ СКИДКА',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey[400],
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          if (_editingDiscount)
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 38,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFFED6A2E,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: TextField(
                                                      controller: _discountCtrl,
                                                      autofocus: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 8,
                                                                ),
                                                            suffixText: 'Сум',
                                                            suffixStyle:
                                                                TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                          ),
                                                      onSubmitted: (_) =>
                                                          _saveDiscount(),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                GestureDetector(
                                                  onTap: _saveDiscount,
                                                  child: Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF2ECC8A,
                                                      ).withOpacity(0.12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      size: 16,
                                                      color: Color(0xFF2ECC8A),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                GestureDetector(
                                                  onTap: () => setState(
                                                    () => _editingDiscount =
                                                        false,
                                                  ),
                                                  child: Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            GestureDetector(
                                              onTap: () {
                                                _discountCtrl.text =
                                                    _discountAmount.toString();
                                                setState(
                                                  () => _editingDiscount = true,
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _discountAmount > 0
                                                        ? '$_discountAmount Сум'
                                                        : 'Не задана',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: _discountAmount > 0
                                                          ? const Color(
                                                              0xFF2ECC8A,
                                                            )
                                                          : Colors.grey[400],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFED6A2E,
                                                      ).withOpacity(0.08),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFFED6A2E,
                                                        ).withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        Icon(
                                                          Icons.edit_outlined,
                                                          size: 11,
                                                          color: Color(
                                                            0xFFED6A2E,
                                                          ),
                                                        ),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          'изменить',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color(
                                                              0xFFED6A2E,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // ── К оплате (долг после скидки) ──
                                    Expanded(
                                      child: InfoField(
                                        label: 'К ОПЛАТЕ',
                                        value: _debtAfterDiscount > 0
                                            ? '$_debtAfterDiscount Сум'
                                            : '0 Сум',
                                        valueColor: _debtAfterDiscount > 0
                                            ? const Color(0xFFED6A2E)
                                            : const Color(0xFF2ECC8A),
                                        valueBold: true,
                                        valueFontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),

                                // Подсказка если скидка задана
                                if (_discountAmount > 0 && _debtAmount > 0) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF2ECC8A,
                                      ).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.discount_outlined,
                                          size: 14,
                                          color: Color(0xFF2ECC8A),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Скидка $_discountAmount Сум применена. '
                                            'Долг был: $_debtAmount Сум → к оплате: $_debtAfterDiscount Сум',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF2ECC8A),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                if (_discountAmount > 0 &&
                                    _debtAmount == 0) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          size: 14,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Скидка задана, но у студента нет долга.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),

                                // Заголовок таблицы
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        flex: 2,
                                        child: TableHeader('ДАТА'),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: TableHeader('НАЗНАЧЕНИЕ'),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TableHeader('СУММА'),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TableHeader('СТАТУС'),
                                      ),
                                    ],
                                  ),
                                ),

                                ...payments.map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            p['date'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            p['purpose'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            p['amount'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            p['status'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2ECC8A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Академические успехи
                          SectionCard(
                            title: 'Академические успехи',
                            trailing: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Детальный отчет',
                                style: TextStyle(
                                  color: Color(0xFFED6A2E),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ScoreMetric(
                                        label: 'ДОМАШНИЕ\nЗАДАНИЯ',
                                        score: 4.9,
                                      ),
                                    ),
                                    Expanded(
                                      child: ScoreMetric(
                                        label: 'ТЕСТЫ И ЭКЗАМЕНЫ',
                                        score: 4.7,
                                      ),
                                    ),
                                    Expanded(
                                      child: ScoreMetric(
                                        label: 'АКТИВНОСТЬ',
                                        score: 5.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'ПОСЛЕДНИЕ ОЦЕНКИ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[500],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: grades
                                      .map(
                                        (g) => Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8F9FB),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  g['label'],
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w800,
                                                    color: g['color'] as Color,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  g['subject'],
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey[500],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // ── Правая колонка ─────────────────────────────────────
                    SizedBox(
                      width: 300,
                      child: SectionCard(
                        title: 'История активности',
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            ...history.map((h) => HistoryItem(item: h)),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Показать всю историю',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
