import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_record_model.dart';

class JournalModel {
  final int? id;
  final int group;
  final String groupName;
  final String lessonDate;
  final String notes;
  final List<StudentRecordModel> studentRecords;

  JournalModel({
    this.id,
    required this.group,
    required this.groupName,
    required this.lessonDate,
    required this.notes,
    required this.studentRecords,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      group: json['group'],
      groupName: json['group_name'] ?? '',
      lessonDate: json['lesson_date'] ?? '',
      notes: json['notes'] ?? '',
      studentRecords: (json['student_records'] as List)
          .map((e) => StudentRecordModel.fromJson(e))
          .toList(),
    );
  }
}
class StudentRecordModel {
  final int studentId;
  final String firstName;
  final String lastName;
  final String fullName;
  final int? classScore;
  final int? homeworkScore;
  final String attendance;
  final String absenceReason;

  StudentRecordModel({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.classScore,
    this.homeworkScore,
    required this.attendance,
    required this.absenceReason,
  });

  factory StudentRecordModel.fromJson(Map<String, dynamic> json) {
    return StudentRecordModel(
      studentId: json['student_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      classScore: json['class_score'],
      homeworkScore: json['homework_score'],
      attendance: json['attendance'] ?? 'present',
      absenceReason: json['absence_reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'class_score': classScore,
        'homework_score': homeworkScore,
        'attendance': attendance,
        'absence_reason': absenceReason,
      };

  StudentRecordModel copyWith({
    int? classScore,
    int? homeworkScore,
    String? attendance,
    String? absenceReason,
    bool clearClassScore = false,
    bool clearHomeworkScore = false,
  }) {
    return StudentRecordModel(
      studentId: studentId,
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      classScore: clearClassScore ? null : (classScore ?? this.classScore),
      homeworkScore:
          clearHomeworkScore ? null : (homeworkScore ?? this.homeworkScore),
      attendance: attendance ?? this.attendance,
      absenceReason: absenceReason ?? this.absenceReason,
    );
  }
}