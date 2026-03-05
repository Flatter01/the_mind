class AttendanceEntity {
  final DateTime date;
  final int attended;
  final int absent;

  AttendanceEntity({
    required this.date,
    required this.attended,
    required this.absent,
  });
}
