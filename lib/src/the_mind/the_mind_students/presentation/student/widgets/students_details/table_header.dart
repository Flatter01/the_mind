import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final String text;
  const TableHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[400], letterSpacing: 0.4));
  }
}