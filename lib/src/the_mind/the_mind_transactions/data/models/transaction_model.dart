class TransactionModel {
  final int id;
  final String studentName;
  final String groupName;
  final String amount;
  final String payWith;
  final String payWithDisplay;
  final String createdAt;

  const TransactionModel({
    required this.id,
    required this.studentName,
    required this.groupName,
    required this.amount,
    required this.payWith,
    required this.payWithDisplay,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int? ?? 0,
      studentName: json['student_name'] as String? ?? '—',
      groupName: json['group_name'] as String? ?? '—',
      amount: json['amount']?.toString() ?? '0',
      payWith: json['pay_with'] as String? ?? '',
      payWithDisplay: json['pay_with_display'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  // "2026-03-17T10:42:03.933660Z" → "17.03.2026"
  String get dateFormatted {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}.'
          '${dt.month.toString().padLeft(2, '0')}.'
          '${dt.year}';
    } catch (_) {
      return createdAt;
    }
  }

  // "2026-03-17T10:42:03.933660Z" → "10:42"
  String get timeFormatted {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  // "500000.00" → 500000
  int get amountInt {
    return double.tryParse(amount)?.toInt() ?? 0;
  }

  // "500000.00" → "500 000 сум"
  String get amountFormatted {
    final n = amountInt;
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${buf.toString()} сум';
  }
}