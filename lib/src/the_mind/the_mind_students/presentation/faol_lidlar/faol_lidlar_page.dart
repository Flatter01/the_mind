import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/kurs/lid_kurs_model.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_group_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/faol_lidlar/show_add_action_picker.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_models.dart';

class FaolLidlarPage extends StatefulWidget {
  const FaolLidlarPage({super.key});

  @override
  State<FaolLidlarPage> createState() => _FaolLidlarPageState();
}

class _FaolLidlarPageState extends State<FaolLidlarPage> {
  String _search = '';

  final List<String> allStatuses = [
    'Лиды',
    'В ожидании',
    'Пришёл',
    'Не пришёл',
    'Позвонить',
    'Не ответил',
  ];

  final List<LidKursModel> kurs = [
    LidKursModel(kursName: "Beginner", kursPrice: 800000),
    LidKursModel(kursName: "Intermediate", kursPrice: 800000),
    LidKursModel(kursName: "Individual", kursPrice: 800000),
  ];

  final List<LidGroupModel> lidGroup = [
    LidGroupModel(
      id: "1",
      name: "Flutter A1",
      teacherName: "Ali",
      studentsCount: 12,
      isExamNow: false,
      lessonTime: "14:00-15:30",
      evenWeeks: true,
      daysPerWeek: 3,
    ),
    LidGroupModel(
      id: "2",
      name: "IELTS B2",
      teacherName: "Sara",
      studentsCount: 8,
      isExamNow: false,
      lessonTime: "10:00-11:30",
      evenWeeks: false,
      daysPerWeek: 2,
    ),
  ];

  late Map<String, List<LidModels>> columns;

  @override
  void initState() {
    super.initState();
    
    columns = {
      'Лиды': [
        LidModels(
          name: 'Александр Иванов',
          phone: '+7 (900) 123-45-67',
          group: 'Группа A',
          date: '26.10.2023',
          status: 'Лиды',
          gender: "",
          branch: "Toshkent",
          tariff: "Standart",
          day: "Понедельник",
          reason: "На тест",
        ),
        LidModels(
          name: 'Марина Сергеева',
          phone: '+7 (900) 555-12-12',
          group: 'Группа B',
          date: '27.10.2023',
          status: 'Лиды',
          gender: "",
          branch: "Toshkent",
          tariff: "Standart",
          day: "Понедельник",
          reason: "На пробное занятие",
        ),
      ],
      'В ожидании': [
        LidModels(
          name: 'Дмитрий Петров',
          phone: '+7 (900) 777-88-99',
          group: 'Группа C',
          date: '24.10.2023',
          status: 'В ожидании',
          gender: "",
          branch: "Toshkent",
          tariff: "Standart",
          day: "Понедельник",
          reason: "На консультацию",
        ),
      ],
      'Пришёл': [
        LidModels(
          name: 'Сергей Новиков',
          phone: '+7 (900) 111-22-33',
          group: 'Группа D',
          date: '24.10.2023',
          status: 'Пришёл',
          gender: "",
          branch: "Toshkent",
          tariff: "Standart",
          day: "Понедельник",
          reason: "На тест",
        ),
      ],
      'Не пришёл': [
        LidModels(
          name: 'Елена Васильева',
          phone: '+7 (900) 333-22-11',
          group: 'Группа E',
          date: '24.10.2023',
          status: 'Не пришёл',
          gender: "",
          branch: "Toshkent",
          tariff: "Standart",
          day: "Понедельник",
          reason: "На пробное занятие",
        ),
      ],
      'Позвонить': [
        LidModels(
          name: 'Виктор Смирнов',
          phone: '+7 (900) 444-55-66',
          group: 'Группа F',
          date: '24.10.2023',
          status: 'Позвонить',
          gender: "",
          branch: "Toshkent",
          tariff: "Standart",
          day: "Понедельник",
          reason: "На консультацию",
        ),
      ],
      'Не ответил': [
        LidModels(
          name: 'Ольга Кузнецова',
          phone: '+7 (900) 999-88-77',
          group: 'Группа G',
          date: '23.10.2023',
          status: 'Не ответил',
          gender: "",
          branch: "Toshkent",
          tariff: "Standart",
          day: "Понедельник",
          reason: "На тест",
        ),
      ],
    };
  }

  Color _columnTitleColor(String status) {
    switch (status) {
      case 'Пришёл':
        return const Color(0xFF2ECC8A);
      case 'Не пришёл':
        return const Color(0xFFED6A2E);
      case 'Позвонить':
        return const Color(0xFF6B7FD4);
      case 'Не ответил':
        return const Color(0xFF8A9BB8);
      default:
        return const Color(0xFF1A2233);
    }
  }

