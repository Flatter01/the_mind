import 'package:flutter/material.dart';

const _orange = Color(0xFFED6A2E);
const _bg = Color(0xFFF7F8FA);
const _border = Color(0xFFE8EAF0);
const _text = Color(0xFF1A1F36);
const _grey = Color(0xFF8A94A6);

class AddStudentDialog extends StatefulWidget {
  final List<String> courses;
  final List<String> groups;
  final List<String> branches;

  const AddStudentDialog({
    super.key,
    required this.courses,
    required this.groups,
    required this.branches,
  });

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String? _selectedBranch;
  String? _selectedGroup;
  String? _selectedCourse;
  String _gender = 'male';
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pop(context, {
      'firstName': _firstNameCtrl.text.trim(),
      'lastName': _lastNameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'branch': _selectedBranch,
      'group': _selectedGroup,
      'course': _selectedCourse,
      'gender': _gender,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                  border:
                      Border(bottom: BorderSide(color: _border)),
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
                        Icons.person_add_outlined,
                        color: _orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Добавить студента',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _text,
                          ),
                        ),
                        Text(
                          'Заполните данные студента',
                          style:
                              TextStyle(fontSize: 12, color: _grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
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
                      // Имя + Фамилия
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('ИМЯ'),
                                const SizedBox(height: 8),
                                _buildField(
                                  ctrl: _firstNameCtrl,
                                  hint: 'Введите имя',
                                  icon: Icons.person_outline,
                                  validator: (v) => v!.isEmpty
                                      ? 'Введите имя'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('ФАМИЛИЯ'),
                                const SizedBox(height: 8),
                                _buildField(
                                  ctrl: _lastNameCtrl,
                                  hint: 'Введите фамилию',
                                  icon: Icons.person_outline,
                                  validator: (v) => v!.isEmpty
                                      ? 'Введите фамилию'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Телефон
                      _label('НОМЕР ТЕЛЕФОНА'),
                      const SizedBox(height: 8),
                      _buildField(
                        ctrl: _phoneCtrl,
                        hint: '+998 XX XXX XX XX',
                        icon: Icons.phone_outlined,
                        keyboard: TextInputType.phone,
                        validator: (v) {
                          if (v!.isEmpty) return 'Введите номер';
                          if (v.length < 7) return 'Слишком короткий';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Пол
                      _label('ПОЛ'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _genderBtn('male', 'Мужской',
                              Icons.male_rounded),
                          const SizedBox(width: 12),
                          _genderBtn('female', 'Женский',
                              Icons.female_rounded),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Филиал + Группа
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('ФИЛИАЛ'),
                                const SizedBox(height: 8),
                                _buildDropdown(
                                  hint: 'Выберите филиал',
                                  value: _selectedBranch,
                                  items: {
                                    for (final b in widget.branches)
                                      b: b
                                  },
                                  onChanged: (v) => setState(
                                      () => _selectedBranch = v),
                                  validator: (v) => v == null
                                      ? 'Выберите филиал'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _label('ГРУППА'),
                                const SizedBox(height: 8),
                                _buildDropdown(
                                  hint: 'Выберите группу',
                                  value: _selectedGroup,
                                  items: {
                                    for (final g in widget.groups)
                                      g: g
                                  },
                                  onChanged: (v) => setState(
                                      () => _selectedGroup = v),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  border:
                      Border(top: BorderSide(color: _border)),
                ),
                child: Row(
                  children: [
                    // Превью имени
                    if (_firstNameCtrl.text.isNotEmpty ||
                        _lastNameCtrl.text.isNotEmpty)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                _orange.withOpacity(0.15),
                            child: Text(
                              _firstNameCtrl.text.isNotEmpty
                                  ? _firstNameCtrl.text[0]
                                      .toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_firstNameCtrl.text} ${_lastNameCtrl.text}'
                                .trim(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _text,
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox(),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Отмена',
                        style:
                            TextStyle(color: _grey, fontSize: 14),
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
                                  Icon(Icons.person_add_outlined,
                                      size: 16,
                                      color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Добавить',
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

  // ── Кнопка пола ──────────────────────────────────────────────────────────

  Widget _genderBtn(String value, String label, IconData icon) {
    final isActive = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? _orange.withOpacity(0.08) : _bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? _orange : _border,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isActive ? _orange : _grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? _orange : _grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Хелперы ───────────────────────────────────────────────────────────────

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
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      onChanged: (_) => setState(() {}),
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
          borderSide:
              const BorderSide(color: _orange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 13),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: items.containsKey(value) ? value : null,
      style: const TextStyle(fontSize: 13, color: _text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: _grey),
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
          borderSide:
              const BorderSide(color: _orange, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 13),
      ),
      icon: Icon(Icons.keyboard_arrow_down,
          size: 18, color: Colors.grey[500]),
      items: items.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value,
                  style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}