import 'package:flutter/material.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:provider/provider.dart';

class HealthMain extends StatelessWidget {
  const HealthMain({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    HealthProvider healthProvider = context.watch<HealthProvider>();
    MainProvider mainProvider = context.watch<MainProvider>();
    return ListView(
      children: [
        TextTitle("Health overview"),
        Card(
          color: colorScheme.surfaceContainer,
          child: Column(
            children: [],
          ),
        )
      ],
    );
  }
}
