import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class TargetStats extends StatelessWidget {
  const TargetStats({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    // 🔹 ДАННЫЕ (позже можно получать с backend)
    final List<MarketingSource> sources = [
      MarketingSource(title: 'Instagram Ads', count: 120, color: Colors.purple),
      MarketingSource(title: 'Telegram Channel', count: 80, color: Colors.blue),
      MarketingSource(
        title: 'Friends / Referral',
        count: 60,
        color: Colors.green,
      ),
      MarketingSource(title: 'Google Search', count: 40, color: Colors.orange),
    ];

    final int total = sources.fold(0, (sum, item) => sum + item.count);

    return SizedBox(
      height: isMobile ? 420 : 240,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Maqsadli Marketing",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "See all",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// LIST
            Expanded(
              child: ListView.separated(
                itemCount: sources.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = sources[index];
                  final percent = (item.count / total) * 100;

                  return _MarketingItem(
                    title: item.title,
                    count: item.count,
                    percent: percent,
                    color: item.color,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 ITEM UI
class _MarketingItem extends StatelessWidget {
  final String title;
  final int count;
  final double percent;
  final Color color;

  const _MarketingItem({
    required this.title,
    required this.count,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TEXT ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              "$count • ${percent.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// PROGRESS BAR
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

/// 🔹 MODEL
class MarketingSource {
  final String title;
  final int count;
  final Color color;

  MarketingSource({
    required this.title,
    required this.count,
    required this.color,
  });
}
