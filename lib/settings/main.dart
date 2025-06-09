import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/settings/custom_fields.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:provider/provider.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context) {
    DogProvider provider = context.watch<DogProvider>();
    SettingsModel? settings = provider.settings;
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          spacing: 10,
          children: [
            TextTitle("Custom fields"),
            CustomFieldsOptions(
                customFieldTemplates: settings.customFieldTemplates),
          ],
        ),
      ),
    );
  }
}
