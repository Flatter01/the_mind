class LessonModel {
  String date;
  bool confirmed;
  List<StudentVisit> visits;

  LessonModel({
    required this.date,
    this.confirmed = false,
    required this.visits,
  });
}

class StudentVisit {
  final String name;
  bool present;

  StudentVisit({
    required this.name,
    this.present = false,
  });
}
