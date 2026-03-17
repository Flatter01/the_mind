import 'package:flutter/material.dart';

import 'package:srm/src/the_mind/home/presentation/widgets/goal_progress_card.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/today_finance_service.dart';

class HomeFinanceRow extends StatelessWidget {
  const HomeFinanceRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: GoalProgressCard()),
          SizedBox(width: 16),
          Expanded(flex: 1, child: TodayFinanceService()),
        ],
      ),
    );
  }
}
