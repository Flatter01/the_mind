class PaymentModel {
  final int? id; // есть только в GET
  final int studentId;
  final int groupId;
  final String administratorId;
  final double amount;
  final String payWith;
  final DateTime paymentMonth;
  final bool checkGiven;

  final String? studentName;        // только для GET
  final String? groupName;          // только для GET
  final String? administratorName;  // только для GET
  final DateTime? createdAt;        // только для GET

  PaymentModel({
    this.id,
    required this.studentId,
    required this.groupId,
    required this.administratorId,
    required this.amount,
    required this.payWith,
    required this.paymentMonth,
    required this.checkGiven,
    this.studentName,
    this.groupName,
    this.administratorName,
    this.createdAt,
  });

  // Для GET
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      studentId: json['student'],
      groupId: json['group'],
      administratorId: json['administrator'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      payWith: json['pay_with'] ?? '',
      paymentMonth: DateTime.parse(json['payment_month']),
      checkGiven: json['check_given'] ?? false,
      studentName: json['student_name'],
      groupName: json['group_name'],
      administratorName: json['administrator_name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  // Для POST
  Map<String, dynamic> toJson() {
    return {
      "student": studentId,
      "group": groupId,
      "administrator": administratorId,
      "amount": amount.toString(),
      "pay_with": payWith,
      "payment_month": paymentMonth.toIso8601String().split('T')[0],
      "check_given": checkGiven,
    };
  }
}