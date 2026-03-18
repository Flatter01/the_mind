import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/lid_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_models.dart' show LidModel;
import 'package:srm/src/the_mind/the_mind_students/presentation/faol_lidlar/cubit/lid_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/faol_lidlar/cubit/lid_state.dart';

class FaolLidlarPage extends StatelessWidget {
  const FaolLidlarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LidCubit(LidApiService())..getLeads(),
      child: const _FaolLidlarView(),
    );
  }
}

class _FaolLidlarView extends StatefulWidget {
  const _FaolLidlarView();

  @override
  State<_FaolLidlarView> createState() => _FaolLidlarViewState();
}

class _FaolLidlarViewState extends State<_FaolLidlarView> {
  String _search = '';

  static const _orange = Color(0xFFED6A2E);

  static const List<String> _allStatuses = [
    'Лиды',
    'В ожидании',
    'Пришёл',
    'Не пришёл',
    'Позвонить',
    'Не ответил',
  ];

  // Группируем лиды по статусу
  Map<String, List<LidModel>> _groupByStatus(List<LidModel> leads) {
    final Map<String, List<LidModel>> result = {
      for (final s in _allStatuses) s: [],
    };
    for (final lead in leads) {
      final display = lead.statusDisplay;
      if (result.containsKey(display)) {
        result[display]!.add(lead);
      } else {
        result['Лиды']!.add(lead);
      }
    }
    return result;
  }

  List<LidModel> _filter(List<LidModel> list) {
    if (_search.isEmpty) return list;
    return list.where((e) =>
        e.firstName.toLowerCase().contains(_search.toLowerCase()) ||
        (e.phone ?? '').contains(_search)).toList();
  }

  Color _columnColor(String status) {
    switch (status) {
      case 'Пришёл':      return const Color(0xFF2ECC8A);
      case 'Не пришёл':   return const Color(0xFFED6A2E);
      case 'Позвонить':   return const Color(0xFF6B7FD4);
      case 'Не ответил':  return const Color(0xFF8A9BB8);
      default:            return const Color(0xFF1A2233);
    }
  }

  // ── Диалог смены статуса ──────────────────────────────────────────────────

