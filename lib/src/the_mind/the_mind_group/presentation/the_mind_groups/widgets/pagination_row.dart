import 'package:flutter/material.dart';

class PaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PageBtn(
          label: 'Назад',
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        const SizedBox(width: 6),
        ...List.generate(totalPages.clamp(0, 5), (i) {
          final p = i + 1;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _PageBtn(
              label: '$p',
              isActive: p == currentPage,
              onTap: () => onPageChanged(p),
            ),
          );
        }),
        _PageBtn(
          label: 'Вперед',
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _PageBtn({required this.label, this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFED6A2E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? const Color(0xFFED6A2E)
                : Colors.grey.withOpacity(0.25),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive
                ? Colors.white
                : (onTap == null ? Colors.grey[300] : Colors.black87),
          ),
        ),
      ),
    );
  }
}
