import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

enum SmsCategory { newUsers, debtors, dueSoon, allUser}

enum SmsSendType { group, manual }

class SmsNewUsersPage extends StatefulWidget {
  const SmsNewUsersPage({super.key});

  @override
  State<SmsNewUsersPage> createState() => _SmsNewUsersPageState();
}

class _SmsNewUsersPageState extends State<SmsNewUsersPage> {
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  SmsSendType sendType = SmsSendType.group;
  SmsCategory selectedCategory = SmsCategory.newUsers;

  @override
  void dispose() {
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  String getCategoryTitle(SmsCategory category) {
    switch (category) {
      case SmsCategory.newUsers:
        return "Новые пользователи";
      case SmsCategory.debtors:
        return "Должники";
      case SmsCategory.dueSoon:
        return "Подходит срок оплаты";
      case SmsCategory.allUser:
        return "Все студенты";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "SMS рассылка",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        Container(
          width: 520,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TYPE: GROUP OR MANUAL
              const Text("Тип рассылки"),
              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<SmsSendType>(
                      value: SmsSendType.group,
                      groupValue: sendType,
                      title: const Text("Групповая"),
                      onChanged: (value) {
                        setState(() {
                          sendType = value!;
                          phoneController.clear();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<SmsSendType>(
                      value: SmsSendType.manual,
                      groupValue: sendType,
                      title: const Text("По номеру"),
                      onChanged: (value) {
                        setState(() {
                          sendType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// CATEGORY (ONLY FOR GROUP)
              if (sendType == SmsSendType.group) ...[
                const Text("Категория"),
                const SizedBox(height: 6),
                DropdownButtonFormField<SmsCategory>(
                  value: selectedCategory,
                  items: SmsCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(getCategoryTitle(category)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
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
              ],

              /// PHONE (ONLY FOR MANUAL)
              if (sendType == SmsSendType.manual) ...[
                const Text("Номер телефона"),
                const SizedBox(height: 6),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "+998 90 123 45 67",
                    filled: true,
                    fillColor: AppColors.bgColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              /// MESSAGE
              const Text("Текст сообщения"),
              const SizedBox(height: 6),
              TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Введите текст SMS...",
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
                    final phone = phoneController.text.trim();
                    final message = messageController.text.trim();

                    if (message.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Введите текст сообщения"),
                        ),
                      );
                      return;
                    }

                    if (sendType == SmsSendType.manual && phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Введите номер телефона")),
                      );
                      return;
                    }

                    /// TODO: подключить backend
                    /// Если групповая: sendSmsToCategory(selectedCategory)
                    /// Если вручную: sendSmsToSingle(phone)

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          sendType == SmsSendType.group
                              ? "SMS отправлено (${getCategoryTitle(selectedCategory)}) ✅"
                              : "SMS отправлено на $phone ✅",
                        ),
                      ),
                    );

                    phoneController.clear();
                    messageController.clear();
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Отправить"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 14,
                    ),
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
