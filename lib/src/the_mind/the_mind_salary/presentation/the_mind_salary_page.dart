import 'package:flutter/material.dart';

import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/analytica/build_analytics.dart';

import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/expense/expense_options_page.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/tariff_page.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/widgets/build_analytics_salary.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/widgets/income_debt_chart.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/widgets/recent_transactions_card.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/widgets/target_stats.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/widgets/tariffs_block.dart';

class TheMindSalaryPage extends StatefulWidget {
  const TheMindSalaryPage({super.key});

  @override
  State<TheMindSalaryPage> createState() => _TheMindSalaryPageState();
}

class _TheMindSalaryPageState extends State<TheMindSalaryPage> {
  /// ---------------- ANALYTICS ----------------
  late final List<AnalyticsItem> analyticsItems = [
    AnalyticsItem(
      title: 'Umumiy daromad',
      value: '200 000 000',
      color: const Color(0xFF0EA400),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: 'Oylik daromad',
      value: '50 000 000',
      color: const Color(0xFF0EA400),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: 'Xarajatlar',
      value: '12 500 000',
      color: const Color(0xFFFFB703),
      textColor: Colors.white,
    ),
    AnalyticsItem(
      title: 'Umumiy qarz',
      value: '2 500 000',
      color: const Color(0xFFF33232),
      textColor: Colors.white,
    ),
  ];

  /// ---------------- TRANSACTIONS ----------------
  final transactions = [
    TransactionModel(name: "Aliyev Bekzod", salary: 3000000, fine: 200000),
    TransactionModel(name: "Karimov Aziz", salary: 4500000, fine: 0),
  ];

  void _openExpenseOptions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExpenseOptionsPage()),
    );
  }

  void _openTariffs() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TariffPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 900;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              BuildAnalyticsSalary(analyticsItems: analyticsItems, onTap: () {  },),
              const SizedBox(height: 20),

              if (isMobile) ...[
                const FinanceLineChart(),
                const SizedBox(height: 16),

                TariffsBlock(onOpen: _openTariffs),
                const SizedBox(height: 16),

                RecentTransactionsCard(data: transactions),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          const FinanceLineChart(),
                          const SizedBox(height: 16),
                          TariffsBlock(onOpen: _openTariffs),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          RecentTransactionsCard(data: transactions),
                          SizedBox(height: 16),
                          TargetStats(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
