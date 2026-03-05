import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class SmsActiveUsersPage extends StatefulWidget {
  const SmsActiveUsersPage({super.key});

  @override
  State<SmsActiveUsersPage> createState() => _SmsActiveUsersPageState();
}

class _SmsActiveUsersPageState extends State<SmsActiveUsersPage> {
  final messageController = TextEditingController();

  String selectedGroup = "Все активные";

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "SMS активным пользователям",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        Container(
          width: 560,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Выбор группы
              const Text("Кому отправить"),
              const SizedBox(height: 6),

              DropdownButtonFormField<String>(
                value: selectedGroup,
                items: const [
                  DropdownMenuItem(value: "Все активные", child: Text("Все активные")),
                  DropdownMenuItem(value: "Активные сегодня", child: Text("Активные сегодня")),
                  DropdownMenuItem(value: "С оплатой", child: Text("С оплатой")),
                  DropdownMenuItem(value: "Без оплаты", child: Text("Без оплаты")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value!;
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

              const SizedBox(height: 16),

              /// Текст сообщения
              const Text("Текст сообщения"),
              const SizedBox(height: 6),

              TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Введите сообщение для активных пользователей...",
                  filled: true,
                  fillColor: AppColors.bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final message = messageController.text.trim();

                    if (message.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Введите текст сообщения")),
                      );
                      return;
                    }

                    /// TODO: массовая отправка активным

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("SMS отправлено: $selectedGroup ✅"),
                      ),
                    );

                    messageController.clear();
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Отправить"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
