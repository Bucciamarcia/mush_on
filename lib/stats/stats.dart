import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'main.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(title: "Stats", child: StatsMain());
  }
}