  void _showStatusPicker(LidModel lead) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Сменить статус'),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _allStatuses.map((status) {
              final isCurrent = status == lead.statusDisplay;
              return ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: isCurrent ? _orange.withOpacity(0.1) : null,
                title: Text(status),
                trailing: isCurrent
                    ? const Icon(Icons.check, color: _orange)
                    : null,
                onTap: () {
                  if (lead.id != null) {
                    context.read<LidCubit>().changeStatus(
                          id: lead.id!,
                          statusDisplay: status,
                          onSuccess: () {
                            Navigator.pop(context);
                          },
                        );
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ── Диалог редактирования / добавления ───────────────────────────────────

  void _openEditDialog({LidModel? lead}) {
    final firstNameCtrl =
        TextEditingController(text: lead?.firstName ?? '');
    final phoneCtrl = TextEditingController(text: lead?.phone ?? '');
    final commentCtrl = TextEditingController(text: lead?.comment ?? '');

    String? source = lead?.source;
    String? gender = lead?.gender;
    String status = lead?.status ?? 'new';

    final sources = ['instagram', 'telegram', 'call', 'friends', 'ads', 'other'];
    final genders = ['male', 'female'];
    final statuses = {
      'new': 'Лиды',
      'waiting': 'В ожидании',
      'came': 'Пришёл',
      'not_came': 'Не пришёл',
      'call': 'Позвонить',
      'no_answer': 'Не ответил',
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 32),
          child: SizedBox(
            width: 480,
            child: StatefulBuilder(
              builder: (ctx, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 16, 18),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.12)),
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
                            child: const Icon(Icons.person_add_outlined,
                                color: _orange, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            lead == null ? 'Новый лид' : 'Редактировать лид',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A2233),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: Icon(Icons.close,
                                color: Colors.grey[400], size: 18),
                          ),
                        ],
                      ),
                    ),

                    // Body
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Имя + Телефон
                            Row(
                              children: [
                                Expanded(
                                  child: _dialogField(
                                    ctrl: firstNameCtrl,
                                    label: 'Имя',
                                    icon: Icons.person_outline,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _dialogField(
                                    ctrl: phoneCtrl,
                                    label: 'Телефон',
                                    icon: Icons.phone_outlined,
                                    keyboard: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Источник + Пол
                            Row(
                              children: [
                                Expanded(
                                  child: _dialogDropdown(
                                    label: 'Источник',
                                    value: source,
                                    items: sources,
                                    onChanged: (v) =>
                                        setDialogState(() => source = v),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _dialogDropdown(
                                    label: 'Пол',
                                    value: gender,
                                    items: genders,
                                    labels: {
                                      'male': 'Мужской',
                                      'female': 'Женский',
                                    },
                                    onChanged: (v) =>
                                        setDialogState(() => gender = v),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Статус
                            _dialogDropdown(
                              label: 'Статус',
                              value: status,
                              items: statuses.keys.toList(),
                              labels: statuses,
                              onChanged: (v) =>
                                  setDialogState(() => status = v ?? 'new'),
                            ),
                            const SizedBox(height: 14),

                            // Комментарий
                            TextFormField(
                              controller: commentCtrl,
                              maxLines: 3,
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF1A2233)),
                              decoration: InputDecoration(
                                labelText: 'Комментарий',
                                labelStyle: TextStyle(
                                    fontSize: 13, color: Colors.grey[500]),
                                filled: true,
                                fillColor: const Color(0xFFF7F8FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.2)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.2)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: _orange, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Footer
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Colors.grey.withOpacity(0.12)),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text('Отмена',
                                style: TextStyle(color: Colors.grey[500])),
                          ),
                          const SizedBox(width: 10),
                          BlocBuilder<LidCubit, LidState>(
                            builder: (context, state) {
                              final isLoading = state is LidCreating ||
                                  state is LidUpdating;
                              return GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                        if (lead == null) {
                                          // Создать
                                          await context
                                              .read<LidCubit>()
                                              .createLead(
                                                firstName: firstNameCtrl.text
                                                    .trim(),
                                                phone: phoneCtrl.text.trim(),
                                                status: status,
                                                source: source,
                                                comment: commentCtrl.text
                                                    .trim(),
                                              );
                                        } else {
                                          await context
                                              .read<LidCubit>()
                                              .updateLead(
                                                id: lead.id!,
                                                firstName: firstNameCtrl.text
                                                    .trim(),
                                                phone: phoneCtrl.text.trim(),
                                                source: source,
                                                gender: gender,
                                                comment: commentCtrl.text
                                                    .trim(),
                                                statusDisplay: status,
                                              );
                                        }
                                        if (dialogContext.mounted) {
                                          Navigator.pop(dialogContext);
                                        }
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isLoading
                                        ? _orange.withOpacity(0.6)
                                        : _orange,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _orange.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          lead == null
                                              ? 'Добавить'
                                              : 'Сохранить',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocListener<LidCubit, LidState>(
        listener: (context, state) {
          if (state is LidError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поиск + кнопка добавить
              Row(
                children: [
                  // Поиск
                  SizedBox(
                    width: 320,
                    height: 44,
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        hintText: 'Поиск по имени или телефону...',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search,
                            size: 18, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: _orange, width: 1.5),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Кнопка обновить
                  IconButton(
                    onPressed: () =>
                        context.read<LidCubit>().getLeads(),
                    icon: const Icon(Icons.refresh, color: _orange),
                    tooltip: 'Обновить',
                  ),
                  const SizedBox(width: 8),
                  // Добавить
                  ElevatedButton.icon(
                    onPressed: () => _openEditDialog(),
                    icon: const Icon(Icons.add,
                        color: Colors.white, size: 17),
                    label: const Text(
                      'Добавить лид',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Канбан
              Expanded(
                child: BlocBuilder<LidCubit, LidState>(
                  builder: (context, state) {
                    if (state is LidLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: _orange),
                      );
                    }

                    final leads = state is LidLoaded ? state.leads : <LidModel>[];
                    final grouped = _groupByStatus(leads);

                    return ScrollConfiguration(
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
                          children: grouped.entries.map((entry) {
                            final status = entry.key;
                            final data = _filter(entry.value);

                            return Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: _KanbanColumn(
                                status: status,
                                data: data,
                                titleColor: _columnColor(status),
                                onStatusTap: _showStatusPicker,
                                onEditTap: (lead) =>
                                    _openEditDialog(lead: lead),
                                onDeleteTap: (lead) {
                                  if (lead.id != null) {
                                    context
                                        .read<LidCubit>()
                                        .deleteLead(lead.id!);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Хелперы диалога ───────────────────────────────────────────────────────

  Widget _dialogField({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey[500]),
        prefixIcon: Icon(icon, size: 17, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _dialogDropdown({
    required String label,
    required String? value,
    required List<String> items,
    Map<String, String>? labels,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      style: const TextStyle(fontSize: 13, color: Color(0xFF1A2233)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(labels?[e] ?? e),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

// ─── Канбан колонка ───────────────────────────────────────────────────────────

class _KanbanColumn extends StatelessWidget {
  final String status;
  final List<LidModel> data;
  final Color titleColor;
  final void Function(LidModel) onStatusTap;
  final void Function(LidModel) onEditTap;
  final void Function(LidModel) onDeleteTap;

  const _KanbanColumn({
    required this.status,
    required this.data,
    required this.titleColor,
    required this.onStatusTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок колонки
          Padding(
            padding: const EdgeInsets.only(bottom: 14, left: 2),
            child: Row(
              children: [
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
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

          // Карточки
          Expanded(
            child: data.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.15),
                          style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Text(
                        'Пусто',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[400]),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) => _LidCard(
                      lead: data[i],
                      onStatusTap: () => onStatusTap(data[i]),
                      onEditTap: () => onEditTap(data[i]),
                      onDeleteTap: () => onDeleteTap(data[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Карточка лида ────────────────────────────────────────────────────────────

class _LidCard extends StatelessWidget {
  final LidModel lead;
  final VoidCallback onStatusTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const _LidCard({
    required this.lead,
    required this.onStatusTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  static const _orange = Color(0xFFED6A2E);

  String get _initials {
    final parts = lead.firstName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
  }

  bool get _isNew => lead.status == 'new';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: lead.status == 'not_came'
            ? const Border(
                left: BorderSide(color: _orange, width: 3),
              )
            : Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
                  lead.firstName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isNew)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'НОВЫЙ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                CircleAvatar(
                  radius: 14,
                  backgroundColor: _orange.withOpacity(0.15),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: _orange,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Телефон
          if (lead.phone != null)
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 12, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Text(
                  lead.phone!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),

          // Источник
          if (lead.source != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.public_outlined, size: 12, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Text(
                  lead.source!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],

          // Комментарий
          if (lead.comment != null && lead.comment!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.comment_outlined,
                    size: 12, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    lead.comment!,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 10),

          // Кнопки
          Row(
            children: [
              // Статус
              GestureDetector(
                onTap: onStatusTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: _orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    lead.statusDisplay,
                    style: const TextStyle(
                      color: _orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Edit
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.25)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined,
                          size: 11, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Изменить',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Delete
              GestureDetector(
                onTap: onDeleteTap,
                child: Icon(Icons.delete_outline,
                    size: 16, color: Colors.grey[300]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}