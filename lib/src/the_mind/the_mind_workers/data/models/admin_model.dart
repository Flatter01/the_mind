class AdminModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String roleDisplay;
  final String? phoneNumber;
  final bool isActive;

  const AdminModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.roleDisplay,
    this.phoneNumber,
    required this.isActive,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      roleDisplay: json['role_display'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  // СТАЛО:
  String get fullName {
    final name = '${firstName.trim()} ${lastName.trim()}'.trim();
    return name.isEmpty || name == '.' ? 'Без имени' : name;
  }

  String get initials {
    final f = firstName.trim().isNotEmpty
        ? firstName.trim()[0].toUpperCase()
        : '';
    final l = lastName.trim().isNotEmpty
        ? lastName.trim()[0].toUpperCase()
        : '';
    final result = '$f$l'.trim();
    return result.isEmpty ? '?' : result;
  }
}
