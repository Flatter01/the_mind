import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class TheMindProfilePage extends StatefulWidget {
  const TheMindProfilePage({super.key});

  @override
  State<TheMindProfilePage> createState() => _TheMindProfilePageState();
}

class _TheMindProfilePageState extends State<TheMindProfilePage> {
  final nameController = TextEditingController(text: "Abdullox");
  final surnameController = TextEditingController(text: "Developer");
  final phoneController = TextEditingController(text: "+998 90 000 00 00");
  final passwordController = TextEditingController(text: "123456");

  DateTime? birthDate = DateTime(2002, 1, 1);

  final List<String> roles = ["User", "Admin", "Teacher", "Manager"];
  String selectedRole = "User";

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.bgColor, // F5F6FA
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isWide
              ? Row(
                  children: [
                    Expanded(child: _infoCard()),
                    const SizedBox(width: 24),
                    Expanded(child: _editCard()),
                  ],
                )
              : Column(
                  children: [
                    _infoCard(),
                    const SizedBox(height: 24),
                    _editCard(),
                  ],
                ),
        ),
      ),
    );
  }

  // ---------- LEFT (INFO) ----------
  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Profile info"),
          const SizedBox(height: 24),
          _infoRow("Name", nameController.text),
          _infoRow("Surname", surnameController.text),
          _infoRow("Phone", phoneController.text),
          _infoRow("Birth date", _formatDate(birthDate)),
          _infoRow("Role", selectedRole),
        ],
      ),
    );
  }

  // ---------- RIGHT (EDIT) ----------
  Widget _editCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _boxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("Edit profile"),
            const SizedBox(height: 24),

            _field("Name", nameController),
            _field("Surname", surnameController),
            _field("Phone", phoneController),
            _dateField(),
            _roleDropdown(),
            _field("Password", passwordController, isPassword: true),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => setState(() {}),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save changes"),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ---------- FIELDS ----------
  Widget _field(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(color: Colors.black),
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _roleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Role", style: _labelStyle()),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedRole,
            items: roles
                .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedRole = value);
              }
            },
            decoration: _inputDecoration(),
            style: const TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ],
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Birth date", style: _labelStyle()),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final result = await showDatePicker(
                context: context,
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                initialDate: birthDate ?? DateTime(2000),
              );

              if (result != null) {
                setState(() => birthDate = result);
              }
            },
            child: Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.centerLeft,
              decoration: _dateDecoration(),
              child: Text(
                _formatDate(birthDate),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ---------- STYLES ----------
  TextStyle _labelStyle() {
    return const TextStyle(color: Color(0xff6B7280), fontSize: 13);
  }

  Text _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xffE5E7EB)),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xffFAFAFA),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }

  BoxDecoration _dateDecoration() {
    return BoxDecoration(
      color: const Color(0xffFAFAFA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xffE5E7EB)),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Not selected";
    return "${date.day}.${date.month}.${date.year}";
  }
}
