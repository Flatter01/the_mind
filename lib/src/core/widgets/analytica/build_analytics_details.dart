import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/cell.dart';
import 'package:srm/src/core/widgets/flexible_data_table.dart';
import 'package:srm/src/core/widgets/menu_cell.dart';

class BuildAnalyticsDetails<T> extends StatefulWidget {
  final List<T> data;
  final String title;

  // Функции для доступа к полям модели
  final String Function(T item) getName;
  final String Function(T item) getPhone;
  final String Function(T item) getTeacher;
  final String Function(T item) getGroup;
  final String Function(T item) getBalance;
  final String Function(T item) getCallStatus;
  final Color Function(T item)? getBalanceColor;
  final Color Function(T item)? getCallStatusColor;

  final void Function(T item)? onRowTap;
  final List<PopupMenuEntry<String>> Function(T item)? buildMenuItems;
  final void Function(T item, String value)? onMenuSelected;

  const BuildAnalyticsDetails({
    super.key,
    required this.data,
    required this.title,
    required this.getName,
    required this.getPhone,
    required this.getTeacher,
    required this.getGroup,
    required this.getBalance,
    required this.getCallStatus,
    this.getBalanceColor,
    this.getCallStatusColor,
    this.onRowTap,
    this.buildMenuItems,
    this.onMenuSelected,
  });

  @override
  State<BuildAnalyticsDetails> createState() =>
      _BuildAnalyticsDetailsState<T>();
}

class _BuildAnalyticsDetailsState<T> extends State<BuildAnalyticsDetails<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          const BuildSearchBar(),
          const SizedBox(height: 20),
          FlexibleDataTable<T>(
            title: widget.title,
            headers: const [
              "Ism",
              "Telefon",
              "O‘qituvchi",
              "Guruh",
              "Balans",
              "Qo‘ng‘iroq",
              "",
            ],
            data: widget.data,
            columnWidths: const {
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.6),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1.4),
              6: FixedColumnWidth(50),
            },
            onRowTap: (item, index) {
              if (widget.onRowTap != null) widget.onRowTap!(item);
            },
            rowBuilder: (item, index) => [
              Cell(widget.getName(item), bold: true),
              Cell(widget.getPhone(item)),
              Cell(widget.getTeacher(item)),
              Cell(widget.getGroup(item)),
              Cell(
                widget.getBalance(item),
                color: widget.getBalanceColor?.call(item) ?? Colors.black,
                bold: true,
              ),
              Cell(
                widget.getCallStatus(item),
                color: widget.getCallStatusColor?.call(item) ?? Colors.black,
                bold: true,
              ),
              if (widget.buildMenuItems != null)
                MenuCell(
                  menuItems: widget.buildMenuItems!(item),
                  onSelected: (value) {
                    if (widget.onMenuSelected != null)
                      widget.onMenuSelected!(item, value);
                    setState(() {}); // Обновляем UI после действия в меню
                  },
                )
              else
                const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
