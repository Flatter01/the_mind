import 'package:flutter/material.dart';

import 'package:srm/src/the_mind/main_the_mind/presentation/widgets/responsive_top_area.dart';

class TheMindFunnelSection extends StatelessWidget {
  const TheMindFunnelSection({super.key});

  static const Map<String, int> _funnelCounts = {
    "So'rovlar": 120,
    "Sinov keldi": 80,
    "Sinov ketdi": 100,
    "To'lov qildi": 40,
  };

  static const List<Color> _funnelColors = [
    Color(0xFF4C6FFF),
    Color(0xFF34C759),
    Color(0xFFFF9F0A),
    Color(0xFFFF453A),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveFunnelChart(
      funnelCounts: _funnelCounts,
      funnelColors: _funnelColors,
    );
  }
}