  Border? _cardBorder(String status) {
    if (status == 'Не пришёл') {
      return const Border(left: BorderSide(color: Color(0xFFED6A2E), width: 3));
    }
    return null;
  }

  void _moveUser(LidModels user, String fromStatus, String newStatus) {
    setState(() {
      columns[fromStatus]?.remove(user);
      user.status = newStatus;
      columns[newStatus]?.add(user);
    });
  }

  void _applyLidData(LidModels user, LidData data) {
    setState(() {
      user.group = data.group?.name ?? user.group;
      user.gender = data.gender ?? user.gender;
      user.branch = data.region ?? user.branch;
      user.tariff = data.kurs?.kursName ?? user.tariff;
      user.comment = data.comment ?? "";
    });
  }

  void _showStatusPicker(LidModels user, String currentColumn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Сменить статус'),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: allStatuses.map((status) {
              final isCurrent = status == currentColumn;
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: isCurrent
                    ? AppColors.mainColor.withOpacity(0.1)
                    : null,
                title: Text(status),
                trailing: isCurrent
                    ? Icon(Icons.check, color: AppColors.mainColor)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _moveUser(user, currentColumn, status);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _openEditDialog(LidModels user) {
    showAddLidDialog(
      context: context,
      groups: lidGroup,
      kursList: kurs,
      branches: ["Chilonzor", "Yunusobod", "Sergeli"],
      booksList: [
        BookModel("English Kids 1"),
        BookModel("English Kids 2"),
        BookModel("Grammar Book"),
      ],
      onSave: (data) => _applyLidData(user, data),
    );
  }

  List<LidModels> _filter(List<LidModels> list) {
    if (_search.isEmpty) return list;
    return list
        .where((e) => e.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фильтры
            Row(
              children: [const SizedBox(width: 300, child: BuildSearchBar())],
            ),

            const SizedBox(height: 24),

            // Канбан
            Expanded(
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: columns.entries.map((entry) {
                      final status = entry.key;
                      final data = _filter(entry.value);

                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _KanbanColumn(
                          status: status,
                          data: data,
                          titleColor: _columnTitleColor(status),
                          cardBorder: _cardBorder(status),
                          onStatusTap: (user) =>
                              _showStatusPicker(user, status),
                          onEditTap: (user) => _openEditDialog(user),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Фильтр-кнопка ───────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FilterChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Канбан колонка ──────────────────────────────────────────────────────────
// ─── Канбан колонка ──────────────────────────────────────────────────────────
class _KanbanColumn extends StatelessWidget {
  final String status;
  final List<LidModels> data;
  final Color titleColor;
  final Border? cardBorder;
  final void Function(LidModels) onStatusTap;
  final void Function(LidModels) onEditTap;

  const _KanbanColumn({
    required this.status,
    required this.data,
    required this.titleColor,
    required this.onStatusTap,
    required this.onEditTap,
    this.cardBorder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      // ← высота колонки = вся доступная высота
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 4),
            child: Row(
              children: [
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: titleColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${data.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ← Карточки в Expanded + ListView — не переполняются
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return _LidCard(
                  user: user,
                  cardBorder: cardBorder,
                  onStatusTap: () => onStatusTap(user),
                  onEditTap: () => onEditTap(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Карточка лида ────────────────────────────────────────────────────────────
class _LidCard extends StatelessWidget {
  final LidModels user;
  final Border? cardBorder;
  final VoidCallback onStatusTap;
  final VoidCallback onEditTap;

  const _LidCard({
    required this.user,
    required this.onStatusTap,
    required this.onEditTap,
    this.cardBorder,
  });

  String get _initials {
    final parts = user.name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }

  bool get _isNew => user.status == 'Лиды';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: cardBorder ?? Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Имя + бейдж
          Row(
            children: [
              Expanded(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233),
                  ),
                ),
              ),
              if (_isNew)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED6A2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'НОВЫЙ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFED6A2E),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Телефон
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 13, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Text(
                user.phone,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),

          const SizedBox(height: 6),
          if (user.reason != null && user.reason!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.info_outline, size: 13, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  'Причина: ${user.reason}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          const SizedBox(height: 6),

          // Дата добавления
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                'Добавлен: ${user.date}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Запись
          Row(
            children: [
              Icon(
                Icons.edit_calendar_outlined,
                size: 13,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                'Запись: ${user.date}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Кнопки
          Row(
            children: [
              // Статус
              GestureDetector(
                onTap: onStatusTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user.status,
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Edit
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 13,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
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
    );
  }
}
