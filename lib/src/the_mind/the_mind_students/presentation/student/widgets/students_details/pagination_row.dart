import 'package:flutter/material.dart';

class PaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;


  const PaginationRow({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pages = <int>[];
    for (int i = 1; i <= totalPages && i <= 3; i++) {
      pages.add(i);
    }

    return Row(
      children: [
        // Назад
        _PageBtn(
          child: const Icon(Icons.chevron_left, size: 18),
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        const SizedBox(width: 6),

        // Номера страниц
        ...pages.map((p) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _PageBtn(
                isActive: p == currentPage,
                child: Text('$p', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p == currentPage ? Colors.white : Colors.black87)),
                onTap: () => onPageChanged(p),
              ),
            )),

        // Вперёд
        _PageBtn(
          child: const Icon(Icons.chevron_right, size: 18),
          onTap: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isActive;

  const _PageBtn({required this.child, this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFED6A2E) : Colors.transparent,
          border: Border.all(color: isActive ? const Color(0xFFED6A2E) : Colors.grey.withOpacity(0.25)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: IconTheme(data: IconThemeData(color: onTap == null ? Colors.grey[300] : Colors.grey[700]), child: child)),
      ),
    );
  }
}