import 'package:flutter/material.dart';

const _orange = Color(0xFFED6A2E);
const _bg = Color(0xFFF7F8FA);
const _border = Color(0xFFE8EAF0);
const _text = Color(0xFF1A1F36);
const _grey = Color(0xFF8A94A6);

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  DateTime? _deadline;
  String _priority = 'medium';
  bool _isLoading = false;

  static const _priorities = {
    'low': {'label': 'Низкий', 'color': Color(0xFF2ECC8A)},
    'medium': {'label': 'Средний', 'color': Color(0xFFED6A2E)},
    'high': {'label': 'Высокий', 'color': Color(0xFFE53E3E)},
  };

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _descCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _orange),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.of(context).pop({
      'title': _titleCtrl.text,
      'from': _fromCtrl.text,
      'to': _toCtrl.text,
      'deadline': _deadline?.toIso8601String(),
      'description': _descCtrl.text,
      'priority': _priority,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      elevation: 0,
      child: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Container(
                padding: const EdgeInsets.fromLTRB(28, 24, 16, 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: _border),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.task_alt_rounded,
                        color: _orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Новая задача',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _text,
                          ),
                        ),
                        Text(
                          'Заполните данные задачи',
                          style: TextStyle(fontSize: 12, color: _grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close,
                          color: Colors.grey[400], size: 20),
                    ),
                  ],
                ),
              ),

              // ── Body ──
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Название задачи
                      _label('НАЗВАНИЕ ЗАДАЧИ'),
                      const SizedBox(height: 8),
                      _buildField(
                        ctrl: _titleCtrl,
                        hint: 'Введите название...',
                        icon: Icons.title_rounded,
                        validator: (v) =>
                            v!.isEmpty ? 'Введите название' : null,
                      ),
                      const SizedBox(height: 20),

                      // От кого / Для кого
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('ОТ КОГО'),
                                const SizedBox(height: 8),
                                _buildField(
                                  ctrl: _fromCtrl,
                                  hint: 'Имя отправителя',
                                  icon: Icons.person_outline_rounded,
                                  validator: (v) =>
                                      v!.isEmpty ? 'Введите имя' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('ДЛЯ КОГО'),
                                const SizedBox(height: 8),
                                _buildField(
                                  ctrl: _toCtrl,
                                  hint: 'Имя исполнителя',
                                  icon: Icons.person_add_outlined,
                                  validator: (v) =>
                                      v!.isEmpty ? 'Введите имя' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Приоритет
                      _label('ПРИОРИТЕТ'),
                      const SizedBox(height: 10),
                      Row(
                        children: _priorities.entries.map((e) {
                          final isActive = _priority == e.key;
                          final color = e.value['color'] as Color;
                          final label = e.value['label'] as String;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _priority = e.key),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 150),
                                margin: EdgeInsets.only(
                                  right: e.key != 'high' ? 10 : 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? color.withOpacity(0.1)
                                      : _bg,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isActive ? color : _border,
                                    width: isActive ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isActive ? color : _grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Дедлайн
                      _label('ДЕДЛАЙН'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDeadline,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14),
                          decoration: BoxDecoration(
                            color: _deadline != null
                                ? _orange.withOpacity(0.05)
                                : _bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _deadline != null
                                  ? _orange.withOpacity(0.4)
                                  : _border,
                              width: _deadline != null ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color:
                                    _deadline != null ? _orange : _grey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _deadline == null
                                    ? 'Выберите дату...'
                                    : '${_deadline!.day.toString().padLeft(2, '0')}.${_deadline!.month.toString().padLeft(2, '0')}.${_deadline!.year}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: _deadline != null
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: _deadline != null
                                      ? _orange
                                      : _grey,
                                ),
                              ),
                              const Spacer(),
                              if (_deadline != null)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _deadline = null),
                                  child: const Icon(Icons.close,
                                      size: 14, color: _orange),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Валидация дедлайна
                      if (_deadline == null && _formKey.currentState != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            'Выберите дату',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red[400],
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Описание
                      _label('ОПИСАНИЕ'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 13, color: _text),
                        decoration: InputDecoration(
                          hintText: 'Опишите задачу подробнее...',
                          hintStyle: const TextStyle(
                              fontSize: 13, color: _grey),
                          filled: true,
                          fillColor: _bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: _orange, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Введите описание' : null,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Footer ──
              Container(
                padding:
                    const EdgeInsets.fromLTRB(28, 16, 28, 24),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: _border)),
                ),
                child: Row(
                  children: [
                    // Индикатор приоритета
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: (_priorities[_priority]!['color']
                                as Color)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _priorities[_priority]!['color']
                                  as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _priorities[_priority]!['label'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _priorities[_priority]!['color']
                                  as Color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(color: _grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _isLoading ? null : _submit,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 13),
                        decoration: BoxDecoration(
                          color: _isLoading
                              ? _orange.withOpacity(0.6)
                              : _orange,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _orange.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check,
                                      size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Создать задачу',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _grey,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 13, color: _text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: _grey),
        prefixIcon: Icon(icon, size: 17, color: _grey),
        filled: true,
        fillColor: _bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
      validator: validator,
    );
  }
}