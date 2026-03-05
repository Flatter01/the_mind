import 'package:flutter/material.dart';

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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedTariff;
  String? _selectedBranch;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить студента'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Имя
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Введите имя' : null,
              ),

              const SizedBox(height: 8),

              /// Фамилия
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Фамилия'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Введите фамилию' : null,
              ),

              const SizedBox(height: 8),

              /// Телефон
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                  hintText: '+998...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите номер';
                  }
                  if (value.length < 7) {
                    return 'Слишком короткий номер';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              /// Филиал
              DropdownButtonFormField<String>(
                value: _selectedBranch,
                decoration: const InputDecoration(labelText: 'Филиал'),
                items: widget.branches
                    .map(
                      (b) => DropdownMenuItem(
                        value: b,
                        child: Text(b),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedBranch = value),
                validator: (value) =>
                    value == null ? 'Выберите филиал' : null,
              ),

            ],
          ),
        ),
      ),

      /// Кнопки
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final result = {
                'firstName': _firstNameController.text,
                'lastName': _lastNameController.text,
                'phone': _phoneController.text,
                'branch': _selectedBranch,
              };

              Navigator.pop(context, result);
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
