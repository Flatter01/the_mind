import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TariffPage extends StatefulWidget {
  const TariffPage({super.key});

  @override
  State<TariffPage> createState() => _TariffPageState();
}

class _TariffPageState extends State<TariffPage> {
  final List<Tariff> tariffs = [];

  void _openTariffDialog({Tariff? tariff, int? index}) {
    final nameController = TextEditingController(text: tariff?.name ?? '');
    final priceController = TextEditingController(
      text: tariff?.price.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tariff == null ? 'Создать тариф' : 'Редактировать тариф'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Название тарифа',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsFormatter()],
              decoration: const InputDecoration(
                labelText: 'Цена (сум)',
                hintText: '1 000 000',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final rawPrice =
                  priceController.text.replaceAll(' ', '');
              final price = double.tryParse(rawPrice) ?? 0;

              if (name.isEmpty || price <= 0) return;

              setState(() {
                if (tariff == null) {
                  tariffs.add(Tariff(name: name, price: price));
                } else {
                  tariffs[index!] = Tariff(name: name, price: price);
                }
              });

              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteTariff(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить тариф'),
        content: const Text('Ты уверен, что хочешь удалить этот тариф?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                tariffs.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTariffDialog(),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: tariffs.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'Тарифов пока нет',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: tariffs.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final tariff = tariffs[index];
                    return _TariffCard(
                      tariff: tariff,
                      onEdit: () => _openTariffDialog(
                        tariff: tariff,
                        index: index,
                      ),
                      onDelete: () => _deleteTariff(index),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _TariffCard extends StatelessWidget {
  final Tariff tariff;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TariffCard({
    required this.tariff,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tariff.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${tariff.price.toStringAsFixed(0)} сум',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Редактировать'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tariff {
  final String name;
  final double price;

  Tariff({
    required this.name,
    required this.price,
  });
}

/// Формат: 1 000 000
class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits =
        newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final positionFromEnd = digits.length - i;
      buffer.write(digits[i]);
      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write(' ');
      }
    }

    final result = buffer.toString();

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
