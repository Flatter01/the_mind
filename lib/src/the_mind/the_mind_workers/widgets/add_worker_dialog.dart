import 'package:flutter/material.dart';
import 'build_workers_table.dart';

class AddWorkerDialog extends StatefulWidget {
  final Function(BuildWorkersTableItem) onAdd;

  const AddWorkerDialog({super.key, required this.onAdd});

  @override
  State<AddWorkerDialog> createState() => _AddWorkerDialogState();
}

class _AddWorkerDialogState extends State<AddWorkerDialog> {
  final name = TextEditingController();
  final surname = TextEditingController();
  final phone = TextEditingController();
  final salary = TextEditingController();

  String? selectedRole;
  bool isActive = true;

  final List<String> roles = [
    "Teacher",
    "Administrator",
    "Manager",
    "Cleaner",
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: dialogWidth(context),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header("Add worker"),
              const SizedBox(height: 20),

              workerField(name, "Name"),
              workerField(surname, "Surname"),

              _roleDropdown(),

              workerField(phone, "Phone"),

              // ✅ Если НЕ учитель → показываем фикс ЗП
              if (selectedRole != null && selectedRole != "Teacher")
                workerField(salary, "Fixed salary"),

              const SizedBox(height: 8),

              _activeSwitch(),

              const SizedBox(height: 24),

              workerActions(
                context,
                onSave: () {
                  widget.onAdd(
                    BuildWorkersTableItem(
                      name: name.text,
                      surname: surname.text,
                      role: selectedRole ?? "",
                      phone: phone.text,
                      isActive: isActive,
                      salary: selectedRole != "Teacher"
                          ? salary.text
                          : null,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        decoration: InputDecoration(
          labelText: "Role",
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        items: roles
            .map(
              (r) => DropdownMenuItem(
                value: r,
                child: Text(r),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
            salary.clear();
          });
        },
      ),
    );
  }

  Widget _header(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        const Text(
          "Fill worker information",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _activeSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: isActive,
        title: const Text("Active worker"),
        onChanged: (v) => setState(() => isActive = v),
      ),
    );
  }

  double dialogWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w > 900) return 520;
    if (w > 600) return 460;
    return w * 0.95;
  }

  Widget workerField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType:
            label == "Fixed salary" ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget workerActions(BuildContext context, {required VoidCallback onSave}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onSave,
          child: const Text("Save"),
        ),
      ],
    );
  }
}