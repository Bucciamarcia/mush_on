import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/settings/add_template_button.dart';

class CustomFieldsOptions extends StatelessWidget {
  final List<CustomFieldTemplate> customFieldTemplates;
  final Function(CustomFieldTemplate) onCustomFieldAdded;
  final Function(String) onCustomFieldDeleted;
  const CustomFieldsOptions(
      {super.key,
      required this.customFieldTemplates,
      required this.onCustomFieldAdded,
      required this.onCustomFieldDeleted});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Wrap(
          spacing: 10,
          children: customFieldTemplates
              .map((t) => CustomFieldTemplateCard(
                    template: t,
                    onCustomFieldDeleted: () => onCustomFieldDeleted(t.id),
                  ))
              .toList(),
        ),
        AddTemplateButton(
          onCustomFieldAdded: (cf) => onCustomFieldAdded(cf),
        ),
      ],
    );
  }
}

class CustomFieldTemplateCard extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final CustomFieldTemplate template;
  final Function() onCustomFieldDeleted;
  const CustomFieldTemplateCard(
      {super.key, required this.template, required this.onCustomFieldDeleted});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(template.name),
      onDeleted: () => onCustomFieldDeleted(),
    );
  }
}
