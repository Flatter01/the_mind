import 'package:flutter/material.dart';

/// --------------------
/// МОДЕЛИ
/// --------------------
class TaskUser {
  final String id;
  final String name;

  TaskUser({required this.id, required this.name});
}

class SenderTask {
  final String title;
  final String description;
  final DateTime deadline;
  final TaskUser receiver;

  SenderTask({
    required this.title,
    required this.description,
    required this.deadline,
    required this.receiver,
  });
}

/// --------------------
/// СТРАНИЦА
/// --------------------
class SendTaskPage extends StatefulWidget {
  final Function(SenderTask task) onSend;

  const SendTaskPage({super.key, required this.onSend});

  @override
  State<SendTaskPage> createState() => _SendTaskPageState();
}

class _SendTaskPageState extends State<SendTaskPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  DateTime? _deadline;
  TaskUser? _selectedUser;

  final List<TaskUser> users = [
    TaskUser(id: '1', name: 'Aliyev Bekzod'),
    TaskUser(id: '2', name: 'Sattorova Madina'),
    TaskUser(id: '3', name: 'Karimov Jasur'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "📤 Отправить задачу",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                "Заполни данные и отправь задачу сотруднику",
                style: TextStyle(color: Colors.grey.shade600),
              ),
      
              const SizedBox(height: 24),
      
              _card(
                child: Column(
                  children: [
                    _field("Название", _titleCtrl, icon: Icons.title),
                    _field("Описание", _descCtrl,
                        icon: Icons.notes, maxLines: 3),
      
                    const SizedBox(height: 12),
      
                    DropdownButtonFormField<TaskUser>(
                      value: _selectedUser,
                      items: users.map((user) {
                        return DropdownMenuItem<TaskUser>(
                          value: user,
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: 18),
                              const SizedBox(width: 8),
                              Text(user.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedUser = value),
                      decoration: _decoration(
                        "Получатель",
                        Icons.person_outline,
                      ),
                    ),
      
                    const SizedBox(height: 14),
      
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _pickDeadline,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _deadline == null
                                    ? "Выбрать срок выполнения"
                                    : _formatDate(_deadline!),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _deadline == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
              const SizedBox(height: 22),
      
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _sendTask,
                  icon: const Icon(Icons.send),
                  label: const Text("Отправить задачу"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --------------------
  /// UI ЭЛЕМЕНТЫ
  /// --------------------
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _field(String title, TextEditingController controller,
      {int maxLines = 1, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: _decoration(title, icon),
      ),
    );
  }

  InputDecoration _decoration(String title, IconData? icon) {
    return InputDecoration(
      labelText: title,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  /// --------------------
  /// ЛОГИКА
  /// --------------------
  Future<void> _pickDeadline() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _deadline = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _sendTask() {
    if (_titleCtrl.text.isEmpty ||
        _descCtrl.text.isEmpty ||
        _selectedUser == null ||
        _deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заполните все поля")),
      );
      return;
    }

    widget.onSend(
      SenderTask(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        deadline: _deadline!,
        receiver: _selectedUser!,
      ),
    );

    _titleCtrl.clear();
    _descCtrl.clear();

    setState(() {
      _deadline = null;
      _selectedUser = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Задача отправлена")),
    );
  }

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}."
        "${d.month.toString().padLeft(2, '0')}."
        "${d.year}  "
        "${d.hour.toString().padLeft(2, '0')}:"
        "${d.minute.toString().padLeft(2, '0')}";
  }
}
