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

  // UUID строки вместо int!
  final String? groupId;
  final String? groupName;
  final String? teacherId;
  final String? teacherName;
  final String? courseId;
  final String? courseName;

  // Финансовые поля
  final String balance;
  final String? groupPrice;
  final String? discountAmount;
  final String? finalPrice;
  final String? paidAmount;
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
    this.groupPrice,
    this.discountAmount,
    this.finalPrice,
    this.paidAmount,
    this.debtStatus,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    // print('From json model $json');
    return StudentModel(
      id: json["id"] as int? ?? 0,
      firstName: json["first_name"] as String?,
      lastName: json["last_name"] as String?,
      phone: json["phone"] as String?,
      parentPhone: json["parent_phone"] as String?,
      status: json["status"] as String? ?? "unknown",
      statusDisplay: json["status_display"] as String? ?? "",
      birthDate: json["birth_date"] as String?,
      gender: json["gender"] as String?,
      district: json["district"] as int?,
      source: json["source"] as String? ?? "unknown",
      notes: json["notes"] as String?,
      joinedAt: json["joined_at"] as String? ?? "",
      createdAt: json["created_at"] as String? ?? "",
      balance: json["balance"]?.toString() ?? "0",

      // UUID поля — просто String
      groupId: json["group_id"] as String?,
      groupName: json["group_name"] ?? '_____',
      teacherId: json["teacher_id"] as String?,
      teacherName: json["teacher_name"] ?? '_____',
      courseId: json["course_id"] as String?,
      courseName: json["course_name"] as String?,

      // Финансы
      groupPrice: json["group_price"]?.toString(),
      discountAmount: json["discount_amount"]?.toString(),
      finalPrice: json["final_price"]?.toString(),
      paidAmount: json["paid_amount"]?.toString(),
      debtStatus: json["debt_status"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "parent_phone": parentPhone,
      "status": status,
      "birth_date": birthDate,
      "gender": gender,
      "district": district,
      "source": source,
      "notes": notes,
      "group_id": groupId,
    };
  }
}