class PaymentModel {
  final int? id;
  final int studentId;
  final String groupId;       // ← UUID String (API'дан "group" int келса ҳам)
  final String administratorId; // ← UUID String
  final String amount;        // ← String сақла, API String қайтаради
  final String payWith;
  final String paymentMonth;  // ← "2026-03-14" формат
  final bool checkGiven;

  // Фақат GET учун
  final String? studentName;
  final String? groupName;
  final String? administratorName;
  final String? createdAt;

  const PaymentModel({
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

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int?,
      studentId: json['student'] as int? ?? 0,
      groupId: json['group']?.toString() ?? '',
      administratorId: json['administrator'] as String? ?? '',
      amount: json['amount']?.toString() ?? '0',
      payWith: json['pay_with'] as String? ?? 'cash',
      paymentMonth: json['payment_month'] as String? ?? '',
      checkGiven: json['check_given'] as bool? ?? false,
      studentName: json['student_name'] as String?,
      groupName: json['group_name'] as String?,
      administratorName: json['administrator_name'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "student": studentId,
      "group": groupId,
      "administrator": administratorId,
      "amount": amount,
      "pay_with": payWith,
      "payment_month": paymentMonth,
      "check_given": checkGiven,
    };
  }
}