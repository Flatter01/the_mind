import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:srm/src/core/assets/assets.gen.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class Analytics extends StatelessWidget {
  final List<AnalyticsItem> items;
  final void Function(AnalyticsItem item) onTap;

  Analytics({
    super.key,
    required this.items,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 98,
      child: ScrollConfiguration(
        behavior: const _NoScrollGlowBehavior(),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              onTap: () => onTap(item),
              borderRadius: BorderRadius.circular(16),
              child: AppCard(
                width: 175,
                padding: const EdgeInsets.all(15),
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
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