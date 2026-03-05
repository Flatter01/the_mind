import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class BranchManagerPage extends StatefulWidget {
  const BranchManagerPage({super.key});

  @override
  State<BranchManagerPage> createState() => _BranchManagerPageState();
}

class _BranchManagerPageState extends State<BranchManagerPage> {
  List<String> branches = ['main'];
  String currentBranch = 'main';

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Container(
      color: AppColors.bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Управление ветками",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 24),

          /// Сетка или список в зависимости от ширины
          Expanded(
            child: isWideScreen
                ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 3,
                    ),
                    itemCount: branches.length,
                    itemBuilder: (context, index) {
                      final branch = branches[index];
                      final isSelected = branch == currentBranch;
                      return _buildBranchCard(branch, isSelected);
                    },
                  )
                : ListView.builder(
                    itemCount: branches.length,
                    itemBuilder: (context, index) {
                      final branch = branches[index];
                      final isSelected = branch == currentBranch;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _buildBranchCard(branch, isSelected),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 24),

          /// Кнопка создания ветки
          Align(
            alignment: isWideScreen ? Alignment.centerRight : Alignment.center,
            child: SizedBox(
              width: isWideScreen ? 250 : double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add,color: Colors.white,),
                label: const Text(
                  "Создать новую ветку",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showAddBranchDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(String branch, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          branch,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black87,
          ),
        ),
        trailing: branch != 'main'
            ? IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    branches.remove(branch);
                    if (currentBranch == branch) {
                      currentBranch = 'main';
                    }
                  });
                },
              )
            : null,
        onTap: () {
          setState(() {
            currentBranch = branch;
          });
        },
      ),
    );
  }

  void _showAddBranchDialog() {
    String newBranch = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Создать новую ветку"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Название ветки",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) => newBranch = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () {
              if (newBranch.trim().isEmpty) return;
              setState(() {
                branches.add(newBranch.trim());
                currentBranch = newBranch.trim();
              });
              Navigator.pop(context);
            },
            child: const Text("Создать"),
          ),
        ],
      ),
    );
  }
}
