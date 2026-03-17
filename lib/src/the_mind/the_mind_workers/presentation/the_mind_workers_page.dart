import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_workers/data/admin_api_service.dart';
import 'package:srm/src/the_mind/the_mind_workers/data/models/admin_model.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/cubit/admin_cubit.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/cubit/admin_state.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/the_mind_workes_profile.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/widgets/add_worker_dialog.dart';

class TheMindWorkersPage extends StatelessWidget {
  const TheMindWorkersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(AdminApiService())..getAdmins(),
      child: const _WorkersView(),
    );
  }
}

class _WorkersView extends StatefulWidget {
  const _WorkersView();

  @override
  State<_WorkersView> createState() => _WorkersViewState();
}

class _WorkersViewState extends State<_WorkersView> {
  String _search = '';
  String _roleFilter = 'Все';
  String _sortBy = 'По алфавиту';

  static const _orange = Color(0xFFED6A2E);

  // Маппинг API роли → русское название для фильтра
  static const _roleMap = {
    'SUPERADMIN': 'Super Admin',
    'ADMIN': 'Администратор',
    'TEACHER': 'Учитель',
  };

  List<AdminModel> _filtered(List<AdminModel> admins) {
    var list = admins.where((a) {
      final q = _search.toLowerCase();
      final matchSearch =
          _search.isEmpty ||
          a.fullName.toLowerCase().contains(q) ||
          (a.phoneNumber ?? '').contains(q);

      final matchRole =
          _roleFilter == 'Все' ||
          (_roleFilter == 'Super Admin' && a.role == 'SUPERADMIN') ||
          (_roleFilter == 'Администратор' && a.role == 'ADMIN') ||
          (_roleFilter == 'Учитель' && a.role == 'TEACHER');

      return matchSearch && matchRole;
    }).toList();

    if (_sortBy == 'По алфавиту') {
      list.sort((a, b) => a.fullName.compareTo(b.fullName));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminError) {
          print(state.message);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5F7),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Заголовок ──
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Сотрудники',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Управление командой и правами доступа',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _openAddDialog(context),
                    icon: const Icon(
                      Icons.person_add_outlined,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: const Text(
                      'Добавить сотрудника',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Поиск + фильтры ──
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        decoration: InputDecoration(
                          hintText: 'Поиск по имени, фамилии или телефону...',
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Фильтр-чипы
                  ...['Все', 'Super Admin', 'Администратор', 'Учитель'].map((
                    item,
                  ) {
                    final isActive = _roleFilter == item;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _roleFilter = item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? _orange : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? _orange
                                  : Colors.grey.withOpacity(0.2),
                            ),
                            boxShadow: isActive
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 4,
                                    ),
                                  ],
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 12),

              // ── Сортировка ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Сортировать:',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _sortBy,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Грид ──
              Expanded(
                child: BlocBuilder<AdminCubit, AdminState>(
                  builder: (context, state) {
                    if (state is AdminLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: _orange),
                      );
                    }

                    if (state is AdminError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<AdminCubit>().getAdmins(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _orange,
                              ),
                              child: const Text(
                                'Повторить',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is AdminLoaded) {
                      final filtered = _filtered(state.admins);

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.55,
                            ),
                        itemCount: filtered.length + 1,
                        itemBuilder: (_, i) {
                          if (i == filtered.length) {
                            return _addNewCard(context);
                          }
                          return _workerCard(context, filtered[i]);
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Карточка сотрудника ───────────────────────────────────────────────────

  Widget _workerCard(BuildContext context, AdminModel admin) {
    final roleColor = _getRoleColor(admin.role);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Аватар + имя + статус
          Row(
            children: [
              _avatar(admin),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Статус
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: admin.isActive
                                ? const Color(0xFF2ECC8A)
                                : Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          admin.isActive ? 'Активен' : 'Не активен',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: admin.isActive
                                ? const Color(0xFF2ECC8A)
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      admin.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      admin.roleDisplay,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: roleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Телефон
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14,
                color: admin.isActive ? Colors.grey[500] : Colors.grey[350],
              ),
              const SizedBox(width: 6),
              Text(
                admin.phoneNumber ?? '—',
                style: TextStyle(
                  fontSize: 12,
                  color: admin.isActive ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ID (вместо email)
          Row(
            children: [
              Icon(
                Icons.fingerprint,
                size: 14,
                color: admin.isActive ? Colors.grey[500] : Colors.grey[350],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  admin.id.length > 8
                      ? '${admin.id.substring(0, 8)}...'
                      : admin.id,
                  style: TextStyle(
                    fontSize: 12,
                    color: admin.isActive ? Colors.grey[600] : Colors.grey[400],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Кнопки
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TheMindWorkesProfile()),
                    );
                  },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F5F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Профиль',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F5F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Color(0xFFED6A2E),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Удалить',
                            style: TextStyle(color: Color(0xFFED6A2E)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'delete') {
                      _confirmDelete(context, admin);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Аватар ────────────────────────────────────────────────────────────────

  Widget _avatar(AdminModel admin) {
    final color = _getRoleColor(admin.role);
    final effectiveColor = admin.isActive ? color : Colors.grey[400]!;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          admin.initials,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: effectiveColor,
          ),
        ),
      ),
    );
  }

  // ── Карточка "Новый сотрудник" ────────────────────────────────────────────

  Widget _addNewCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _openAddDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, size: 22, color: Color(0xFF8A9BB8)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Новый сотрудник',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8A9BB8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Диалог добавления ─────────────────────────────────────────────────────

  void _openAddDialog(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    showDialog(
      context: context,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const AddWorkerDialog()),
    );
  }

  // ── Подтверждение удаления ────────────────────────────────────────────────

  void _confirmDelete(BuildContext context, AdminModel admin) {
    final cubit = context.read<AdminCubit>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Удалить сотрудника?'),
        content: Text('Вы уверены что хотите удалить ${admin.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteAdmin(admin.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Хелперы ───────────────────────────────────────────────────────────────

  Color _getRoleColor(String role) {
    switch (role) {
      case 'SUPERADMIN':
        return const Color(0xFFED6A2E);
      case 'ADMIN':
        return const Color(0xFF6B7FD4);
      case 'TEACHER':
        return const Color(0xFF2ECC8A);
      default:
        return const Color(0xFF8A9BB8);
    }
  }
}
