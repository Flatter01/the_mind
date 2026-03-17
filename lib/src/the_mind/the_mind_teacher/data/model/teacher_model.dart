class TeacherModel {
  final String id;         // UUID
  final String fullName;
  final String username;
  final String phoneNumber;
  final bool isActive;
  final bool isSupport;
  final int experienceYear;
  final String education;
  final String createdAt;

  const TeacherModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.isActive,
    required this.isSupport,
    required this.experienceYear,
    required this.education,
    required this.createdAt,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      isSupport: json['is_support'] as bool? ?? false,
      experienceYear: json['experience_year'] as int? ?? 0,
      education: json['education'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}