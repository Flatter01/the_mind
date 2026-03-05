import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class ExpenseOptionsPage extends StatefulWidget {
  const ExpenseOptionsPage({super.key});

  @override
  State<ExpenseOptionsPage> createState() => _ExpenseOptionsPageState();
}

class _ExpenseOptionsPageState extends State<ExpenseOptionsPage> {
  final priceController = TextEditingController();
  final quantityController = TextEditingController(text: "1");
  final noteController = TextEditingController();
  final newCategoryController = TextEditingController();

  String selectedCategory = 'Еда';

  final List<String> categories = [
    'Еда',
    'Транспорт',
    'Развлечения',
    'Покупки',
    'Другое',
  ];

  final Map<String, bool> categoryWithQuantity = {
    'Еда': true,
    'Транспорт': false,
    'Развлечения': false,
    'Покупки': true,
    'Другое': false,
  };

  final List<ExpenseModel> expenses = [];

  // ================= ADD EXPENSE =================

  void addExpense() {
    final price = double.tryParse(priceController.text);
    if (price == null || price <= 0) return;

    final useQty = categoryWithQuantity[selectedCategory] ?? true;
    final quantity = useQty ? int.tryParse(quantityController.text) ?? 1 : 1;

    if (!mounted) return;

    setState(() {
      expenses.add(
        ExpenseModel(
          price: price,
          quantity: quantity,
          total: price * quantity,
          category: selectedCategory,
          note: noteController.text,
          date: DateTime.now(),
        ),
      );
    });

    priceController.clear();
    quantityController.text = "1";
    noteController.clear();
  }

  // ================= ADD CATEGORY =================

  void addCategoryDialog() {
    bool withQty = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setLocal) => AlertDialog(
          title: const Text("Новая категория"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newCategoryController,
                decoration: const InputDecoration(labelText: "Название"),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("Учитывать количество"),
                  const Spacer(),
                  Switch(
                    value: withQty,
                    onChanged: (v) => setLocal(() => withQty = v),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = newCategoryController.text.trim();
                if (name.isEmpty) return;

                if (!mounted) return;

                setState(() {
                  categories.add(name);
                  categoryWithQuantity[name] = withQty;
                  selectedCategory = name;
                });

                Navigator.of(dialogContext).pop();
              },
              child: const Text("Добавить"),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ANALYTICS =================

  double get totalAmount => expenses.fold(0.0, (s, e) => s + e.total);

  Map<String, double> get analytics {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.total;
    }
    return map;
  }

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    noteController.dispose();
    newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useQty = categoryWithQuantity[selectedCategory] ?? true;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Учёт затрат",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildLeft(useQty)),
                const SizedBox(width: 24),
                Expanded(child: _buildRight()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= LEFT =================

  Widget _buildLeft(bool useQty) {
    return Column(
      children: [
        AppCard(
          child: Column(
            children: [
              _field("Цена", priceController, Icons.attach_money),
              const SizedBox(height: 12),
              if (useQty) _field("Кол-во", quantityController, Icons.numbers),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => selectedCategory = v);
                },
                decoration: _inputDecoration("Категория", Icons.category),
              ),
              const SizedBox(height: 12),
              _field(
                "Комментарий",
                noteController,
                Icons.notes,
                type: TextInputType.text,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: addExpense,
                  child: const Text("Добавить расход"),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppCard(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: addCategoryDialog,
              child: const Text("Добавить категорию"),
            ),
          ),
        ),
      ],
    );
  }

  // ================= RIGHT =================

  Widget _buildRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Text(
            "Всего: ${totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Аналитика",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...analytics.entries.map((e) {
                final double percent = totalAmount == 0
                    ? 0.0
                    : e.value / totalAmount;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key),
                    LinearProgressIndicator(value: percent),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "История",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: expenses.length,
          itemBuilder: (_, i) => _expenseTile(expenses[i]),
        ),
      ],
    );
  }

  // ================= COMMON =================

  Widget _expenseTile(ExpenseModel e) {
    return Card(
      child: ListTile(
        title: Text(e.category),
        subtitle: Text("${e.price} × ${e.quantity} • ${e.note}"),
        trailing: Text(e.total.toStringAsFixed(2)),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController c,
    IconData icon, {
    TextInputType type = TextInputType.number,
  }) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xffF7F9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class ExpenseModel {
  final double price;
  final int quantity;
  final double total;
  final String category;
  final String note;
  final DateTime date;

  ExpenseModel({
    required this.price,
    required this.quantity,
    required this.total,
    required this.category,
    required this.note,
    required this.date,
  });
}
