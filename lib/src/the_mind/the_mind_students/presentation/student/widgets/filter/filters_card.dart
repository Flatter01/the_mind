import 'package:flutter/material.dart';

class FiltersCard extends StatelessWidget {
  final String search;
  final String? selectedDayType;
  final String? selectedTeacher;
  final String? selectedCourse;
  final String? selectedStatus;
  final List<String> teachers;
  final List<String> courses;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onDayTypeChanged;
  final ValueChanged<String?> onTeacherChanged;
  final ValueChanged<String?> onCourseChanged;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onReset;

  const FiltersCard({
    super.key,
    required this.search,
    required this.selectedDayType,
    required this.selectedTeacher,
    required this.selectedCourse,
    required this.selectedStatus,
    required this.teachers,
    required this.courses,
    required this.onSearchChanged,
    required this.onDayTypeChanged,
    required this.onTeacherChanged,
    required this.onCourseChanged,
    required this.onStatusChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilters = selectedDayType != null ||
        selectedTeacher != null ||
        selectedCourse != null ||
        selectedStatus != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
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
          Row(
            children: [
              Icon(Icons.tune, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'ФИЛЬТРЫ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // ── Поиск ──
              Expanded(
                flex: 2,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.withOpacity(0.25)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Поиск студента...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ── Дни ──
              _FilterDropdown(
                hint: 'Дни: Чет/Нечет',
                value: selectedDayType,
                items: const {
                  'even': 'Чётные дни',
                  'odd': 'Нечётные дни',
                },
                onChanged: onDayTypeChanged,
              ),

              const SizedBox(width: 12),

              // ── Преподаватель ──
              _FilterDropdown(
                hint: 'Преподаватель',
                value: selectedTeacher,
                items: {for (final t in teachers) t: t},
                onChanged: onTeacherChanged,
              ),

              const SizedBox(width: 12),

              // ── Курс ──
              _FilterDropdown(
                hint: 'Курс',
                value: selectedCourse,
                items: {for (final c in courses) c: c},
                onChanged: onCourseChanged,
              ),

              const SizedBox(width: 12),

              // ── Статус ──
              // ✅ Значения key = то что приходит от API в StudentModel.status
              // Уточни точные значения из своего API если нужно
              _FilterDropdown(
                hint: 'Статус',
                value: selectedStatus,
                items: const {
                  'active': 'Активен',
                  'inactive': 'Не активен',
                  'debtor': 'Должник',
                  'trial': 'Пробный',
                },
                onChanged: onStatusChanged,
                isActive: selectedStatus != null,
                activeLabel: selectedStatus != null
                    ? 'Статус: ${_statusLabel(selectedStatus!)}'
                    : null,
              ),

              const Spacer(),

              // ── Сбросить ──
              if (hasFilters)
                TextButton(
                  onPressed: onReset,
                  child: Text(
                    'Сбросить все',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Маппинг API статуса → русское название
  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Активен';
      case 'inactive':
        return 'Не активен';
      case 'debtor':
        return 'Должник';
      case 'trial':
        return 'Пробный';
      default:
        return status;
    }
  }
}

class _FilterDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;
  final bool isActive;
  final String? activeLabel;

  const _FilterDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isActive = false,
    this.activeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFED6A2E).withOpacity(0.08)
            : Colors.transparent,
        border: Border.all(
          color: isActive
              ? const Color(0xFFED6A2E)
              : Colors.grey.withOpacity(0.25),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.containsKey(value) ? value : null,
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activeLabel ?? hint,
                style: TextStyle(
                  fontSize: 13,
                  color: isActive
                      ? const Color(0xFFED6A2E)
                      : Colors.black87,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => onChanged(null),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Color(0xFFED6A2E),
                  ),
                ),
              ],
            ],
          ),
          icon: isActive
              ? const SizedBox()
              : Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.grey[600],
                ),
          items: items.entries
              .map(
                (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(
                    e.value,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}