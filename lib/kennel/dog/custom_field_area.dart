import 'package:flutter/material.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/shared/text_title.dart';

class CustomFieldArea extends StatelessWidget {
  final List<CustomFieldTemplate> customFieldTemplates;
  final List<CustomField> dogCustomFields;
  const CustomFieldArea(
      {super.key,
      required this.customFieldTemplates,
      required this.dogCustomFields});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextTitle("Custom fields"),
        CustomFieldsWidget(
          customFieldTemplates: customFieldTemplates,
          dogCustomFields: dogCustomFields,
        ),
      ],
    );
  }
}

class CustomFieldsWidget extends StatelessWidget {
  final List<CustomFieldTemplate> customFieldTemplates;
  final List<CustomField> dogCustomFields;
  const CustomFieldsWidget(
      {super.key,
      required this.customFieldTemplates,
      required this.dogCustomFields});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: customFieldTemplates
          .map((t) => DogCustomFieldCard(
              customFieldTemplate: t, dogCustomFields: dogCustomFields))
          .toList(),
    );
  }
}

class DogCustomFieldCard extends StatefulWidget {
  final CustomFieldTemplate customFieldTemplate;
  final List<CustomField> dogCustomFields;
  const DogCustomFieldCard(
      {super.key,
      required this.customFieldTemplate,
      required this.dogCustomFields});

  @override
  State<DogCustomFieldCard> createState() => _DogCustomFieldCardState();
}

class _DogCustomFieldCardState extends State<DogCustomFieldCard> {
  /// Text editing controller
  late TextEditingController _controller;

  /// Whether the value has changed, and needs to be saved
  late bool hasChanged;
  @override
  void initState() {
    super.initState();
    hasChanged = false;
    _controller = TextEditingController();
    _controller.text =
        _getCurrentValue(widget.customFieldTemplate, widget.dogCustomFields) ??
            "";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        color: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.customFieldTemplate.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(isDense: true),
                      maxLines: 1,
                      style: TextStyle(fontSize: 14),
                      controller: _controller,
                      onChanged: (_) {
                        setState(() {
                          hasChanged = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: hasChanged ? () => {} : null,
                    icon: Icon(Icons.remove),
                    color: Colors.red,
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: hasChanged ? () => {} : null,
                    icon: Icon(Icons.save),
                    color: Colors.green,
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _getCurrentValue(
    CustomFieldTemplate template, List<CustomField> dogCustomFields) {
  if (dogCustomFields.any((cf) => cf.templateId == template.id)) {
    int i = dogCustomFields.indexWhere((cf) => cf.templateId == template.id);
    var customField = dogCustomFields[i];
    return switch (customField.value) {
      // If the value is a _StringValue, extract its 'value' property.
      StringValue(value: final stringVal) => stringVal,

      // If the value is an _IntValue, extract its 'value' and convert to string.
      IntValue(value: final intVal) => intVal.toString(),
    };
  } else {
    return null;
  }
}
