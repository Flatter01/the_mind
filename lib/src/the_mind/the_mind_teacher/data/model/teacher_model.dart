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

// ─── teacher_journal_model.dart ───────────────────────────────────────────────

class TeacherJournalModel {
  final int? id;
  final int group;
  final String groupName;
  final int? lesson;
  final String lessonDate;
  final String notes;
  final List<dynamic> studentRecords;

  TeacherJournalModel({
    this.id,
    required this.group,
    required this.groupName,
    this.lesson,
    required this.lessonDate,
    required this.notes,
    required this.studentRecords,
  });

  factory TeacherJournalModel.fromJson(Map<String, dynamic> json) {
    return TeacherJournalModel(
      id: json['id'],
      group: json['group'] ?? 0,
      groupName: json['group_name'] ?? '',
      lesson: json['lesson'],
      lessonDate: json['lesson_date'] ?? '',
      notes: json['notes'] ?? '',
      studentRecords: json['student_records'] ?? [],
    );
  }
}
// ─── teacher_dashboard_model.dart ─────────────────────────────────────────────

class TeacherDashboardModel {
  final String balance;
  final String fine;
  final int lessonsThisMonth;
  final int studentsCount;
  final List<TeacherGroupItemModel> groups;
  final List<TodayLessonModel> todayLessons;

  TeacherDashboardModel({
    required this.balance,
    required this.fine,
    required this.lessonsThisMonth,
    required this.studentsCount,
    required this.groups,
    required this.todayLessons,
  });

  factory TeacherDashboardModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardModel(
      balance: json['balance'] ?? '0.00',
      fine: json['fine'] ?? '0.00',
      lessonsThisMonth: json['lessons_this_month'] ?? 0,
      studentsCount: json['students_count'] ?? 0,
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((e) => TeacherGroupItemModel.fromJson(e))
          .toList(),
      todayLessons: (json['today_lessons'] as List<dynamic>? ?? [])
          .map((e) => TodayLessonModel.fromJson(e))
          .toList(),
    );
  }
}

class TeacherGroupItemModel {
  final int id;
  final String name;
  final int studentCount;

  TeacherGroupItemModel({
    required this.id,
    required this.name,
    required this.studentCount,
  });

  factory TeacherGroupItemModel.fromJson(Map<String, dynamic> json) {
    return TeacherGroupItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      studentCount: json['student_count'] ?? 0,
    );
  }
}

class TodayLessonModel {
  final int? id;
  final String time;
  final String name;
  final String subtitle;
  final String type;
  final String status;
  final bool isGroup;

  TodayLessonModel({
    this.id,
    required this.time,
    required this.name,
    required this.subtitle,
    required this.type,
    required this.status,
    required this.isGroup,
  });

  factory TodayLessonModel.fromJson(Map<String, dynamic> json) {
    return TodayLessonModel(
      id: json['id'],
      time: json['time'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? 'Ожидается',
      isGroup: json['is_group'] ?? true,
    );
  }
}