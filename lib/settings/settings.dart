import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/settings/provider.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mainProvider = context.watch<MainProvider>();
    return ChangeNotifierProvider(
      create: (context) {
        final settingsProvider = SettingsProvider(mainProvider);
        return settingsProvider;
      },
      child: TemplateScreen(
        title: "Settings",
        child: SettingsMain(),
      ),
    );
  }
}
