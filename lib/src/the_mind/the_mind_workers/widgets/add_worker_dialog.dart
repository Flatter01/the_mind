import 'package:flutter/material.dart';
import 'build_workers_table.dart';

class AddWorkerDialog extends StatefulWidget {
  final Function(BuildWorkersTableItem) onAdd;

  const AddWorkerDialog({super.key, required this.onAdd});

  @override
  State<AddWorkerDialog> createState() => _AddWorkerDialogState();
}

class _AddWorkerDialogState extends State<AddWorkerDialog> {
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _phone = TextEditingController();
  final _salary = TextEditingController();
  final _birthYear = TextEditingController();

  String _selectedRole = 'Учитель';
  bool _isActive = true;

  final List<String> _roles = ['Учитель', 'Администратор', 'Менеджер', 'Уборщик'];

  bool get _isTeacher => _selectedRole == 'Учитель';

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _phone.dispose();
    _salary.dispose();
    _birthYear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: SizedBox(
        width: 560,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Заголовок ──────────────────────────────────────────
              const Text(
                'Новый сотрудник',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1A2233)),
              ),
              const SizedBox(height: 6),
              Text(
                'Заполните данные для добавления в систему управления кадрами',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),

              const SizedBox(height: 28),

              // ── Имя + Фамилия ──────────────────────────────────────
              Row(
                children: [
                  Expanded(child: _field(controller: _name, label: 'Имя', hint: 'Иван')),
                  const SizedBox(width: 16),
                  Expanded(child: _field(controller: _surname, label: 'Фамилия', hint: 'Иванов')),
                ],
              ),

              const SizedBox(height: 16),

              // ── Год рождения + Телефон ─────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _field(
                      controller: _birthYear,
                      label: 'Год рождения',
                      hint: '1990',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                      controller: _phone,
                      label: 'Телефон',
                      hint: '+7 (000) 000-00-00',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_outlined, size: 16, color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Роль ───────────────────────────────────────────────
              _label('Роль'),
              const SizedBox(height: 6),
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233), fontWeight: FontWeight.w500),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setState(() {
                    _selectedRole = v!;
                    _salary.clear();
                  }),
                ),
              ),

              const SizedBox(height: 16),

              // ── Зарплата (кроме учителей) ──────────────────────────
              Row(
                children: [
                  _label('Зарплата'),
                  const SizedBox(width: 8),
                  Text('(кроме учителей)', style: TextStyle(fontSize: 12, color: const Color(0xFFED6A2E).withOpacity(0.8), fontStyle: FontStyle.italic)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _isTeacher ? const Color(0xFFF8F9FB).withOpacity(0.5) : const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _salary,
                        enabled: !_isTeacher,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14, color: _isTeacher ? Colors.grey[350] : const Color(0xFF1A2233)),
                        decoration: InputDecoration(
                          hintText: _isTeacher ? '—' : '50 000',
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Text('₽', style: TextStyle(fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Кнопка создать ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.person_add_outlined, color: Colors.white, size: 18),
                  label: const Text(
                    'Создать сотрудника',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED6A2E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Дисклеймер ─────────────────────────────────────────
              Center(
                child: Text(
                  'Нажимая кнопку, вы подтверждаете согласие на обработку персональных данных',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Поле ввода ────────────────────────────────────────────────────────────
  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 6),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
              prefixIcon: prefixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon == null ? 16 : 0,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2233)),
    );
  }

  void _submit() {
    widget.onAdd(
      BuildWorkersTableItem(
        name: _name.text.trim().isEmpty ? 'Новый' : _name.text.trim(),
        surname: _surname.text.trim().isEmpty ? 'Сотрудник' : _surname.text.trim(),
        role: _selectedRole,
        phone: _phone.text.trim(),
        isActive: _isActive,
        salary: !_isTeacher ? _salary.text.trim() : null,
      ),
    );
    Navigator.pop(context);
  }
}