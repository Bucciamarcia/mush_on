import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'provider.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return ChangeNotifierProvider(
        create: (context) => HealthProvider(provider),
        child: TemplateScreen(title: "Health dashboard", child: HealthMain()));
  }
}
