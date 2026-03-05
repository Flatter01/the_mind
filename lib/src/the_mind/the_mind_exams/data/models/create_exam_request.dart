class CreateExamRequest {
  final String title;
  final int group;
  final String examDate;
  final String startTime;
  final String endTime;
  final int passScore;
  final bool isPercentage;
  final bool isActive;
  final String createdBy;

  CreateExamRequest({
    required this.title,
    required this.group,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.passScore,
    required this.isPercentage,
    required this.isActive,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'group': group,
        'exam_date': examDate,
        'start_time': startTime,
        'end_time': endTime,
        'pass_score': passScore,
        'is_percentage': isPercentage,
        'is_active': isActive,
        'created_by': createdBy,
      };
}