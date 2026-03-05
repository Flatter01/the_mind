import '../domain/attendance_entity.dart';
import 'attendance_api.dart';

class AttendanceRepository {
  final AttendanceApi api;

  AttendanceRepository(this.api);

  Future<List<AttendanceEntity>> fetch() async {
    final raw = await api.getLast30Days();

    return raw.map((e) {
      return AttendanceEntity(
        date: DateTime.parse(e["date"]),
        attended: e["attended"],
        absent: e["absent"],
      );
    }).toList();
  }
}
