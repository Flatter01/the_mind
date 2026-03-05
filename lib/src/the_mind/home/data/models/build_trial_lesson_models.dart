class BuildTrialLessonModels {
  final String name;
  final String phone;
  final String teacher;
  final String group;
  final String balance;
  final String status;
  final bool called;

  BuildTrialLessonModels({
    required this.name,
    required this.phone,
    required this.teacher,
    required this.group,
    required this.balance,
    required this.status,
    required this.called,
  });

  BuildTrialLessonModels copyWith({bool? called}) {
    return BuildTrialLessonModels(
      name: name,
      phone: phone,
      teacher: teacher,
      group: group,
      balance: balance,
      status: status,
      called: called ?? this.called,
    );
  }
}
