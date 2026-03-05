import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class Task {
  final String title;
  final String description;
  final String assignedTo; // для кого задача
  final DateTime deadline;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.assignedTo, // добавляем в конструктор
    required this.deadline,
    this.isCompleted = false,
  });
}

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Task> _allTasks = [
    Task(
      title: "Сделать дизайн",
      description: "Создать макет для новой страницы приложения",
      assignedTo: "Алиса",
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      title: "Написать код",
      description: "Реализовать функционал поиска и фильтров",
      assignedTo: "Боб",
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      title: "Тестирование",
      description: "Проверить работу всех функций на баги",
      assignedTo: "Карим",
      deadline: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      title: "Загрузка данных",
      description: "Импортировать данные с сервера в базу",
      assignedTo: "Лейла",
      deadline: DateTime.now().add(const Duration(days: 4)),
    ),
    Task(
      title: "Рефакторинг",
      description: "Улучшить код и убрать дубли",
      assignedTo: "Даврон",
      deadline: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _filteredTasks = List.from(_allTasks);
    _searchController.addListener(_filterTasks);
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _allTasks
          .where((task) =>
              task.title.toLowerCase().contains(query) ||
              task.description.toLowerCase().contains(query) ||
              task.assignedTo.toLowerCase().contains(query))
          .toList();
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgColor,
      title: const Text(
        "Список задач",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Поиск
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Поиск задачи",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Список задач
            SizedBox(
              height: 340,
              child: _filteredTasks.isEmpty
                  ? const Center(
                      child: Text("Задачи не найдены"),
                    )
                  : ListView.builder(
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Описание
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Для кого
                                Text(
                                  "Для: ${task.assignedTo}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blueGrey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Статус задачи
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: task.isCompleted
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    task.isCompleted
                                        ? "Выполнено"
                                        : "В процессе",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: task.isCompleted
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Срок
                                Text(
                                  "Срок: ${_formatDate(task.deadline)}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Кнопка "Выполнено"
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: task.isCompleted
                                          ? Colors.grey
                                          : Colors.blueAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: task.isCompleted
                                        ? null
                                        : () {
                                            setState(() {
                                              task.isCompleted = true;
                                            });
                                          },
                                    child: const Text(
                                      "Выполнено",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Закрыть"),
        ),
      ],
    );
  }
}
