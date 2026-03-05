class BuildStudentsTableItem {
  final int id;
  final String name;
  final String group;
  final String teacher;
  final String balance;
  final String phone;
  final String status;
  final bool called;
  final int missedLessons;

  const BuildStudentsTableItem({
    required this.id,
    required this.name,
    required this.group,
    required this.teacher,
    required this.balance,
    required this.phone,
    required this.status,
    required this.called,
    required this.missedLessons,
  });
  BuildStudentsTableItem copyWith({
    int? id,
    String? name,
    String? group,
    String? teacher,
    String? balance,
    String? phone,
    String? status,
    bool? called,
    int? missedLessons
  }) {
    return BuildStudentsTableItem(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
      teacher: teacher ?? this.teacher,
      balance: balance ?? this.balance,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      called: called ?? this.called,
      missedLessons: missedLessons ?? this.missedLessons
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "group": group,
      "teacher": teacher,
      "balance": balance,
      "phone": phone,
      "status": status,
      "called": called,
      "missedLessons" : missedLessons,
    }..removeWhere((key, value) => value == null);
  }

  factory BuildStudentsTableItem.fromJson(Map<String, dynamic> json) {
    return BuildStudentsTableItem(
      id: json["id"] ?? -1,
      name: json["name"] ?? '',
      group: json["group"] ?? '',
      teacher: json["teacher"] ?? '',
      balance: json["balance"] ?? '',
      phone: json["phone"] ?? '',
      status: json["status"] ?? '',
      called: json["called"] ?? '',
      missedLessons: json["missedLessons"]?? '',
    );
  }
}
