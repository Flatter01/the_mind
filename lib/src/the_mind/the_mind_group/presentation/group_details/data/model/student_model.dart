class StudentModel {
  final String name;
  final String phone;

  final String tariff;
  final int tariffPrice; // цена тарифа
  final int discount; // скидка в %

  final int balance;
  final int lesson;
  final int bal;

  final DateTime arrivalDate; // дата прихода
  final DateTime activationDate; // дата активации

  bool isFrozen;
  bool isPresent;

  List<Attendance> attendanceHistory;

  StudentModel({
    required this.name,
    required this.phone,
    required this.tariff,
    required this.tariffPrice,
    required this.discount,
    required this.balance,
    required this.lesson,
    required this.bal,
    required this.arrivalDate,
    required this.activationDate,
    this.isFrozen = false,
    this.isPresent = false,
    List<Attendance>? attendanceHistory,
  }) : attendanceHistory = attendanceHistory ?? [];

  /// итоговая цена с учетом скидки
  int get finalTariffPrice {
    return tariffPrice - ((tariffPrice * discount) ~/ 100);
  }
}

class Attendance {
  final String date;
  final bool? isPresent;

  Attendance({
    required this.date,
    required this.isPresent,
  });
}
