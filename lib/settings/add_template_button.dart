import 'package:flutter/material.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:uuid/uuid.dart';

class AddTemplateButton extends StatefulWidget {
  final Function(CustomFieldTemplate) onCustomFieldAdded;
  const AddTemplateButton({super.key, required this.onCustomFieldAdded});

  @override
  State<AddTemplateButton> createState() => _AddTemplateButtonState();
}

class _AddTemplateButtonState extends State<AddTemplateButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => AddTemplateDialog(
          onCustomFieldAdded: (cf) => widget.onCustomFieldAdded(cf),
        ),
      ),
      label: Text("Add new custom field"),
      icon: Icon(Icons.add),
    );
  }
}

class AddTemplateDialog extends StatefulWidget {
  final Function(CustomFieldTemplate) onCustomFieldAdded;
  const AddTemplateDialog({super.key, required this.onCustomFieldAdded});

  @override
  State<AddTemplateDialog> createState() => _AddTemplateDialogState();
}

class _AddTemplateDialogState extends State<AddTemplateDialog> {
  late CustomFieldType _newTypeValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _newTypeValue = CustomFieldType.typeString;
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Add a custom field"),
      content: IntrinsicHeight(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("Name of the field")),
              controller: _controller,
            ),
            DropdownButton<CustomFieldType>(
              value: _newTypeValue,
              items: CustomFieldType.values
                  .map(
                    (cft) => DropdownMenuItem<CustomFieldType>(
                      value: cft,
                      child: Text(cft.showToUser),
                    ),
                  )
                  .toList(),
              onChanged: (CustomFieldType? n) {
                if (n != null) {
                  setState(() {
                    _newTypeValue = n;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.lightGreen),
          ),
          onPressed: () {
            widget.onCustomFieldAdded(
              CustomFieldTemplate(
                type: _newTypeValue,
                name: _controller.text,
                id: Uuid().v4(),
              ),
            );
            Navigator.of(context).pop();
          },
          child: Text(
            "Add custom field",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
