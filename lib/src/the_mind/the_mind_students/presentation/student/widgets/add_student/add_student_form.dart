import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student_state.dart';

class AddStudentForm extends StatefulWidget {
  final List<String> courses;
  final List<String> groups;
  final bool isMobile;

  const AddStudentForm({
    super.key,
    required this.courses,
    required this.groups,
    required this.isMobile,
  });

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final nameCtrl = TextEditingController();
  final surnameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final phone2Ctrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final groupIdCtrl = TextEditingController();

  // dropdowns
  String? selectedGender;
  String? selectedSource;
  String? selectedCourse;
  String? selectedGroup;

  final List<String> genders = ["Erkak", "Ayol"];

  final List<String> sources = [
    "Instagram",
    "Telegram",
    "YouTube",
    "Do‘stlar orqali",
    "Reklama",
    "Boshqa",
  ];

  @override
  void dispose() {
    nameCtrl.dispose();
    surnameCtrl.dispose();
    phoneCtrl.dispose();
    phone2Ctrl.dispose();
    birthdayCtrl.dispose();
    districtCtrl.dispose();
    groupIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isMobile ? double.infinity : 650,
      padding: EdgeInsets.all(widget.isMobile ? 18 : 28),
      color: AppColors.bgColor,
      child: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {
          if (state is StudentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is StudentLoaded) {
            Navigator.pop(context);
          }
        },
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---- TITLE ----
                Text(
                  "Yangi o‘quvchi qo‘shish",
                  style: TextStyle(
                    fontSize: widget.isMobile ? 22 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // ---- RESPONSIVE FORM ----
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 580;

                    if (isMobile) {
                      return Column(children: _buildInputsMobile());
                    }

                    final columnWidth = (constraints.maxWidth - 20) / 2;
                    return Wrap(
                      spacing: 20,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: columnWidth,
                          child: Column(children: _leftSideInputs()),
                        ),
                        SizedBox(
                          width: columnWidth,
                          child: Column(children: _rightSideInputs()),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                // ---- BUTTONS ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Bekor qilish"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<StudentCubit>().addStudent(
                            firstName: nameCtrl.text,
                            lastName: surnameCtrl.text,
                            phone: phoneCtrl.text,
                            parentPhone: null,
                            status: "active",
                            birthDate: "2000-01-01",
                            gender: "male",
                            district: 1,
                            source: "telegram",
                            notes: "",
                            groupId: null,
                          );

                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Saqlash"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------- MOBILE FORM ----------------------

  List<Widget> _buildInputsMobile() {
    return [
      _input(controller: nameCtrl, label: "Ism", icon: Icons.person),
      const SizedBox(height: 10),
      _input(
        controller: surnameCtrl,
        label: "Familiya",
        icon: Icons.person_outline,
      ),
      const SizedBox(height: 10),
      _input(
        controller: birthdayCtrl,
        label: "Tug‘ilgan sana",
        icon: Icons.cake,
        datePicker: true,
      ),
      const SizedBox(height: 10),

      _dropdown(
        "Jinsi",
        selectedGender,
        genders,
        Icons.male,
        (v) => setState(() => selectedGender = v),
      ),
      const SizedBox(height: 10),

      _input(
        controller: phoneCtrl,
        label: "Telefon raqam",
        icon: Icons.phone,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 10),

      _input(
        controller: phone2Ctrl,
        label: "Qo‘shimcha raqam",
        icon: Icons.phone_in_talk,
        keyboardType: TextInputType.phone,
        isRequired: false,
      ),
      const SizedBox(height: 10),

      _dropdown(
        "Qayerdan bilgan",
        selectedSource,
        sources,
        Icons.public,
        (v) => setState(() => selectedSource = v),
      ),
      const SizedBox(height: 10),

      _dropdown(
        "Kurs",
        selectedCourse,
        widget.courses,
        Icons.book,
        (v) => setState(() => selectedCourse = v),
      ),
      const SizedBox(height: 10),

      _dropdown(
        "Guruh",
        selectedGroup,
        widget.groups,
        Icons.group,
        (v) => setState(() => selectedGroup = v),
        isRequired: false,
      ),
      const SizedBox(height: 10),

      _input(
        controller: groupIdCtrl,
        label: "Group ID (UUID)",
        icon: Icons.tag,
        keyboardType: TextInputType.text,
        isRequired: false,
      ),
      const SizedBox(height: 10),

      _input(controller: districtCtrl, label: "Tuman", icon: Icons.location_on),
    ];
  }

  // ---------------------- WEB (LEFT SIDE) ----------------------

  List<Widget> _leftSideInputs() {
    return [
      _input(controller: nameCtrl, label: "Ism", icon: Icons.person),
      const SizedBox(height: 14),
      _input(
        controller: phoneCtrl,
        label: "Telefon",
        icon: Icons.phone,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 14),
      _dropdown(
        "Jinsi",
        selectedGender,
        genders,
        Icons.male,
        (v) => setState(() => selectedGender = v),
      ),
      const SizedBox(height: 14),
      _dropdown(
        "Kurs",
        selectedCourse,
        widget.courses,
        Icons.book,
        (v) => setState(() => selectedCourse = v),
      ),
    ];
  }

  // ---------------------- WEB (RIGHT SIDE) ----------------------

  List<Widget> _rightSideInputs() {
    return [
      _input(
        controller: surnameCtrl,
        label: "Familiya",
        icon: Icons.person_outline,
      ),
      const SizedBox(height: 14),
      _input(
        controller: phone2Ctrl,
        label: "Qo‘shimcha raqam",
        icon: Icons.phone_in_talk,
        keyboardType: TextInputType.phone,
        isRequired: false,
      ),
      const SizedBox(height: 14),
      _dropdown(
        "Qayerdan bilgan",
        selectedSource,
        sources,
        Icons.public,
        (v) => setState(() => selectedSource = v),
      ),
      const SizedBox(height: 14),
      _dropdown(
        "Guruh",
        selectedGroup,
        widget.groups,
        Icons.group,
        (v) => setState(() => selectedGroup = v),
        isRequired: false,
      ),
      const SizedBox(height: 14),
      _input(
        controller: groupIdCtrl,
        label: "Group ID (UUID)",
        icon: Icons.tag,
        keyboardType: TextInputType.text,
        isRequired: false,
      ),
      const SizedBox(height: 14),
      _input(controller: districtCtrl, label: "Tuman", icon: Icons.location_on),
    ];
  }

  // ---------------------- SHARED WIDGETS ----------------------

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool datePicker = false,
    TextInputType? keyboardType,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: datePicker,
      onTap: datePicker ? _pickDate(controller) : null,
      keyboardType: keyboardType,
      validator: (v) {
        if (!isRequired) return null;
        if (v == null || v.trim().isEmpty) {
          return "$label kiriting";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardColor, width: 1.4),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    IconData icon,
    ValueChanged<String?> onChanged, {
    bool isRequired = true,
  }) {
    return FormField<String>(
      validator: (v) {
        if (!isRequired) return null;
        if (value?.isEmpty ?? true) {
          return "$label tanlang";
        }
        return null;
      },
      builder: (state) => InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black54),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.cardColor,
              width: 1.4,
            ),
          ),
          errorText: state.errorText,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Text(label),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              onChanged(v);
              state.didChange(v);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final parentPhone = phone2Ctrl.text.trim();
    final groupId = groupIdCtrl.text.trim();

    await context.read<StudentCubit>().addStudent(
      id: 0,
      firstName: nameCtrl.text.trim(),
      lastName: surnameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      parentPhone: parentPhone.isEmpty ? null : parentPhone,
      status: "active",
      birthDate: birthdayCtrl.text.trim(),
      gender: selectedGender == "Erkak" ? "male" : "female",
      district: int.tryParse(districtCtrl.text.trim()) ?? 0,
      source: selectedSource?.toLowerCase() ?? "instagram",
      notes: "",
      groupId: groupId.isEmpty ? null : groupId,
    );

    if (!mounted) return;
    Navigator.pop(context);
    print("Student qo'shildi");
  }

  VoidCallback _pickDate(TextEditingController controller) {
    return () async {
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1960),
        lastDate: DateTime.now(),
        initialDate: DateTime(2005),
      );
      if (picked != null) {
        controller.text =
            "${picked.year}-${_twoDigits(picked.month)}-${_twoDigits(picked.day)}";
      }
    };
  }

  String _twoDigits(int v) => v.toString().padLeft(2, "0");
}
