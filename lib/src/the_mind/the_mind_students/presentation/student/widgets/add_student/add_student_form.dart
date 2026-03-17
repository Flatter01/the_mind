import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';

class AddStudentForm extends StatefulWidget {
  final List<String> courses;
  final List<String> groups;
  final List<GroupModel> groupModels;
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

  String? selectedGender;
  String? selectedSource;
  String? selectedGroup;
  String? selectedGroupId;
  String? autoTeacherName;
  bool _isLoading = false;

  int _step = 0;

  static const _orange = Color(0xFFED6A2E);
  static const _orangeLight = Color(0xFFFFF3EE);
  static const _bg = Color(0xFFF7F8FA);
  static const _border = Color(0xFFE8EAF0);
  static const _text = Color(0xFF1A1F36);
  static const _grey = Color(0xFF8A94A6);

  final List<String> sources = [
    'Instagram',
    'Telegram',
    'YouTube',
    "Do'stlar orqali",
    'Reklama',
    'Boshqa',
  ];

  @override
  void dispose() {
    nameCtrl.dispose();
    surnameCtrl.dispose();
    phoneCtrl.dispose();
    phone2Ctrl.dispose();
    birthdayCtrl.dispose();
    super.dispose();
  }

  void _onGroupSelected(String? groupName) {
    setState(() {
      selectedGroup = groupName;
      if (groupName == null) {
        selectedGroupId = null;
        autoTeacherName = null;
        return;
      }
      final match =
          widget.groupModels.where((g) => g.name == groupName).firstOrNull;
      selectedGroupId = match?.id?.toString();
      final rawName = match?.teacherName ?? '';
      final cleaned = rawName
          .split(' ')
          .where((p) => p.isNotEmpty && p.toLowerCase() != 'none')
          .join(' ')
          .trim();
      autoTeacherName = cleaned.isEmpty ? null : cleaned;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final parentPhone = phone2Ctrl.text.trim();

    try {
      await context.read<StudentCubit>().addStudent(
            groupName: selectedGroup ?? '',
            teacherName: autoTeacherName ?? '',
            firstName: nameCtrl.text.trim(),
            lastName: surnameCtrl.text.trim(),
            phone: phoneCtrl.text.trim(),
            parentPhone: parentPhone.isEmpty ? null : parentPhone,
            status: 'active',
            birthDate: birthdayCtrl.text.trim().isEmpty
                ? '2000-01-01'
                : birthdayCtrl.text.trim(),
            gender: selectedGender == 'Erkak' ? 'male' : 'female',
            // district: 1, // ✅ По умолчанию 1 — API требует реальный ID
            source: _mapSource(selectedSource),
            notes: '',
            groupIntId: int.tryParse(selectedGroupId ?? ''),
          );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xatolik: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapSource(String? source) {
    const map = {
      'Instagram': 'instagram',
      'Telegram': 'telegram',
      'YouTube': 'youtube',
      "Do'stlar orqali": 'friends',
      'Reklama': 'ads',
      'Boshqa': 'other',
    };
    return map[source] ?? 'instagram';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isMobile ? double.infinity : 620,
      decoration: const BoxDecoration(color: Colors.white),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 16, 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _border)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _orangeLight,
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
                        "Yangi o'quvchi",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      Text(
                        "Ma'lumotlarni to'ldiring",
                        style: TextStyle(fontSize: 12, color: _grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        Icon(Icons.close, color: Colors.grey[400], size: 20),
                  ),
                ],
              ),
            ),

            // ── Степпер ──
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _border)),
              ),
              child: Row(
                children: [
                  _stepIndicator(0, 'Шахсий'),
                  _stepLine(0),
                  _stepIndicator(1, 'Контакт'),
                  _stepLine(1),
                  _stepIndicator(2, 'Гуруҳ'),
                ],
              ),
            ),

            // ── Body ──
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: _buildStep(_step),
                ),
              ),
            ),

            // ── Footer ──
            Container(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _border)),
              ),
              child: Row(
                children: [
                  if (_step > 0)
                    TextButton.icon(
                      onPressed: () => setState(() => _step--),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Орқага'),
                      style: TextButton.styleFrom(foregroundColor: _grey),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      'Бекор қилиш',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (_step < 2) _nextButton() else _saveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Степпер ───────────────────────────────────────────────────────────────

  Widget _stepIndicator(int index, String label) {
    final isDone = _step > index;
    final isActive = _step == index;
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFF2ECC8A)
                  : isActive
                      ? _orange
                      : _bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone
                    ? const Color(0xFF2ECC8A)
                    : isActive
                        ? _orange
                        : _border,
                width: 2,
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : _grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? _orange : _grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLine(int afterIndex) {
    final isDone = _step > afterIndex;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isDone ? const Color(0xFF2ECC8A) : _border,
      ),
    );
  }

  // ── Шаги ─────────────────────────────────────────────────────────────────

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _stepPersonal();
      case 1:
        return _stepContact();
      case 2:
        return _stepGroup();
      default:
        return const SizedBox();
    }
  }

  // Шаг 1 — Личные данные
  Widget _stepPersonal() {
    return Column(
      key: const ValueKey('step0'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Шахсий маълумотлар'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _field(
                controller: surnameCtrl,
                label: 'Familiya',
                icon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Familiyani kiriting' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _field(
                controller: nameCtrl,
                label: 'Ism',
                icon: Icons.person,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ismni kiriting' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _datePicker()),
            const SizedBox(width: 16),
            Expanded(child: _genderSelector()),
          ],
        ),
        const SizedBox(height: 16),
        // ✅ Только источник — район убран (отправляем district: 1 по умолчанию)
        _sourceDropdown(),
      ],
    );
  }

  // Шаг 2 — Контакт
  Widget _stepContact() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Алоқа маълумотлари'),
        const SizedBox(height: 16),
        _field(
          controller: phoneCtrl,
          label: 'Telefon raqam',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Telefon kiriting';
            if (v.length < 7) return 'Raqam juda qisqa';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _field(
          controller: phone2Ctrl,
          label: "Qo'shimcha raqam (ixtiyoriy)",
          icon: Icons.phone_in_talk_outlined,
          keyboardType: TextInputType.phone,
          isRequired: false,
        ),
        const SizedBox(height: 16),
        _previewCard(),
      ],
    );
  }

  // Шаг 3 — Группа
  Widget _stepGroup() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Гуруҳга бириктириш'),
        const SizedBox(height: 16),
        _groupDropdown(),
        if (autoTeacherName != null) ...[
          const SizedBox(height: 16),
          _teacherCard(),
        ],
        const SizedBox(height: 16),
        _finalPreview(),
      ],
    );
  }

  // ── Карточки превью ───────────────────────────────────────────────────────

  Widget _previewCard() {
    if (nameCtrl.text.isEmpty && surnameCtrl.text.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _orangeLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _orange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                nameCtrl.text.isNotEmpty
                    ? nameCtrl.text[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: _orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${surnameCtrl.text} ${nameCtrl.text}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  birthdayCtrl.text.isEmpty
                      ? selectedGender ?? ''
                      : '${birthdayCtrl.text} · ${selectedGender ?? ''}',
                  style: const TextStyle(fontSize: 12, color: _grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _finalPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _previewRow(
            Icons.person_outline,
            'Исм',
            '${surnameCtrl.text} ${nameCtrl.text}',
          ),
          _previewDivider(),
          _previewRow(Icons.phone_outlined, 'Телефон', phoneCtrl.text),
          if (selectedGroup != null) ...[
            _previewDivider(),
            _previewRow(Icons.group_outlined, 'Гуруҳ', selectedGroup!),
          ],
          if (autoTeacherName != null) ...[
            _previewDivider(),
            _previewRow(
                Icons.school_outlined, 'Ўқитувчи', autoTeacherName!),
          ],
        ],
      ),
    );
  }

  Widget _previewRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: _grey),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12, color: _grey)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewDivider() =>
      Divider(height: 1, color: Colors.grey.withOpacity(0.15));

  Widget _teacherCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC8A).withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2ECC8A).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC8A).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                autoTeacherName!.isNotEmpty
                    ? autoTeacherName![0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2ECC8A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "O'qituvchi",
                  style: TextStyle(fontSize: 11, color: _grey),
                ),
                Text(
                  autoTeacherName!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _text,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF2ECC8A), size: 18),
        ],
      ),
    );
  }

  // ── Поля ввода ────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _grey,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isRequired = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator ??
          (v) {
            if (!isRequired) return null;
            if (v == null || v.trim().isEmpty) return '$label kiriting';
            return null;
          },
      style: const TextStyle(fontSize: 14, color: _text),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: _grey),
        prefixIcon: Icon(icon, size: 18, color: _grey),
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
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _datePicker() {
    return TextFormField(
      controller: birthdayCtrl,
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(1960),
          lastDate: DateTime.now(),
          initialDate: DateTime(2005),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: _orange),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          setState(() {
            birthdayCtrl.text =
                '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
          });
        }
      },
      style: const TextStyle(fontSize: 14, color: _text),
      decoration: InputDecoration(
        labelText: "Tug'ilgan sana",
        labelStyle: const TextStyle(fontSize: 13, color: _grey),
        prefixIcon:
            const Icon(Icons.cake_outlined, size: 18, color: _grey),
        suffixIcon: birthdayCtrl.text.isEmpty
            ? null
            : const Icon(
                Icons.check_circle,
                size: 16,
                color: Color(0xFF2ECC8A),
              ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _genderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'JINSI',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: _grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: ['Erkak', 'Ayol'].map((g) {
            final isSelected = selectedGender == g;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedGender = g),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.only(right: g == 'Erkak' ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: isSelected ? _orange : _bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _orange : _border,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        g == 'Erkak' ? Icons.male : Icons.female,
                        size: 18,
                        color: isSelected ? Colors.white : _grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        g,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : _grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _sourceDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedSource,
      validator: (v) => v == null ? 'Manbani tanlang' : null,
      style: const TextStyle(fontSize: 14, color: _text),
      decoration: InputDecoration(
        labelText: 'Qayerdan bildi',
        labelStyle: const TextStyle(fontSize: 13, color: _grey),
        prefixIcon:
            const Icon(Icons.public_outlined, size: 18, color: _grey),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items: sources
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      onChanged: (v) => setState(() => selectedSource = v),
    );
  }

  Widget _groupDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedGroup,
      style: const TextStyle(fontSize: 14, color: _text),
      decoration: InputDecoration(
        labelText: "Guruh (ixtiyoriy)",
        labelStyle: const TextStyle(fontSize: 13, color: _grey),
        prefixIcon:
            const Icon(Icons.group_outlined, size: 18, color: _grey),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items: widget.groups
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: _onGroupSelected,
    );
  }

  // ── Кнопки ────────────────────────────────────────────────────────────────

  Widget _nextButton() {
    return GestureDetector(
      onTap: () {
        if (_step == 0) {
          if (nameCtrl.text.isEmpty ||
              surnameCtrl.text.isEmpty ||
              selectedGender == null ||
              selectedSource == null) {
            _formKey.currentState?.validate();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Barcha maydonlarni to'ldiring"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
        }
        if (_step == 1) {
          if (phoneCtrl.text.isEmpty || phoneCtrl.text.length < 7) {
            _formKey.currentState?.validate();
            return;
          }
        }
        setState(() => _step++);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          color: _orange,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _orange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Кейинги',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        decoration: BoxDecoration(
          color: _isLoading ? _orange.withOpacity(0.6) : _orange,
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
                  Icon(Icons.check, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Saqlash',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}