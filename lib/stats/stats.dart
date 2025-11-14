import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/stats/main.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(child: StatsMain(), title: "Stats");
  }
}
