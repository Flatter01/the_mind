import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

/// =======================
/// MODEL
/// =======================

class TransactionModel {

  final String name;
  final int salary;
  final int fine;

  DateTime startDate;
  DateTime endDate;

  bool isPaid;

  TransactionModel({
    required this.name,
    required this.salary,
    required this.fine,

    DateTime? startDate,
    DateTime? endDate,

    this.isPaid = false,
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();
}

/// =======================
/// MAIN CARD
/// =======================

class RecentTransactionsCard extends StatefulWidget {

  final List<TransactionModel> data;

  const RecentTransactionsCard({
    super.key,
    required this.data,
  });

  @override
  State<RecentTransactionsCard> createState() =>
      _RecentTransactionsCardState();
}

class _RecentTransactionsCardState
    extends State<RecentTransactionsCard> {

  DateTime globalStart = DateTime.now();
  DateTime globalEnd = DateTime.now();

  Future pickStartDate() async {

    DateTime? date = await showDatePicker(

      context: context,

      initialDate: globalStart,

      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (date == null) return;

    setState(() {

      globalStart = date;

      for (var e in widget.data) {
        e.startDate = date;
      }
    });
  }

  Future pickEndDate() async {

    DateTime? date = await showDatePicker(

      context: context,

      initialDate: globalEnd,

      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (date == null) return;

    setState(() {

      globalEnd = date;

      for (var e in widget.data) {
        e.endDate = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 382,
      child: AppCard(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              "Employees",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            /// GLOBAL PERIOD

            Row(
              children: [

                const Text("Период:"),

                const SizedBox(width: 10),

                TextButton(
                  onPressed: pickStartDate,
                  child: Text(formatDate(globalStart)),
                ),

                const Text(" - "),

                TextButton(
                  onPressed: pickEndDate,
                  child: Text(formatDate(globalEnd)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {

                  return ExpandableTransactionItem(
                    item: widget.data[index],
                    refresh: () => setState(() {}),
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

/// =======================
/// EMPLOYEE ITEM
/// =======================

class ExpandableTransactionItem
    extends StatefulWidget {

  final TransactionModel item;
  final VoidCallback refresh;

  const ExpandableTransactionItem({
    super.key,
    required this.item,
    required this.refresh,
  });

  @override
  State<ExpandableTransactionItem>
      createState() =>
          _ExpandableTransactionItemState();
}

class _ExpandableTransactionItemState
    extends State<ExpandableTransactionItem> {

  bool open = false;

  Future pickStart() async {

    DateTime? d = await showDatePicker(
      context: context,
      initialDate: widget.item.startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (d == null) return;

    setState(() {
      widget.item.startDate = d;
    });

    widget.refresh();
  }

  Future pickEnd() async {

    DateTime? d = await showDatePicker(
      context: context,
      initialDate: widget.item.endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (d == null) return;

    setState(() {
      widget.item.endDate = d;
    });

    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {

    final item = widget.item;

    int salary = calculateSalaryByPeriod(
        item.salary,
        item.startDate,
        item.endDate);

    int total = salary - item.fine;

    return Column(
      children: [

        InkWell(
          onTap: () {
            setState(() {
              open = !open;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Начислено: ${formatMoney(salary)}",
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),

        if (open)

          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(
                bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                /// PERIOD PERSONAL

                Row(
                  children: [

                    TextButton(
                      onPressed: pickStart,
                      child: Text(
                        formatDate(item.startDate),
                      ),
                    ),

                    const Text(" - "),

                    TextButton(
                      onPressed: pickEnd,
                      child: Text(
                        formatDate(item.endDate),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  "Штраф: ${formatMoney(item.fine)}",
                  style: const TextStyle(
                      color: Colors.red),
                ),

                const SizedBox(height: 5),

                Text(
                  "Итого: ${formatMoney(total)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(

                  onPressed: () {

                    setState(() {
                      item.isPaid = true;
                    });

                    widget.refresh();
                  },

                  child: Text(
                    item.isPaid
                        ? "ЗП выдана"
                        : "Дал ЗП",
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// =======================
/// CALCULATE
/// =======================

int calculateSalaryByPeriod(
    int salary,
    DateTime start,
    DateTime end,
    ) {

  int days =
      end.difference(start).inDays + 1;

  int daysInMonth = 30;

  double perDay =
      salary / daysInMonth;

  return (perDay * days).round();
}

/// =======================
/// FORMAT DATE
/// =======================

String formatDate(DateTime d) {

  return "${d.day}.${d.month}.${d.year}";
}

/// =======================
/// FORMAT MONEY
/// =======================

String formatMoney(int value) {

  return value
      .toString()
      .replaceAllMapped(
    RegExp(
        r'\B(?=(\d{3})+(?!\d))'),
        (match) => ' ',
  );

}
