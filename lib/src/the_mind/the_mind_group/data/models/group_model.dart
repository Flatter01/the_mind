class GroupModel {
  final int? id;
  final String? name;
  final String? level;
  final String? levelDisplay;
  final String? teacher; // если приходит строка
  final String? teacherName;
  final List<dynamic>? weekDays;
  final int? studentCount;
  final int? room;
  final String? roomName;
  final String? price;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final bool? isActive;
  final String? createdAt;

  GroupModel({
    this.id,
    this.name,
    this.level,
    this.levelDisplay,
    this.teacher,
    this.teacherName,
    this.weekDays,
    this.studentCount,
    this.room,
    this.roomName,
    this.price,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.isActive,
    this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      level: json['level'],
      levelDisplay: json['level_display'],
      teacher: json['teacher'] is String ? json['teacher'] : null,
      teacherName: json['teacher_name'],
      weekDays: json['week_days'] is List ? List<dynamic>.from(json['week_days']) : null,
      studentCount: json['student_count'],
      room: json['room'],
      roomName: json['room_name'],
      price: json['price'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "level": level,
      "teacher": teacher,
      "week_days": weekDays,
      "room": room,
      "price": price,
      "start_date": startDate,
      "end_date": endDate,
      "start_time": startTime,
      "end_time": endTime,
      "is_active": isActive,
    };
  }
}