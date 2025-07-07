import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "Settings",
      child: SettingsMain(),
    );
  }
}
