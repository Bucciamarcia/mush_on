import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/teams_history/main.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class TeamsHistoryScreen extends StatelessWidget {
  const TeamsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TeamsHistoryProvider(),
        child: const TemplateScreen(
            title: "Teams History", child: TeamsHistoryMain()));
  }
}
