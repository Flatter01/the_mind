class LidModel {
  final int? id;
  final String firstName;
  final String? phone;
  final String status; // new | waiting | came | not_came | call | no_answer
  final String? source; // instagram | telegram | call | friends | ads | other
  final String? comment;
  final String? date;
  final int? branch;
  final String? destination; // group | test
  final String? gender; // male | female
  final int? course;
  final bool giveBook;

  const LidModel({
    this.id,
    required this.firstName,
    this.phone,
    required this.status,
    this.source,
    this.comment,
    this.date,
    this.branch,
    this.destination,
    this.gender,
    this.course,
    this.giveBook = false,
  });

  factory LidModel.fromJson(Map<String, dynamic> json) {
    return LidModel(
      id: json['id'] as int?,
      firstName: json['first_name'] as String? ?? '—',
      phone: json['phone'] as String?,
      status: json['status'] as String? ?? 'lead',
      source: json['source'] as String?,
      comment: json['comment'] as String?,
      date: json['date'] as String?,
      branch: json['branch'] as int?,
      destination: json['destination'] as String?,
      gender: json['gender'] as String?,
      course: json['course'] as int?,
      giveBook: json['give_book'] as bool? ?? false,
    );
  }

  // Маппинг API статус → русское название для канбана
  String get statusDisplay {
    switch (status) {
      case 'lead':
        return 'Лиды';
      case 'waiting':
        return 'В ожидании';
      case 'came':
        return 'Пришёл';
      case 'not_came':
        return 'Не пришёл';
      case 'call':
        return 'Позвонить';
      case 'no_answer':
        return 'Не ответил';
      default:
        return 'Лиды';
    }
  }

  // Маппинг русского → API статус
  static String toApiStatus(String display) {
    switch (display) {
      case 'Лиды':
        return 'lead';
      case 'В ожидании':
        return 'waiting';
      case 'Пришёл':
        return 'came';
      case 'Не пришёл':
        return 'not_came';
      case 'Позвонить':
        return 'call';
      case 'Не ответил':
        return 'no_answer';
      default:
        return 'leads';
    }
  }

  LidModel copyWith({
    int? id,
    String? firstName,
    String? phone,
    String? status,
    String? source,
    String? comment,
    String? date,
    int? branch,
    String? destination,
    String? gender,
    int? course,
    bool? giveBook,
  }) {
    return LidModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      source: source ?? this.source,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      branch: branch ?? this.branch,
      destination: destination ?? this.destination,
      gender: gender ?? this.gender,
      course: course ?? this.course,
      giveBook: giveBook ?? this.giveBook,
    );
  }
}