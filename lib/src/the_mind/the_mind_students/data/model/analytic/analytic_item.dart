import 'package:flutter/material.dart';

class AnalyticItem {
  final String title;
  final String value;
  final String sub;
  final bool? subPositive; // true=зелёный, false=красный, null=серый
  final IconData icon;
  final Color iconColor;

  const AnalyticItem({
    required this.title,
    required this.value,
    required this.sub,
    required this.subPositive,
    required this.icon,
    required this.iconColor,
  });
}