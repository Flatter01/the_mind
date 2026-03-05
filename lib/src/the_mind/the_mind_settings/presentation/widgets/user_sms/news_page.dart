import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final titleController = TextEditingController();
  final textController = TextEditingController();

  String sendTo = "Всем";
  String selectedGroup = "Все студенты";

  final List<String> sendTypes = ["Всем", "По группе", "По роли"];

  final List<String> groups = [
    "Все студенты",
    "Flutter 1",
    "Flutter 2",
    "Backend",
  ];

  final List<String> roles = [
    "Студент",
    "Учитель",
    "Менеджер",
  ];

  String selectedRole = "Студент";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Страница новостей",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        AppCard(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Заголовок
              _label("Заголовок"),
              _field("Например: Новый модуль доступен", titleController),

              const SizedBox(height: 14),

              /// Текст
              _label("Текст новости"),
              TextField(
                controller: textController,
                maxLines: 6,
                decoration: _dec("Введите текст новости..."),
              ),

              const SizedBox(height: 20),

              /// Кому отправить
              _label("Кому отправить"),

              Row(
                children: [
                  _select(sendTypes, sendTo, (v) {
                    setState(() => sendTo = v);
                  }),

                  const SizedBox(width: 14),

                  if (sendTo == "По группе")
                    _select(groups, selectedGroup, (v) {
                      setState(() => selectedGroup = v);
                    }),

                  if (sendTo == "По роли")
                    _select(roles, selectedRole, (v) {
                      setState(() => selectedRole = v);
                    }),
                ],
              ),

              const SizedBox(height: 26),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: publishNews,
                  icon: const Icon(Icons.campaign),
                  label: const Text("Опубликовать"),
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
          ),),
      ],
    );
  }

  void publishNews() {
    final title = titleController.text.trim();
    final text = textController.text.trim();

    if (title.isEmpty || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заполните все поля")),
      );
      return;
    }

    String target = sendTo == "Всем"
        ? "Всем пользователям"
        : sendTo == "По группе"
            ? "Группе: $selectedGroup"
            : "Роли: $selectedRole";

    /// TODO: Firebase / API / Push

    debugPrint("НОВОСТЬ: $title");
    debugPrint("ТЕКСТ: $text");
    debugPrint("КОМУ: $target");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Новость отправлена ($target) ✅")),
    );

    titleController.clear();
    textController.clear();
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child:
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  Widget _field(String hint, TextEditingController c) => TextField(
        controller: c,
        decoration: _dec(hint),
      );

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  Widget _select(
    List<String> items,
    String value,
    Function(String) onChange,
  ) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onChange(v!),
        decoration: _dec(""),
      ),
    );
  }
}
