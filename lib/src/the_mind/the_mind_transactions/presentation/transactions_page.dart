import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? selectedRange;

  List<TransactionModel> allTransactions = [
    TransactionModel(
      firstName: "Ali",
      lastName: "Karimov",
      group: "Flutter 1",
      method: "Naqd",
      amount: 120000,
      date: DateTime.now(),
    ),
    TransactionModel(
      firstName: "Madina",
      lastName: "Saidova",
      group: "Backend",
      method: "Karta",
      amount: 200000,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TransactionModel(
      firstName: "John",
      lastName: "Doe",
      group: "UI/UX",
      method: "Naqd",
      amount: 80000,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<TransactionModel> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    filteredTransactions = allTransactions;
  }

  // -----------------------
  // DATE PICKER
  // -----------------------
  Future<void> _pickDate() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
      initialDateRange: selectedRange,
      saveText: "Tanlash",
      builder: (context, child) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 520),
          child: Theme(
            data: Theme.of(context).copyWith(
              dialogTheme: const DialogThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          ),
        ),
      ),
    );

    if (picked != null) {
      selectedRange = picked;
      _applyFilters();
    }
  }

  void _clearDate() {
    selectedRange = null;
    _applyFilters();
  }

  // -----------------------
  // SEARCH & FILTER
  // -----------------------
  void _search(String value) {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredTransactions = allTransactions.where((e) {
        final text = "${e.firstName} ${e.lastName} ${e.group}".toLowerCase();
        final matchSearch = text.contains(query);

        final matchDate = selectedRange == null
            ? true
            : (e.date.isAfter(
                    selectedRange!.start.subtract(const Duration(days: 1)),
                  ) &&
                  e.date.isBefore(
                    selectedRange!.end.add(const Duration(days: 1)),
                  ));

        return matchSearch && matchDate;
      }).toList();
    });
  }

  // -----------------------
  // STATS
  // -----------------------
  int get totalAmount =>
      filteredTransactions.fold(0, (sum, e) => sum + e.amount);

  int get todayAmount {
    final now = DateTime.now();
    return filteredTransactions
        .where(
          (e) =>
              e.date.year == now.year &&
              e.date.month == now.month &&
              e.date.day == now.day,
        )
        .fold(0, (sum, e) => sum + e.amount);
  }

  int get monthAmount {
    final now = DateTime.now();
    return filteredTransactions
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0, (sum, e) => sum + e.amount);
  }

  // -----------------------
  // CASH & CARD
  // -----------------------
  int get cashAmount =>
      filteredTransactions
          .where((e) => e.method.toLowerCase() == "naqd")
          .fold(0, (sum, e) => sum + e.amount);

  int get cardAmount =>
      filteredTransactions
          .where((e) => e.method.toLowerCase() == "karta")
          .fold(0, (sum, e) => sum + e.amount);

  // -----------------------
  // UI
  // -----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          _buildStats(),
          _buildSearchWithDate(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _statCard("Bugun", todayAmount),
              const SizedBox(width: 10),
              _statCard("Oy", monthAmount),
              const SizedBox(width: 10),
              _statCard("Tanlangan", totalAmount),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _statCard("Naqd", cashAmount),
              const SizedBox(width: 10),
              _statCard("Karta", cardAmount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, int amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              "${NumberFormat('#,###').format(amount)} so'm",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWithDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: BuildSearchBar(
              onChanged: _search,
              controller: _searchController,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: _pickDate,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    selectedRange == null
                        ? "Period tanlash"
                        : "${DateFormat("dd.MM.yyyy").format(selectedRange!.start)}"
                              " — "
                              "${DateFormat("dd.MM.yyyy").format(selectedRange!.end)}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          if (selectedRange != null) ...[
            const SizedBox(width: 6),
            IconButton(icon: const Icon(Icons.close), onPressed: _clearDate),
          ],
        ],
      ),
    );
  }

  Widget _buildList() {
    if (filteredTransactions.isEmpty) {
      return const Center(child: Text("To‘lovlar topilmadi"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final t = filteredTransactions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${t.firstName} ${t.lastName}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text("Guruh: ${t.group}"),
              Text("To‘lov turi: ${t.method}"),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${NumberFormat('#,###').format(t.amount)} so'm",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat("dd.MM.yyyy HH:mm").format(t.date),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// --------------------
// MODEL
// --------------------
class TransactionModel {
  final String firstName;
  final String lastName;
  final String group;
  final String method;
  final int amount;
  final DateTime date;

  TransactionModel({
    required this.firstName,
    required this.lastName,
    required this.group,
    required this.method,
    required this.amount,
    required this.date,
  });
}