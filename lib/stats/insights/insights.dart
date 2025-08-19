import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'main.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(title: "Insights", child: InsightsMain());
  }
}
