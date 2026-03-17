import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/cubit/admin_cubit.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/cubit/admin_state.dart';

class AddWorkerDialog extends StatefulWidget {
  const AddWorkerDialog({super.key});

  @override
  State<AddWorkerDialog> createState() => _AddWorkerDialogState();
}

class _AddWorkerDialogState extends State<AddWorkerDialog> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _selectedRole = 'ADMIN';
  bool _isActive = true;
  bool _obscurePassword = true;

  static const _orange = Color(0xFFED6A2E);

  final List<Map<String, String>> _roles = const [
    {'value': 'SUPERADMIN', 'label': 'Super Admin'},
    {'value': 'ADMIN', 'label': 'Администратор'},
    {'value': 'TEACHER', 'label': 'Учитель'},
  ];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_firstNameCtrl.text.isEmpty ||
        _lastNameCtrl.text.isEmpty ||
        _usernameCtrl.text.isEmpty ||
        _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните все обязательные поля'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_passwordCtrl.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пароль минимум 8 символов'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await context.read<AdminCubit>().createAdmin(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
          role: _selectedRole,
          phoneNumber: _phoneCtrl.text.trim().isEmpty
              ? null
              : _phoneCtrl.text.trim(),
          isActive: _isActive,
        );

    if (!mounted) return;

    final state = context.read<AdminCubit>().state;
    if (state is AdminLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Сотрудник добавлен'),
          backgroundColor: Color(0xFF2ECC8A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else if (state is AdminError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: SizedBox(
        width: 560,
        // ✅ SingleChildScrollView убирает overflow
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Заголовок ──
              const Text(
                'Новый сотрудник',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2233),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Заполните данные для добавления в систему',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),

              const SizedBox(height: 28),

              // Имя + Фамилия
              Row(
                children: [
                  Expanded(
                    child: _field(
                      controller: _firstNameCtrl,
                      label: 'Имя',
                      hint: 'Азиз',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                      controller: _lastNameCtrl,
                      label: 'Фамилия',
                      hint: 'Валиев',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Username + Телефон
              Row(
                children: [
                  Expanded(
                    child: _field(
                      controller: _usernameCtrl,
                      label: 'Username',
                      hint: 'aziz_admin',
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                      controller: _phoneCtrl,
                      label: 'Телефон (необязательно)',
                      hint: '+998901234567',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Пароль
              _label('Пароль'),
              const SizedBox(height: 6),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A2233),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Минимум 8 символов',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Роль
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
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A2233),
                    fontWeight: FontWeight.w500,
                  ),
                  items: _roles
                      .map(
                        (r) => DropdownMenuItem(
                          value: r['value'],
                          child: Text(r['label']!),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedRole = v!),
                ),
              ),

              const SizedBox(height: 16),

              // Активен
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Активен',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  value: _isActive,
                  activeColor: _orange,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
              ),

              const SizedBox(height: 28),

              // Кнопка
              BlocBuilder<AdminCubit, AdminState>(
                builder: (context, state) {
                  final isLoading = state is AdminCreating;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _submit,
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.person_add_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                      label: Text(
                        isLoading ? 'Сохранение...' : 'Создать сотрудника',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

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
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A2233),
      ),
    );
  }
}