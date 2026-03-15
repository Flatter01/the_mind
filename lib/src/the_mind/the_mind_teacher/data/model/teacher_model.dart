class TeacherModel {
  final String id;
  final String? user;
  final String? username;
  final String? fullName;
  final int? experienceYear;
  final String? education;
  final String? phoneNumber;
  final bool? isSupport;
  final bool? isActive;
  final String? createdAt;

  const TeacherModel({
    required this.id,
    this.user,
    this.username,
    this.fullName,
    this.experienceYear,
    this.education,
    this.phoneNumber,
    this.isSupport,
    this.isActive,
    this.createdAt,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as String? ?? '',
      user: json['user'] as String?,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      experienceYear: json['experience_year'] as int?,
      education: json['education'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isSupport: json['is_support'] as bool?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'username': username,
        'full_name': fullName,
        'experience_year': experienceYear,
        'education': education,
        'phone_number': phoneNumber,
        'is_support': isSupport,
        'is_active': isActive,
        'created_at': createdAt,
      };
}