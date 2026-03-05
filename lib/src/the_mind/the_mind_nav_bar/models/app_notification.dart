enum NotificationType { message, task }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime? deadline;
  final String? fromUserId;
  final String? toUserId;
  bool isCompleted;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.deadline,
    this.fromUserId,
    this.toUserId,
    this.isCompleted = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: NotificationType.values.byName(json['type']),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'deadline': deadline?.toIso8601String(),
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'isCompleted': isCompleted,
    };
  }
}
