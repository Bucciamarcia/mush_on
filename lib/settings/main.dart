import 'package:flutter/material.dart';
import 'package:mush_on/settings/custom_fields.dart';
import 'package:mush_on/shared/text_title.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          spacing: 10,
          children: [
            TextTitle("Custom fields"),
            CustomFieldsOptions(),
          ],
        ),
      ),
    );
  }
}
