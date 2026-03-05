import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';

class FlexibleDataTable<T> extends StatelessWidget {
  final String? title;
  final List<String> headers;
  final List<T> data;
  final Map<int, TableColumnWidth>? columnWidths;
  final List<Widget> Function(T item, int index) rowBuilder;
  final void Function(T item, int index)? onRowTap;
  final Widget? emptyWidget;
  final EdgeInsets cellPadding;

  const FlexibleDataTable({
    super.key,
    this.title,
    required this.headers,
    required this.data,
    required this.rowBuilder,
    this.columnWidths,
    this.onRowTap,
    this.emptyWidget,
    this.cellPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    if (isMobile) {
      return _buildMobile();
    } else {
      return _buildWeb();
    }
  }

  /// ================= WEB =================
  Widget _buildWeb() {
    final rows = <TableRow>[];

    /// HEADER
    rows.add(
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
        children: headers
            .map(
              (h) => Padding(
                padding: cellPadding,
                child: Text(
                  h,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    /// DATA
    if (data.isEmpty) {
      rows.add(
        TableRow(
          children: List.generate(
            headers.length,
            (i) => Padding(
              padding: cellPadding,
              child: i == 0
                  ? (emptyWidget ??
                      const Text(
                        "Нет данных",
                        style: TextStyle(color: Colors.grey),
                      ))
                  : const SizedBox(),
            ),
          ),
        ),
      );
    } else {
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        final cells = rowBuilder(item, i);

        if (cells.length != headers.length) {
          throw Exception(
              'rowBuilder вернул ${cells.length}, headers = ${headers.length}');
        }

        rows.add(
          TableRow(
            children: cells.map((cell) {
              final content = Padding(padding: cellPadding, child: cell);

              if (onRowTap == null) return content;

              return InkWell(onTap: () => onRowTap!(item, i), child: content);
            }).toList(),
          ),
        );
      }
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
          ],
          Table(
            columnWidths: columnWidths,
            border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.black12),
            ),
            children: rows,
          ),
        ],
      ),
    );
  }

  /// ================= MOBILE =================
  Widget _buildMobile() {
    if (data.isEmpty) {
      return emptyWidget ??
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Нет данных",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
    }

    return Column(
      children: List.generate(data.length, (index) {
        final item = data[index];
        final cells = rowBuilder(item, index);

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black12,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onRowTap == null ? null : () => onRowTap!(item, index),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Row: Name + Menu
                  Row(
                    children: [
                      Expanded(
                        child: cells[0], // Name
                      ),
                      cells.last, // Menu
                    ],
                  ),
                  const SizedBox(height: 6),

                  /// Phone
                  if (cells.length > 1) cells[1],
                  const SizedBox(height: 12),

                  /// Info chips
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (cells.length > 2) _chip(headers[2], cells[2]),
                      if (cells.length > 3) _chip(headers[3], cells[3]),
                      if (cells.length > 4) _chip(headers[4], cells[4]),
                      if (cells.length > 5) _chip(headers[5], cells[5]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _chip(String label, Widget value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          value,
        ],
      ),
    );
  }
}