import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:srm/src/core/assets/assets.gen.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class BuildAnalytics extends StatelessWidget {
  final List<AnalyticsItem> items;
  final void Function(AnalyticsItem item) onTap;

  BuildAnalytics({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<Widget> icons = [
    Assets.icons.lide.svg(),
    Assets.icons.student.svg(),
    Assets.icons.loading.svg(),
    Assets.icons.icon.svg(),
  ];

  // trend: позитивный/негативный, текст
  final List<({String trend, bool isPositive})> trends = const [
    (trend: '+15% за неделю', isPositive: true),
    (trend: '+2% за месяц', isPositive: true),
    (trend: '+5 новых', isPositive: true),
    (trend: '-3% спад', isPositive: false),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ScrollConfiguration(
        behavior: const _NoScrollGlowBehavior(),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final item = items[index];
            final trend = trends[index];

            return InkWell(
              onTap: () => onTap(item),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 270,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        icons[index],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          trend.isPositive
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          size: 14,
                          color: trend.isPositive
                              ? const Color(0xFF2ECC8A)
                              : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trend.trend,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: trend.isPositive
                                ? const Color(0xFF2ECC8A)
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnalyticsItem {
  final String title;
  final String value;

  const AnalyticsItem({
    required this.title,
    required this.value,
  });
}

class _NoScrollGlowBehavior extends ScrollBehavior {
  const _NoScrollGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;

  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}