import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/the_mind/the_mind_workers/widgets/add_worker_dialog.dart';
import 'package:srm/src/the_mind/the_mind_workers/widgets/build_workers_table.dart';
import 'package:srm/src/the_mind/the_mind_workers/widgets/edit_worker_dialog.dart';

class TheMindWorkersPage extends StatefulWidget {
  const TheMindWorkersPage({super.key});

  @override
  State<TheMindWorkersPage> createState() => _TheMindWorkersPageState();
}

class _TheMindWorkersPageState extends State<TheMindWorkersPage> {
  final List<BuildWorkersTableItem> _workers = [
    BuildWorkersTableItem(
      name: "Ali",
      surname: "Karimov",
      role: "Teacher",
      phone: "+998 90 123 45 67",
      isActive: true,
    ),
    BuildWorkersTableItem(
      name: "Dilshod",
      surname: "Akbarov",
      role: "Manager",
      phone: "+998 91 765 43 21",
      isActive: false,
    ),
  ];

  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _workers.where((w) {
      final q = _search.toLowerCase();
      return w.name.toLowerCase().contains(q) ||
          w.surname.toLowerCase().contains(q) ||
          w.role.toLowerCase().contains(q) ||
          w.phone.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final isWide = constraints.maxWidth > 1000; // web large screens

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [

              Row(
                children: [
                  Expanded(
                    child: BuildSearchBar(
                      onChanged: (v) => setState(() => _search = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _addButton(),
                ],
              ),

              const SizedBox(height: 20),

              /// ✅ таблица НЕ растягивается
              BuildWorkersTable(
                workers: filtered,
                onEdit: _openEditDialog,
                onDelete: _deleteWorker,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _addButton() {
    return InkWell(
      onTap: _openAddDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 6),
            Text("Add worker", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddWorkerDialog(
        onAdd: (worker) {
          setState(() => _workers.add(worker));
        },
      ),
    );
  }

  void _openEditDialog(BuildWorkersTableItem worker) {
    showDialog(
      context: context,
      builder: (_) =>
          EditWorkerDialog(worker: worker, onSave: () => setState(() {})),
    );
  }

  void _deleteWorker(BuildWorkersTableItem worker) {
    setState(() => _workers.remove(worker));
  }
}
