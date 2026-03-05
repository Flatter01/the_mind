import 'package:flutter/material.dart';

class BuildWorkersTable extends StatelessWidget {
  final List<BuildWorkersTableItem> workers;
  final Function(BuildWorkersTableItem) onEdit;
  final Function(BuildWorkersTableItem) onDelete;

  const BuildWorkersTable({
    super.key,
    required this.workers,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1.5),
          5: FixedColumnWidth(50),
        },
        border: const TableBorder(
          horizontalInside: BorderSide(color: Colors.black12),
        ),
        children: [_header(), ...workers.map((w) => _row(context, w))],
      ),
    );
  }

  TableRow _header() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF3F3F3)),
      children: [
        _HeaderCell("Ismi"),
        _HeaderCell("Familiyasi"),
        _HeaderCell("Roli"),
        _HeaderCell("Telefon"),
        _HeaderCell("Holati"),
        SizedBox(),
      ],
    );
  }

  TableRow _row(BuildContext context, BuildWorkersTableItem w) {
    return TableRow(
      children: [
        _clickableCell(context, w, w.name),
        _clickableCell(context, w, w.surname),
        _clickableCell(context, w, w.role),
        _clickableCell(context, w, w.phone),
        _clickableCell(
          context,
          w,
          w.isActive ? "Active" : "Inactive",
          color: w.isActive ? Colors.green : Colors.red,
          bold: true,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz),
          onSelected: (v) {
            if (v == 'edit') onEdit(w);
            if (v == 'delete') onDelete(w);
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text("Tahrirlash")),
            PopupMenuItem(value: 'delete', child: Text("O‘chirish")),
          ],
        ),
      ],
    );
  }

  Widget _clickableCell(
    BuildContext context,
    BuildWorkersTableItem worker,
    String text, {
    Color? color,
    bool bold = false,
  }) {
    return GestureDetector(
      onTap: () => _showWorkerInfo(context, worker),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: TextStyle(
            color: color ?? Colors.black87,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showWorkerInfo(BuildContext context, BuildWorkersTableItem worker) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        // ВАЖНО
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${worker.name} ${worker.surname}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // ✅ вот так
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text("Roli: ${worker.role}"),
                const SizedBox(height: 4),
                Text(
                  worker.isActive ? "Active" : "Inactive",
                  style: TextStyle(
                    color: worker.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Divider(height: 30),

                _infoRow("💰 Jami daromad", "${worker.totalEarned} so'm"),
                _infoRow("❌ Jami jarimalar", "${worker.totalFines} so'm"),
                _infoRow("📚 O‘tgan darslar", "${worker.lessonsConducted}"),
                _infoRow("⏳ Qolgan darslar", "${worker.lessonsLeft}"),
                _infoRow("📦 Umumiy darslar", "${worker.totalLessons}"),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class BuildWorkersTableItem {
  String name;
  String surname;
  String role;
  String phone;
  bool isActive;
  String? salary;

  double totalEarned;
  double totalFines;
  int lessonsConducted;
  int lessonsLeft;
  int totalLessons;

  BuildWorkersTableItem({
    required this.name,
    required this.surname,
    required this.role,
    required this.phone,
    required this.isActive,
    this.totalEarned = 0,
    this.totalFines = 0,
    this.lessonsConducted = 0,
    this.lessonsLeft = 0,
    this.totalLessons = 0,
    this.salary,
  });
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(12), child: Text(text));
  }
}
