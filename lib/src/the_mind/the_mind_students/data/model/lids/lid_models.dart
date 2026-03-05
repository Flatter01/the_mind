class LidModels {
  String name;
  String phone;
  String group;
  String date;
  String status;
  String gender;

  /// ✅ новое
  String course;
  String comment;

  String branch;
  String tariff;
  String day;

  LidModels({
    required this.name,
    required this.phone,
    required this.group,
    required this.date,
    required this.status,
    required this.branch,
    required this.tariff,
    required this.day,
    this.gender = '',
    this.course = '',
    this.comment = '',
  });
}
