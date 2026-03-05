class LidKursModel {
  final String kursName;
  final int kursPrice;

  LidKursModel({
    required this.kursName,
    required this.kursPrice
  });

  factory LidKursModel.fromJson(Map<String, dynamic> json) {
    return LidKursModel(
      kursName: json['kursName'] ?? '',
      kursPrice: json['kursPrice'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kursName': kursName,
      'kursPrice': kursPrice,
    };
  }

  LidKursModel copyWith({
    String? kursName,
    int? kursPrice,
  }) {
    return LidKursModel(
      kursName: kursName ?? this.kursName,
      kursPrice: kursPrice ?? this.kursPrice,
    );
  }
}
