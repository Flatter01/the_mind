import 'package:flutter/material.dart';

import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/home_analytics_section.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/home_finance_row.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/home_header.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/home_students_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: const [
          HomeHeader(),
          SizedBox(height: 24),
          HomeAnalyticsSection(),
          SizedBox(height: 25),
          HomeFinanceRow(),
          SizedBox(height: 25),
          HomeStudentsSection(),
        ],
      ),
    );
  }
}
