import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class BuildAnalytics extends StatelessWidget {
  final List<AnalyticsItem> items;
  final void Function(AnalyticsItem item) onTap;

  const BuildAnalytics({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ScrollConfiguration(
        behavior: const _NoScrollGlowBehavior(),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 20),
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () => onTap(item), // ✅ правильно
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: item.textColor.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        item.value,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: item.textColor,
                        ),
                      ),
                    ],
                  ),
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
  final Color color;
  final Color textColor;

  const AnalyticsItem({
    required this.title,
    required this.value,
    required this.color,
    required this.textColor,
  });
}

/// Убирает glow и разрешает drag мышью на вебе
class _NoScrollGlowBehavior extends ScrollBehavior {
  const _NoScrollGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
