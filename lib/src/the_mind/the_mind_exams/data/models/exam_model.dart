class ExamModel {
  final String id;
  final String title;
  final int group;
  final String groupName;
  final String teacher;
  final String teacherName;
  final String examDate;
  final String startTime;
  final String endTime;
  final int passScore;
  final bool isPercentage;
  final bool isActive;
  final String createdBy;
  final String createdByName;
  final String createdAt;
  final String updatedAt;
  final String status;
  final int resultsCount;
  final int passedCount;
  final int failedCount;

  ExamModel({
    required this.id,
    required this.title,
    required this.group,
    required this.groupName,
    required this.teacher,
    required this.teacherName,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.passScore,
    required this.isPercentage,
    required this.isActive,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.resultsCount,
    required this.passedCount,
    required this.failedCount,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      group: json['group'] ?? 0,
      groupName: json['group_name'] ?? '',
      teacher: json['teacher'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      examDate: json['exam_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      passScore: json['pass_score'] ?? 0,
      isPercentage: json['is_percentage'] ?? false,
      isActive: json['is_active'] ?? true,
      createdBy: json['created_by'] ?? '',
      createdByName: json['created_by_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      status: json['status'] ?? 'planned',
      resultsCount: json['results_count'] ?? 0,
      passedCount: json['passed_count'] ?? 0,
      failedCount: json['failed_count'] ?? 0,
    );
  }
}