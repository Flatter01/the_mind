class DashboardModel {
  final String month;
  final Cards cards;

  DashboardModel({
    required this.month,
    required this.cards,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      month: json['month'],
      cards: Cards.fromJson(json['cards']),
    );
  }
}

class Cards {
  final int activeLeads;
  final int activeStudents;
  final int debtors;
  final String totalDebt;
  final int groups;

  Cards({
    required this.activeLeads,
    required this.activeStudents,
    required this.debtors,
    required this.totalDebt,
    required this.groups,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      activeLeads: json['active_leads'],
      activeStudents: json['active_students'],
      debtors: json['debtors'],
      totalDebt: json['total_debt'],
      groups: json['groups'],
    );
  }
}