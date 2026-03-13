class StudentModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? parentPhone;
  final String status;
  final String statusDisplay;
  final String? birthDate;
  final String? gender;
  final int? district;
  final String source;
  final String? notes;
  final String joinedAt;
  final String createdAt;

  final int? groupId;
  final String? groupName;
  final String balance;

  final int? teacherId;
  final String? teacherName;

  final int? courseId;
  final String? courseName;

  final String? debtStatus;

  StudentModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.parentPhone,
    required this.status,
    required this.statusDisplay,
    this.birthDate,
    this.gender,
    this.district,
    required this.source,
    this.notes,
    required this.joinedAt,
    required this.createdAt,
    required this.balance,
    this.groupId,
    this.groupName,
    this.teacherId,
    this.teacherName,
    this.courseId,
    this.courseName,
    this.debtStatus,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json["id"] ?? 0,
      firstName: json["first_name"] as String?,
      lastName: json["last_name"] as String?,
      phone: json["phone"] as String?,
      parentPhone: json["parent_phone"] as String?,
      status: json["status"] as String? ?? "unknown",
      statusDisplay: json["status_display"] as String? ?? "unknown",
      birthDate: json["birth_date"] as String?,
      gender: json["gender"] as String?,
      district: json["district"] as int?,
      source: json["source"] as String? ?? "unknown",
      notes: json["notes"] as String?,
      joinedAt: json["joined_at"] as String? ?? "",
      createdAt: json["created_at"] as String? ?? "",
      balance: json["balance"] as String? ?? "0",
      groupId: json["group_id"] is int
          ? json["group_id"]
          : int.tryParse(json["group_id"].toString()),
      groupName: json["group_name"] as String?,
      teacherId: json["teacher_id"] as int?,
      teacherName: json["teacher_name"] as String?,
      courseId: json["course_id"] as int?,
      courseName: json["course_name"] as String?,
      debtStatus: json["debt_status"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "parent_phone": parentPhone,
      "birth_date": birthDate,
      "gender": gender,
      "district": district,
      "source": source,
      "notes": notes,
    };
  }
}
