class GroupModel {
  final int? id;
  final String? name;
  final String? level;
  final String? levelDisplay;
  final String? teacher;      // UUID String
  final String? teacherName;
  final String? weekDays;     // API "string" қайтаради
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


  const GroupModel({
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
      id: json['id'] as int?,
      name: json['name'] as String?,
      level: json['level'] as String?,
      levelDisplay: json['level_display'] as String?,
      teacher: json['teacher'] as String?,       // UUID
      teacherName: json['teacher_name'] as String?,
      weekDays: json['week_days']?.toString(),   // String сақла
      studentCount: json['student_count'] as int?,
      room: json['room'] as int?,
      roomName: json['room_name'] as String?,
      price: json['price']?.toString(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "level": level,
        "teacher": teacher,
        "room": room,
        "price": price,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime,
        "is_active": isActive,
      };
}