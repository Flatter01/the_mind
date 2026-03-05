import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class AssignRolePage extends StatefulWidget {
  const AssignRolePage({super.key});

  @override
  State<AssignRolePage> createState() => _AssignRolePageState();
}

class _AssignRolePageState extends State<AssignRolePage> {
  String selectedRole = "Студент";
  String search = "";

  final List<String> roles = [
    "Студент",
    "Учитель",
    "Менеджер",
    "Админ",
  ];

  final List<_UserModel> users = [
    _UserModel("Ali Karimov", "+998 90 123 45 67", "Студент"),
    _UserModel("Madina Rasulova", "+998 93 222 11 33", "Учитель"),
    _UserModel("Jasur Akramov", "+998 99 777 88 66", "Студент"),
    _UserModel("Umida Tursunova", "+998 97 555 44 22", "Менеджер"),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((u) {
      return u.name.toLowerCase().contains(search.toLowerCase()) ||
          u.phone.contains(search);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Назначение роли",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        /// Панель управления
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => search = v),
                  decoration: InputDecoration(
                    hintText: "Поиск по имени или номеру",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.bgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: roles
                      .map((r) =>
                          DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// Таблица пользователей
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.separated(
              itemCount: filteredUsers.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Colors.black12),
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return _UserRow(
                  user: user,
                  selectedRole: selectedRole,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
class _UserRow extends StatelessWidget {
  final _UserModel user;
  final String selectedRole;

  const _UserRow({
    required this.user,
    required this.selectedRole,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 2, child: Text(user.phone)),
          Expanded(flex: 2, child: Text(user.role)),

          const SizedBox(width: 10),

          ElevatedButton(
            onPressed: () {
              /// TODO: сохранить роль в backend / Firebase

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Роль '$selectedRole' назначена: ${user.name}"),
                ),
              );
            },
            child: const Text("Назначить"),
          ),
        ],
      ),
    );
  }
}
class _UserModel {
  final String name;
  final String phone;
  String role;

  _UserModel(this.name, this.phone, this.role);
}
