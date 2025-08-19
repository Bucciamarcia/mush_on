import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/teams_history/main.dart';

class TeamsHistoryScreen extends StatelessWidget {
  const TeamsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(title: "Teams History", child: TeamsHistoryMain());
  }
}
