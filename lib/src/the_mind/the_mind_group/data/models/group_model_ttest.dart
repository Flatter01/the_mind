class GroupModel {
  final String name;
  final String teacher;
  final int students;
  final GroupStatus status;
  final DateTime createdAt;
  final String lessonTime;
  final WeekType weekType;
  final String days;
  final ExmansStatus exmans;
  final GroupLevel level;
  final int levelStage;
  final int studentsLimit;

  GroupModel({
    required this.name,
    required this.teacher,
    required this.students,
    required this.status,
    required this.createdAt,
    required this.lessonTime,
    required this.weekType,
    required this.days,
    required this.exmans,
    required this.level,
    required this.levelStage,
    required this.studentsLimit,
  });

  // ---------------- COPY WITH ----------------

  GroupModel copyWith({
    String? name,
    String? teacher,
    int? students,
    GroupStatus? status,
    DateTime? createdAt,
    String? lessonTime,
    WeekType? weekType,
    String? days,
    ExmansStatus? exmans,
    GroupLevel? level,
    int? levelStage,
    int? studentsLimit,
  }) {
    return GroupModel(
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      students: students ?? this.students,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lessonTime: lessonTime ?? this.lessonTime,
      weekType: weekType ?? this.weekType,
      days: days ?? this.days,
      exmans: exmans ?? this.exmans,
      level: level ?? this.level,
      levelStage: levelStage ?? this.levelStage,
      studentsLimit: studentsLimit ?? this.studentsLimit
    );
  }

  // ---------------- FROM JSON ----------------

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      name: json['name'] ?? '',
      teacher: json['teacher'] ?? '',
      students: json['students'] ?? 0,
      status: GroupStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lessonTime: json['lessonTime'] ?? '',
      weekType: WeekType.values.firstWhere(
        (e) => e.name == json['weekType'],
      ),
      days: json['days'] ?? '',
      exmans: ExmansStatus.values.firstWhere(
        (e) => e.name == json['exmans'],
      ),
      level: GroupLevel.values.firstWhere(
        (e) => e.name == json['level'],
      ),
      levelStage: json['levelStage'] ?? 1,
      studentsLimit:  json["studentsLimit"] ?? 0
    );
  }

  // ---------------- TO JSON ----------------

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'teacher': teacher,
      'students': students,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'lessonTime': lessonTime,
      'weekType': weekType.name,
      'days': days,
      'exmans': exmans.name,
      'level': level.name,
      'levelStage': levelStage,
      'studentsLimit' : studentsLimit,
    };
  }

  // Удобный getter
  String get fullLevel => "${level.label} $levelStage";
}

enum GroupLevel { beginner, elementary, intermediate, advanced,individual}


enum GroupStatus { active, finished }

enum WeekType { odd, even }

enum ExmansStatus { open, finished }

extension GroupStatusX on GroupStatus {
  String get label => this == GroupStatus.active ? 'Active' : 'Finished';
}

extension WeekTypeX on WeekType {
  String get label => this == WeekType.odd ? 'Odd week' : 'Even week';
}

extension Exmans on ExmansStatus {
  String get label => this == ExmansStatus.open ? 'Open' : 'Finished';
}
extension GroupLevelX on GroupLevel {
  String get label {
    switch (this) {
      case GroupLevel.beginner:
        return 'Beginner';
      case GroupLevel.elementary:
        return 'Elementary';
      case GroupLevel.intermediate:
        return 'Intermediate';
      case GroupLevel.advanced:
        return 'Advanced';
      case GroupLevel.individual:
        return 'individual';  
    }
  }
}