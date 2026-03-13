import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class ResponsiveFunnelChart extends StatelessWidget {
  const ResponsiveFunnelChart({
    super.key,
    required this.funnelCounts,
    required this.funnelColors,
  });

  final Map<String, int> funnelCounts;
  final List<Color> funnelColors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _FunnelCard(funnelCounts, funnelColors)),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: _FinanceCard()),
      ],
    );
  }
}

// -------------------- ВОРОНКА ПРОДАЖ --------------------

class _FunnelCard extends StatelessWidget {
  const _FunnelCard(this.data, this.colors);

  final Map<String, int> data;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final max = data.values.isEmpty
        ? 1
        : data.values.reduce((a, b) => a > b ? a : b);

    final entries = data.entries.toList();

    // Конверсия = последний / первый * 100
    final conversionRate = entries.length >= 2
        ? (entries.last.value / entries.first.value * 100)
        : 0.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Воронка продаж',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2233),
                ),
              ),
              Text(
                'Конверсия: ${conversionRate.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFED6A2E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bars
          ...List.generate(entries.length, (i) {
            final e = entries[i];
            final progress = e.value / max;
            final percent = (progress * 100).toStringAsFixed(0);

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label + count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      Text(
                        '${e.value} ($percent%)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A2233),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Progress bar
                  Stack(
                    children: [
                      // Track
                      Container(
                        height: 28,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFED6A2E).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      // Fill
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFED6A2E)
                                .withOpacity(0.55 + progress * 0.45),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// -------------------- ФИНАНСЫ --------------------

class _FinanceCard extends StatelessWidget {
  const _FinanceCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Финансы',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2233),
            ),
          ),

          const SizedBox(height: 20),

          // Тип студентов
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ТИП СТУДЕНТОВ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StudentTypeBar(
                        label: 'Новые',
                        percent: 30,
                        color: const Color(0xFFED6A2E),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StudentTypeBar(
                        label: 'Старые',
                        percent: 70,
                        color: const Color(0xFF8A9BB8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Способ оплаты
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'СПОСОБ ОПЛАТЫ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _PaymentMethodTile(
                        icon: Icons.credit_card_outlined,
                        amount: '840 000 ₸',
                        label: 'Карта',
                        color: const Color(0xFFED6A2E),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PaymentMethodTile(
                        icon: Icons.account_balance_wallet_outlined,
                        amount: '210 000 ₸',
                        label: 'Наличные',
                        color: const Color(0xFF8A9BB8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Кнопка
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6A2E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Скачать отчет',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Тип студентов: прогресс-бар --------------------

class _StudentTypeBar extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;

  const _StudentTypeBar({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A5568),
              ),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2233),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 5,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// -------------------- Способ оплаты --------------------

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String amount;
  final String label;
  final Color color;

  const _PaymentMethodTile({
    required this.icon,
    required this.amount,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2233),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}