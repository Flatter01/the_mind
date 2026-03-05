import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class AnalyticsGrid extends StatelessWidget {
  const AnalyticsGrid({super.key});

  @override
  Widget build(BuildContext context) {

    /// пример данных
    int activeStudentsNow = 142;
    int activeStudentsBefore = 130;

    int diff = activeStudentsNow - activeStudentsBefore;
    bool isGrowing = diff >= 0;

    final items = [

      /// ОСНОВНЫЕ
      _Item("Общие лиды", "320", Icons.people_alt_rounded, Color(0xFF4C6FFF)),
      _Item("Запись на консул.", "120", Icons.edit_calendar, Color(0xFF34C759)),
      _Item("Посещения", "210", Icons.how_to_reg, Color(0xFF00C2FF)),
      _Item("Пробные уроки", "65", Icons.school_rounded, Color(0xFFFF9F0A)),

      /// ОПЛАТЫ
      _Item("Новые оплаты", "48", Icons.trending_up, Color(0xFF7B61FF)),
      _Item("Старые оплаты", "31", Icons.history, Color(0xFF6E6E73)),
      _Item("Карта", "52", Icons.credit_card, Color(0xFF0A84FF)),
      _Item("Наличные", "27", Icons.payments, Color(0xFF30D158)),

      /// СТУДЕНТЫ
      _Item("Ушли", "12", Icons.logout, Color(0xFFFF453A)),
      _Item("Старые студенты", "96", Icons.groups, Color(0xFF5E5CE6)),

      _Item("Из пробного оплатили", "18",
          Icons.check_circle, Color(0xFF30D158)),

      _Item(
        "Активные студенты",
        "$activeStudentsNow (${isGrowing ? "+" : ""}$diff)",
        isGrowing
            ? Icons.trending_up
            : Icons.trending_down,
        isGrowing
            ? Colors.green
            : Colors.red,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.9,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return AppCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Item {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _Item(this.title, this.value, this.icon, this.color);
}