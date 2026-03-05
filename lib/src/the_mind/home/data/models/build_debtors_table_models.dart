import 'package:equatable/equatable.dart';

class BuildDebtorsTableModels extends Equatable {
  final String name;
  final String phone;
  final String teacher;
  final String group;
  final String balance;
  final String status;
  final bool called;

  const BuildDebtorsTableModels({
    required this.name,
    required this.phone,
    required this.teacher,
    required this.group,
    required this.balance,
    required this.status,
    required this.called,
  });

  BuildDebtorsTableModels copyWith({
    String? balance,
    String? status,
    bool? called,
  }) {
    return BuildDebtorsTableModels(
      name: name,
      phone: phone,
      teacher: teacher,
      group: group,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      called: called ?? this.called,
    );
  }

  factory BuildDebtorsTableModels.fromJson(Map<String, dynamic> json) {
    return BuildDebtorsTableModels(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      teacher: json['teacher'] ?? '',
      group: json['group'] ?? '',
      balance: json['balance'] ?? '',
      status: json['status'] ?? '',
      called: json['called'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'teacher': teacher,
      'group': group,
      'balance': balance,
      'status': status,
      'called': called,
    };
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        teacher,
        group,
        balance,
        status,
        called,
      ];
}
