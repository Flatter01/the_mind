import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class TariffsBlock extends StatelessWidget {
  final VoidCallback onOpen;

  const TariffsBlock({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tariflar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(onPressed: onOpen, child: const Text("Boshqarish")),
            ],
          ),

          const SizedBox(height: 16),

          /// TARIFF LIST (preview)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) =>
                Divider(color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              return _TariffItem(title: "Individual", price: "2 000 000");
            },
          ),
        ],
      ),
    );
  }
}

class _TariffItem extends StatelessWidget {
  final String title;
  final String price;

  const _TariffItem({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            '$price сум',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
