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
      attendance: json['attendance'],
      absenceReason: json['absence_reason'] ?? '',
    );
  }
}