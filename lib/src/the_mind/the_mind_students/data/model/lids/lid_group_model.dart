class LidGroupModel {
  final String id;
  final String name;
  final String teacherName;
  final int studentsCount;
  final bool isExamNow;
  final String lessonTime;
  final bool evenWeeks;
  final int daysPerWeek;

  LidGroupModel({
    required this.id,
    required this.name,
    required this.teacherName,
    required this.studentsCount,
    required this.isExamNow,
    required this.lessonTime,
    required this.evenWeeks,
    required this.daysPerWeek,
  });

  factory LidGroupModel.fromJson(Map<String, dynamic> json) {
    return LidGroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      teacherName: json['teacherName'] ?? '',
      studentsCount: json['studentsCount'] ?? 0,
      isExamNow: json['isExamNow'] ?? false,
      lessonTime: json['lessonTime'] ?? '',
      evenWeeks: json['evenWeeks'] ?? true,
      daysPerWeek: json['daysPerWeek'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacherName': teacherName,
      'studentsCount': studentsCount,
      'isExamNow': isExamNow,
      'lessonTime': lessonTime,
      'evenWeeks': evenWeeks,
      'daysPerWeek': daysPerWeek,
    };
  }

  LidGroupModel copyWith({
    String? id,
    String? name,
    String? teacherName,
    int? studentsCount,
    bool? isExamNow,
    String? lessonTime,
    bool? evenWeeks,
    int? daysPerWeek,
  }) {
    return LidGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      teacherName: teacherName ?? this.teacherName,
      studentsCount: studentsCount ?? this.studentsCount,
      isExamNow: isExamNow ?? this.isExamNow,
      lessonTime: lessonTime ?? this.lessonTime,
      evenWeeks: evenWeeks ?? this.evenWeeks,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    );
  }
}
