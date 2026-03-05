import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srm/src/core/widgets/card/app_card.dart'; // для форматирования чисел

class MarketingAnalyticsPage extends StatefulWidget {
  const MarketingAnalyticsPage({super.key});

  @override
  State<MarketingAnalyticsPage> createState() => _MarketingAnalyticsPageState();
}

/// ---------- MODELS ----------

class FunnelStage {
  TextEditingController name;
  TextEditingController count;

  FunnelStage(String n, int c)
    : name = TextEditingController(text: n),
      count = TextEditingController(text: c.toString());
}

class CostItem {
  TextEditingController name;
  TextEditingController value;

  CostItem(String n, String v)
    : name = TextEditingController(text: n),
      value = TextEditingController(text: v);
}

/// ---------- PAGE ----------

class _MarketingAnalyticsPageState extends State<MarketingAnalyticsPage> {
  List<CostItem> marketingCosts = [CostItem("Таргет", "10000000")];

  final bookCost = TextEditingController(text: "40000"); // цена 1 книги
  final teacherCost = TextEditingController(
    text: "3000000",
  ); // ЗП преподавателя
  final coursePrice = TextEditingController(
    text: "800000",
  ); // цена курса за 1 студента

  List<FunnelStage> stages = [
    FunnelStage("Посещения", 15000),
    FunnelStage("Лиды", 900),
    FunnelStage("Квал", 400),
    FunnelStage("Центр", 200),
    FunnelStage("Оплата", 15),
  ];

  int leadIndex = 1;
  int visitIndex = 3;
  int paidIndex = 4;

  double parse(TextEditingController c) => double.tryParse(c.text) ?? 0;

  int parseInt(TextEditingController c) => int.tryParse(c.text) ?? 0;

  double get marketingTotal {
    double sum = 0;
    for (final c in marketingCosts) {
      sum += parse(c.value);
    }
    return sum;
  }

  double safe(double a, int b) => b == 0 ? 0 : a / b;

  // ---------- форматирование чисел ----------
  String formatMoney(double value) {
    final formatter = NumberFormat("#,###", "en_US");
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final bookPricePerStudent = parse(bookCost);
    final teacherSalary = parse(teacherCost);
    final coursePricePerStudent = parse(coursePrice);

    final leads = parseInt(stages[leadIndex].count);
    final visits = parseInt(stages[visitIndex].count);
    final paid = parseInt(stages[paidIndex].count);

    /// ---------- ДОХОД ----------
    final totalRevenue = coursePricePerStudent * paid;

    /// ---------- РАСХОДЫ ----------
    final totalBookCost = bookPricePerStudent * paid;
    final totalMarketingCost = marketingTotal;
    final totalExpenses = totalMarketingCost + totalBookCost + teacherSalary;

    /// ---------- ПРИБЫЛЬ ----------
    final double totalProfit = totalRevenue - totalExpenses;
    final double profitPerStudent = paid == 0 ? 0.0 : totalProfit / paid;

    /// ---------- СТАРЫЕ МЕТРИКИ ----------
    final cLead = safe(marketingTotal, leads);
    final cVisit = safe(marketingTotal, visits);
    final cStudent = safe(totalExpenses, paid);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            block("Маркетинг расходы", [
              ...marketingCosts.asMap().entries.map(
                (e) => costRow(e.key, e.value),
              ),
              addButton("Добавить источник", () {
                marketingCosts.add(CostItem("Источник", "0"));
                setState(() {});
              }),
            ]),

            block("Фикс расходы", [
              moneyRow("Цена книги (за 1)", bookCost),
              moneyRow("ЗП преподавателя", teacherCost),
              moneyRow("Цена курса (за 1 студента)", coursePrice),
            ]),

            block("Воронка", [
              ...stages.asMap().entries.map((e) => stageRow(e.key, e.value)),
              addButton("Добавить этап", () {
                stages.add(FunnelStage("Этап", 0));
                setState(() {});
              }),
            ]),

            block("Какие этапы считать", [
              selectStage("Лиды", leadIndex, (v) {
                leadIndex = v!;
                setState(() {});
              }),
              selectStage("Посещение", visitIndex, (v) {
                visitIndex = v!;
                setState(() {});
              }),
              selectStage("Оплата", paidIndex, (v) {
                paidIndex = v!;
                setState(() {});
              }),
            ]),

            block("Метрики", [
              metric("Стоимость лида", cLead),
              metric("Стоимость посещения", cVisit),
              metric("Стоимость студента", cStudent),

              const Divider(),

              metric("Общий доход", totalRevenue),
              metric("Общие расходы", totalExpenses),
              metric("Чистая прибыль", totalProfit),
              metric("Прибыль с 1 студента", profitPerStudent),
            ]),
          ],
        ),
      ),
    );
  }

  /// ---------- UI ----------

  Widget block(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget addButton(String t, VoidCallback f) => ElevatedButton.icon(
    onPressed: f,
    icon: const Icon(Icons.add),
    label: Text(t),
  );

  Widget moneyRow(String t, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: input(t),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget costRow(int i, CostItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: item.name,
              decoration: input("Источник"),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 160,
            child: TextField(
              controller: item.value,
              keyboardType: TextInputType.number,
              decoration: input("Сумма"),
              onChanged: (_) => setState(() {}),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              marketingCosts.removeAt(i);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget stageRow(int i, FunnelStage s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(controller: s.name, decoration: input("Этап")),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: TextField(
              controller: s.count,
              keyboardType: TextInputType.number,
              decoration: input("Кол-во"),
              onChanged: (_) => setState(() {}),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              stages.removeAt(i);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget selectStage(String t, int val, ValueChanged<int?> on) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        value: val,
        items: List.generate(
          stages.length,
          (i) => DropdownMenuItem(value: i, child: Text(stages[i].name.text)),
        ),
        onChanged: on,
        decoration: input(t),
      ),
    );
  }

  Widget metric(String t, double v) {
    return ListTile(
      title: Text(t),
      trailing: Text(
        formatMoney(v),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration input(String t) => InputDecoration(
    labelText: t,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );
}
