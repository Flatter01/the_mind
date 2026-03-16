class StudentHistoryModel {
  final String studentId;
  final int count;
  final List<HistoryItemModel> results;

  StudentHistoryModel({
    required this.studentId,
    required this.count,
    required this.results,
  });

  factory StudentHistoryModel.fromJson(Map<String, dynamic> json) {
    return StudentHistoryModel(
      studentId: json['student_id']?.toString() ?? '',
      count: json['count'] ?? 0,
      results: (json['results'] as List? ?? [])
          .map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HistoryItemModel {
  final String type;
  final String date;
  final String title;
  final String description;
  final String icon;
  final String color;

  HistoryItemModel({
    required this.type,
    required this.date,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryItemModel(
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? 'gray',
    );
  }
}