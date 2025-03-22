import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => StatsProvider(),
        child: const TemplateScreen(title: "Stats", child: StatsMain()));
  }
}
