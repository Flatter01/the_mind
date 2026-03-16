class StudentModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? parentPhone;
  final String status;
  final String? statusDisplay;
  final String? birthDate;
  final String? gender;
  final int? district;
  final String? source;
  final String? notes;
  final String? joinedAt;
  final String? createdAt;
  final String? groupId;
  final String? groupName;
  final String? teacherId;
  final String? teacherName;
  final String? courseId;
  final String? courseName;
  final String? groupPrice;
  final String? discountAmount;
  final String? finalPrice;
  final String? paidAmount;
  final String balance;
  final String? debtStatus;

  const StudentModel({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.parentPhone,
    required this.status,
    this.statusDisplay,
    this.birthDate,
    this.gender,
    this.district,
    this.source,
    this.notes,
    this.joinedAt,
    this.createdAt,
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
    required this.balance,
    this.debtStatus,
  });

  // ====== COPYWITH ======
  StudentModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? parentPhone,
    String? status,
    String? statusDisplay,
    String? birthDate,
    String? gender,
    int? district,
    String? source,
    String? notes,
    String? joinedAt,
    String? createdAt,
    String? groupId,
    String? groupName,
    String? teacherId,
    String? teacherName,
    String? courseId,
    String? courseName,
    String? groupPrice,
    String? discountAmount,
    String? finalPrice,
    String? paidAmount,
    String? balance,
    String? debtStatus,
  }) {
    return StudentModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      parentPhone: parentPhone ?? this.parentPhone,
      status: status ?? this.status,
      statusDisplay: statusDisplay ?? this.statusDisplay,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      district: district ?? this.district,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      joinedAt: joinedAt ?? this.joinedAt,
      createdAt: createdAt ?? this.createdAt,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      groupPrice: groupPrice ?? this.groupPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      finalPrice: finalPrice ?? this.finalPrice,
      paidAmount: paidAmount ?? this.paidAmount,
      balance: balance ?? this.balance,
      debtStatus: debtStatus ?? this.debtStatus,
    );
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      parentPhone: json['parent_phone'] as String?,
      status: json['status'] as String? ?? 'active',
      statusDisplay: json['status_display'] as String?,
      birthDate: json['birth_date'] as String?,
      gender: json['gender'] as String?,
      district: json['district'] as int?,
      source: json['source'] as String?,
      notes: json['notes'] as String?,
      joinedAt: json['joined_at'] as String?,
      createdAt: json['created_at'] as String?,
      groupId: json['group_id'] as String?,
      groupName: json['group_name'] as String?,
      teacherId: json['teacher_id'] as String?,
      teacherName: json['teacher_name'] as String?,
      courseId: json['course_id'] as String?,
      courseName: json['course_name'] as String?,
      groupPrice: json['group_price'] as String?,
      discountAmount: json['discount_amount'] as String?,
      finalPrice: json['final_price'] as String?,
      paidAmount: json['paid_amount'] as String?,
      balance: json['balance'] as String? ?? '0',
      debtStatus: json['debt_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'parent_phone': parentPhone,
        'status': status,
        'status_display': statusDisplay,
        'birth_date': birthDate,
        'gender': gender,
        'district': district,
        'source': source,
        'notes': notes,
        'joined_at': joinedAt,
        'created_at': createdAt,
        'group_id': groupId,
        'group_name': groupName,
        'teacher_id': teacherId,
        'teacher_name': teacherName,
        'course_id': courseId,
        'course_name': courseName,
        'group_price': groupPrice,
        'discount_amount': discountAmount,
        'final_price': finalPrice,
        'paid_amount': paidAmount,
        'balance': balance,
        'debt_status': debtStatus,
      };
}