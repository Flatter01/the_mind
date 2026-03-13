import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? width;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(0.40),
        ),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}