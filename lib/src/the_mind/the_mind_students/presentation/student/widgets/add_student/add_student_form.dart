import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';

class AddStudentForm extends StatefulWidget {
  final List<String> courses;
  final List<String> groups;
  final List<GroupModel> groupModels; // ← қўшилди
  final bool isMobile;

  const AddStudentForm({
    super.key,
    required this.courses,
    required this.groups,
    required this.isMobile,
    this.groupModels = const [],
  });

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final surnameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final phone2Ctrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  final districtCtrl = TextEditingController();

  String? selectedGender;
  String? selectedSource;
  String? selectedCourse;
  String? selectedGroup; // Гуруҳ номи
  int? selectedGroupId; // Гуруҳ UUID — API'га юборилади
  String? autoTeacherName; // Гуруҳдан автоматик
  bool _isLoading = false;

  final List<String> genders = ["Erkak", "Ayol"];
  final List<String> sources = [
    "Instagram",
    "Telegram",
    "YouTube",
    "Do'stlar orqali",
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
    super.dispose();
  }

  // Гуруҳ танлангандa UUID ва ўқитувчини топамиз
  void _onGroupSelected(String? groupName) {
    setState(() {
      selectedGroup = groupName;
      if (groupName == null) {
        selectedGroupId = null;
        autoTeacherName = null;
        return;
      }
      final match = widget.groupModels
          .where((g) => g.name == groupName)
          .firstOrNull;

      selectedGroupId = match?.id; // ✅ UUID группы
      autoTeacherName = match?.teacherName; // для отображения
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final parentPhone = phone2Ctrl.text.trim();

    try {
      await context.read<StudentCubit>().addStudent(
        groupName: selectedGroup ?? "", // ← группа номи
        teacherName: autoTeacherName ?? "",
        firstName: nameCtrl.text.trim(),
        lastName: surnameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        parentPhone: parentPhone.isEmpty ? null : parentPhone,
        status: "active",
        birthDate: birthdayCtrl.text.trim().isEmpty
            ? "2000-01-01"
            : birthdayCtrl.text.trim(),
        gender: selectedGender == "Erkak" ? "male" : "female",
        district: int.tryParse(districtCtrl.text.trim()) ?? 1,
        source: _mapSource(selectedSource),
        notes: "",
        // groupId: selectedGroupId, // ← UUID автоматик
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapSource(String? source) {
    const map = {
      "Instagram": "instagram",
      "Telegram": "telegram",
      "YouTube": "youtube",
      "Do'stlar orqali": "friends",
      "Reklama": "ads",
      "Boshqa": "other",
    };
    return map[source] ?? "instagram";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isMobile ? double.infinity : 650,
      padding: EdgeInsets.all(widget.isMobile ? 18 : 28),
      color: AppColors.bgColor,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Yangi o'quvchi qo'shish",
                style: TextStyle(
                  fontSize: widget.isMobile ? 22 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text("Bekor qilish"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED6A2E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        : const Text(
                            "Saqlash",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── TEACHER INFO WIDGET ─────────────────────────────────────────
  Widget _teacherInfoWidget() {
    if (autoTeacherName == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFED6A2E).withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFED6A2E).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFED6A2E).withOpacity(0.15),
            child: Text(
              autoTeacherName!.isNotEmpty
                  ? autoTeacherName![0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFED6A2E),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "O'qituvchi",
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              Text(
                autoTeacherName!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A2233),
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.check_circle, color: const Color(0xFFED6A2E), size: 18),
        ],
      ),
    );
  }

  // ── INPUTS ──────────────────────────────────────────────────────

  List<Widget> _buildInputsMobile() => [
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
      label: "Tug'ilgan sana",
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
      label: "Qo'shimcha raqam",
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
    // ← Гуруҳ dropdown — _onGroupSelected билан
    _dropdown(
      "Guruh",
      selectedGroup,
      widget.groups,
      Icons.group,
      _onGroupSelected,
      isRequired: false,
    ),
    const SizedBox(height: 10),
    // ← Автоматик ўқитувчи
    _teacherInfoWidget(),
    const SizedBox(height: 10),
    _input(
      controller: districtCtrl,
      label: "Tuman (raqam)",
      icon: Icons.location_on,
    ),
  ];

  List<Widget> _leftSideInputs() => [
    _input(controller: nameCtrl, label: "Ism", icon: Icons.person),
    const SizedBox(height: 14),
    _input(
      controller: birthdayCtrl,
      label: "Tug'ilgan sana",
      icon: Icons.cake,
      datePicker: true,
    ),
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

  List<Widget> _rightSideInputs() => [
    _input(
      controller: surnameCtrl,
      label: "Familiya",
      icon: Icons.person_outline,
    ),
    const SizedBox(height: 14),
    _input(
      controller: districtCtrl,
      label: "Tuman (raqam)",
      icon: Icons.location_on,
    ),
    const SizedBox(height: 14),
    _input(
      controller: phone2Ctrl,
      label: "Qo'shimcha raqam",
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
    // ← Гуруҳ dropdown
    _dropdown(
      "Guruh",
      selectedGroup,
      widget.groups,
      Icons.group,
      _onGroupSelected,
      isRequired: false,
    ),
    const SizedBox(height: 14),
    // ← Автоматик ўқитувчи
    _teacherInfoWidget(),
  ];

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
        if (v == null || v.trim().isEmpty) return "$label kiriting";
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
      validator: (_) {
        if (!isRequired) return null;
        if (value == null || value.isEmpty) return "$label tanlang";
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

  VoidCallback _pickDate(TextEditingController controller) => () async {
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

  String _twoDigits(int v) => v.toString().padLeft(2, "0");
}
