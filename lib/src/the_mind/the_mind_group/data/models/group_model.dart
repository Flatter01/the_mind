class GroupModel {
  final int? id;
  final String? name;
  final String? level;
  final String? levelDisplay;
  final String? teacher;
  final String? teacherName;
  final String? weekDays;
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

  // ✅ Парсим week_days из любого формата API
  // API может вернуть:
  //   - List объектов: [{id: 2, name: "Wednesday"}, ...]
  //   - Строку: "1,3,5"
  //   - null
  static String? _parseWeekDays(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw;
    if (raw is List) {
      return raw
          .map((e) {
            if (e is Map) {
              // берём name если есть, иначе id
              return e['name']?.toString() ?? e['id']?.toString() ?? '';
            }
            return e.toString();
          })
          .where((s) => s.isNotEmpty)
          .join(',');
    }
    return raw.toString();
  }

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      level: json['level'] as String?,
      levelDisplay: json['level_display'] as String?,
      teacher: json['teacher'] as String?,
      teacherName: json['teacher_name'] as String?,
      weekDays: _parseWeekDays(json['week_days']), // ✅ умный парсинг
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
        'name': name,
        'level': level,
        'teacher': teacher,
        'room': room,
        'price': price,
        'start_date': startDate,
        'end_date': endDate,
        'start_time': startTime,
        'end_time': endTime,
        'is_active': isActive,
      };
}