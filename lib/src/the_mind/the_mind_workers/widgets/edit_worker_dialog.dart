import 'package:flutter/material.dart';
import 'build_workers_table.dart';

class EditWorkerDialog extends StatefulWidget {
  final BuildWorkersTableItem worker;
  final VoidCallback onSave;

  const EditWorkerDialog({
    super.key,
    required this.worker,
    required this.onSave,
  });

  @override
  State<EditWorkerDialog> createState() => _EditWorkerDialogState();
}

class _EditWorkerDialogState extends State<EditWorkerDialog> {
  late TextEditingController name;
  late TextEditingController surname;
  late TextEditingController role;
  late TextEditingController phone;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.worker.name);
    surname = TextEditingController(text: widget.worker.surname);
    role = TextEditingController(text: widget.worker.role);
    phone = TextEditingController(text: widget.worker.phone);
    isActive = widget.worker.isActive;
  }

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
              _header("Edit worker"),
              const SizedBox(height: 20),

              workerField(name, "Name"),
              workerField(surname, "Surname"),
              workerField(role, "Role"),
              workerField(phone, "Phone"),

              const SizedBox(height: 8),

              workerActiveSwitch(
                value: isActive,
                onChanged: (v) => setState(() => isActive = v),
              ),
              const SizedBox(height: 24),

              workerActions(
                context,
                onSave: () {
                  widget.worker
                    ..name = name.text
                    ..surname = surname.text
                    ..role = role.text
                    ..phone = phone.text
                    ..isActive = isActive;

                  widget.onSave();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget workerActiveSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text("Active worker"),
        value: value,
        onChanged: onChanged,
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
