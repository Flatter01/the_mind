import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final task = {
        'from': _fromController.text,
        'to': _toController.text,
        'deadline': _deadline?.toIso8601String(),
        'description': _descriptionController.text,
      };
      print("Новая задача: $task"); // Тут можно добавить сохранение в список или базу
      Navigator.of(context).pop(); // Закрываем диалог
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Добавить задачу"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fromController,
                decoration: const InputDecoration(labelText: "От кого"),
                validator: (value) => value!.isEmpty ? "Введите имя" : null,
              ),
              TextFormField(
                controller: _toController,
                decoration: const InputDecoration(labelText: "Для кого"),
                validator: (value) => value!.isEmpty ? "Введите имя" : null,
              ),
              GestureDetector(
                onTap: _pickDeadline,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Дедлайн",
                      hintText: _deadline != null
                          ? "${_deadline!.day}-${_deadline!.month}-${_deadline!.year}"
                          : "Выберите дату",
                    ),
                    validator: (value) =>
                        _deadline == null ? "Выберите дату" : null,
                  ),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Описание"),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? "Введите описание" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Отмена"),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Сохранить"),
        ),
      ],
    );
  }
}

// Пример использования showMenu и диалога
void _openTask(BuildContext context, TapDownDetails details) async {
  final selected = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx,
      details.globalPosition.dy,
      0,
      0,
    ),
    items: const [
      PopupMenuItem(
        value: 'add',
        child: Row(
          children: [
            Icon(Icons.add, size: 18),
            SizedBox(width: 8),
            Text("Добавить участника"),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'task',
        child: Row(
          children: [
            Icon(Icons.task, size: 18),
            SizedBox(width: 8),
            Text("Добавить задачу"),
          ],
        ),
      ),
    ],
  );

  if (selected == 'add' || selected == 'task') {
    await showDialog(
      context: context,
      builder: (_) {
        return const AddTask();
      },
    );
  }
}
