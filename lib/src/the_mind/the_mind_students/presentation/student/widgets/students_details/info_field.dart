import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;
  final double valueFontSize;

  const InfoField({super.key, required this.label, required this.value, this.valueColor, this.valueBold = false, this.valueFontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: valueFontSize, fontWeight: valueBold ? FontWeight.w800 : FontWeight.w500, color: valueColor ?? const Color(0xFF1A2233))),
      ],
    );
  }
}
