import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class CreateRolePage extends StatefulWidget {
  const CreateRolePage({super.key});

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateRolePage> {
  final roleNameController = TextEditingController();

  final Map<String, Map<String, bool>> permissions = {
    "Students": {
      "Просмотр списка": true,
      "Редактирование": false,
      "Отметка посещаемости": false,
      "Удаление": false,
    },
    "Group": {
      "Просмотр групп": true,
      "Редактирование групп": false,
    },
    "Exam": {
      "Просмотр экзаменов": false,
      "Создание экзамена": false,
    },
    "Teacher": {
      "Просмотр учителей": true,
      "Редактирование учителей": false,
    },
    "Salary": {
      "Просмотр ЗП": true,
      "Редактирование ЗП": false,
    },
    "Profile": {
      "Просмотр профиля": true,
      "Редактирование профиля": false,
    },
  };

  final Map<String, bool> expandedPages = {};

  @override
  void initState() {
    super.initState();
    permissions.keys.forEach((key) => expandedPages[key] = false);
  }

  @override
  void dispose() {
    roleNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название роли
            const Text(
              "Название роли",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: roleNameController,
              decoration: InputDecoration(
                hintText: "Например: Менеджер, Учитель, Админ...",
                filled: true,
                fillColor: AppColors.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),

            const Text(
              "Права доступа",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ...permissions.keys.map((page) {
              final pagePermissions = permissions[page]!;

              return Card(
                color: AppColors.cardColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  key: PageStorageKey(page),
                  initiallyExpanded: expandedPages[page]!,
                  onExpansionChanged: (val) {
                    setState(() {
                      expandedPages[page] = val;
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.folder,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        page,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  children: pagePermissions.keys.map((perm) {
                    return SwitchListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      activeColor: AppColors.textPrimary,
                      title: Text(
                        perm,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      value: pagePermissions[perm]!,
                      onChanged: (value) {
                        setState(() {
                          pagePermissions[perm] = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _createRole,
                icon: const Icon(Icons.security),
                label: const Text("Создать роль"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createRole() {
    final roleName = roleNameController.text.trim();

    if (roleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите название роли")),
      );
      return;
    }

    final Map<String, List<String>> selectedPermissions = {};
    permissions.forEach((page, perms) {
      final enabled = perms.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      if (enabled.isNotEmpty) selectedPermissions[page] = enabled;
    });

    debugPrint("РОЛЬ: $roleName");
    debugPrint("ПРАВА: $selectedPermissions");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Роль успешно создана ✅")),
    );

    roleNameController.clear();
  }
}
