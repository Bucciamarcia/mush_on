import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/shared/text_title.dart';

class CustomFieldArea extends StatelessWidget {
  final List<CustomFieldTemplate>? customFieldTemplates;
  final List<CustomField> dogCustomFields;
  final Function(CustomField) onCustomFieldSaved;
  final Function(String) onCustomFieldDeleted;
  const CustomFieldArea(
      {super.key,
      required this.customFieldTemplates,
      required this.dogCustomFields,
      required this.onCustomFieldSaved,
      required this.onCustomFieldDeleted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextTitle("Custom fields"),
        CustomFieldsWidget(
          customFieldTemplates: customFieldTemplates,
          dogCustomFields: dogCustomFields,
          onCustomFieldSaved: (r) => onCustomFieldSaved(r),
          onCustomFieldDeleted: (templateId) =>
              onCustomFieldDeleted(templateId),
        ),
      ],
    );
  }
}

class CustomFieldsWidget extends StatelessWidget {
  final List<CustomFieldTemplate>? customFieldTemplates;
  final List<CustomField> dogCustomFields;
  final Function(CustomField) onCustomFieldSaved;
  final Function(String) onCustomFieldDeleted;
  const CustomFieldsWidget(
      {super.key,
      required this.customFieldTemplates,
      required this.dogCustomFields,
      required this.onCustomFieldSaved,
      required this.onCustomFieldDeleted});

  @override
  Widget build(BuildContext context) {
    if (customFieldTemplates != null) {
      return Wrap(
        spacing: 10,
        children: customFieldTemplates!
            .map((t) => DogCustomFieldCard(
                  customFieldTemplate: t,
                  dogCustomFields: dogCustomFields,
                  onCustomFieldSaved: (r) => onCustomFieldSaved(r),
                  onCustomFieldDeleted: (templateId) =>
                      onCustomFieldDeleted(templateId),
                ))
            .toList(),
      );
    } else {
      return CircularProgressIndicator.adaptive();
    }
  }
}

class DogCustomFieldCard extends StatefulWidget {
  final CustomFieldTemplate customFieldTemplate;
  final List<CustomField> dogCustomFields;
  final Function(CustomField) onCustomFieldSaved;
  final Function(String) onCustomFieldDeleted;
  const DogCustomFieldCard(
      {super.key,
      required this.customFieldTemplate,
      required this.dogCustomFields,
      required this.onCustomFieldSaved,
      required this.onCustomFieldDeleted});

  @override
  State<DogCustomFieldCard> createState() => _DogCustomFieldCardState();
}

class _DogCustomFieldCardState extends State<DogCustomFieldCard> {
  /// Text editing controller
  late TextEditingController _controller;
  static BasicLogger logger = BasicLogger();

  /// Whether the value has changed, and needs to be saved
  late bool hasChanged;
  @override
  void initState() {
    super.initState();
    logger.debug("TEMPLATES: ${widget.customFieldTemplate}");
    hasChanged = false;
    _controller = TextEditingController();
    _controller.text =
        _getCurrentValue(widget.customFieldTemplate, widget.dogCustomFields) ??
            "";
    logger.debug("CONTROLLER CUSTOMFIELDS: ${_controller.text}");
  }

  @override
  void didUpdateWidget(covariant DogCustomFieldCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dogCustomFields != widget.dogCustomFields) {
      _controller.text = _getCurrentValue(
              widget.customFieldTemplate, widget.dogCustomFields) ??
          "";
      logger.debug(
          "Updated controller with new custom fields: ${_controller.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                widget.customFieldTemplate.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: widget.customFieldTemplate.type ==
                            CustomFieldType.typeDropdown
                        ? DropdownMenu(
                            controller: _controller,
                            onSelected: (v) {
                              if (v != null) {
                                setState(() {
                                  _controller.text = v;
                                  hasChanged = true;
                                });
                              }
                            },
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: "", label: ""),
                              ...widget.customFieldTemplate.options!.map(
                                  (o) => DropdownMenuEntry(value: o, label: o))
                            ],
                          )
                        : TextField(
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2),
                              ),
                            ),
                            inputFormatters: _inputFormatters(),
                            keyboardType: _keyboardType(),
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
                    onPressed: hasChanged
                        ? () {
                            setState(() {
                              _controller.text = _getCurrentValue(
                                      widget.customFieldTemplate,
                                      widget.dogCustomFields) ??
                                  "";
                              hasChanged = false;
                            });
                          }
                        : null,
                    tooltip: "Cancel changes",
                    icon: Icon(Icons.remove),
                    color: Theme.of(context).colorScheme.error,
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: hasChanged
                        ? () {
                            try {
                              if (_controller.text.isEmpty) {
                                widget.onCustomFieldDeleted(
                                    widget.customFieldTemplate.id);
                              } else {
                                widget.onCustomFieldSaved(_createCustomField());
                              }
                              setState(() {
                                hasChanged = false;
                              });
                            } catch (e, s) {
                              logger.error("Couldn't change custom field",
                                  error: e, stackTrace: s);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(context,
                                      "Couldn't update the field. Reverting."));
                              _controller.text = _getCurrentValue(
                                      widget.customFieldTemplate,
                                      widget.dogCustomFields) ??
                                  "";
                              hasChanged = false;
                            }
                          }
                        : null,
                    tooltip: "Save changes",
                    icon: Icon(Icons.save),
                    color: Theme.of(context).colorScheme.primary,
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

  List<TextInputFormatter>? _inputFormatters() {
    switch (widget.customFieldTemplate.type) {
      case CustomFieldType.typeString:
        return null;
      case CustomFieldType.typeInt:
        return <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
        ];
      case CustomFieldType.typeDropdown:
        return null;
    }
  }

  TextInputType? _keyboardType() {
    switch (widget.customFieldTemplate.type) {
      case CustomFieldType.typeString:
        return null;
      case CustomFieldType.typeInt:
        return TextInputType.number;
      case CustomFieldType.typeDropdown:
        return null;
    }
  }

  CustomField _createCustomField() {
    CustomFieldValue value;
    try {
      switch (widget.customFieldTemplate.type) {
        case CustomFieldType.typeString:
          value = CustomFieldValue.stringValue(_controller.text);
        case CustomFieldType.typeInt:
          value = CustomFieldValue.intValue(int.parse(_controller.text));
        case CustomFieldType.typeDropdown:
          value = CustomFieldValue.stringValue(_controller.text);
      }
      return CustomField(
          templateId: widget.customFieldTemplate.id, value: value);
    } catch (e, s) {
      logger.error("Couldn't create custom field.", error: e, stackTrace: s);
      rethrow;
    }
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

      // If the value is a _DropdownValue, extract its value property.
      DropdownValue(value: final dropdownVal) => dropdownVal,
    };
  } else {
    return null;
  }
}
