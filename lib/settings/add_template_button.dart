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
  late TextEditingController _nameController;
  // --- STATE LIFTED UP ---
  // The list of dropdown options is now managed here, in the parent dialog.
  late List<String> _dropdownOptions;

  @override
  void initState() {
    super.initState();
    _newTypeValue = CustomFieldType.typeString;
    _nameController = TextEditingController();
    _dropdownOptions = ['']; // Start with one empty option
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addCustomField() {
    if (_nameController.text.isEmpty) {
      // Optional: Add some validation
      return;
    }

    final List<String>? finalOptions =
        _newTypeValue == CustomFieldType.typeDropdown
            // Filter out any empty options before saving
            ? _dropdownOptions.where((opt) => opt.isNotEmpty).toList()
            : null;

    // For dropdowns, ensure there are at least some options.
    if (_newTypeValue == CustomFieldType.typeDropdown &&
        (finalOptions == null || finalOptions.isEmpty)) {
      return;
    }

    widget.onCustomFieldAdded(
      CustomFieldTemplate(
        type: _newTypeValue,
        name: _nameController.text,
        id: const Uuid().v4(),
        options: finalOptions,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text("Add a custom field"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Name of the field"),
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            DropdownButton<CustomFieldType>(
              isExpanded: true,
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
            const SizedBox(height: 16),
            // Conditionally show the DropdownOptions editor
            if (_newTypeValue == CustomFieldType.typeDropdown)
              // --- REFACTORED WIDGET ---
              // Pass the state and functions to the child widget.
              DropdownOptions(
                options: _dropdownOptions,
                onOptionChanged: (index, value) {
                  // The state is held by the controller, but we update
                  // the backing list here.
                  _dropdownOptions[index] = value;
                },
                onOptionAdded: () {
                  setState(() {
                    _dropdownOptions.add('');
                  });
                },
                onOptionRemoved: (index) {
                  setState(() {
                    _dropdownOptions.removeAt(index);
                  });
                },
              )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
            foregroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.onPrimary),
          ),
          // --- CONSOLIDATED SAVE LOGIC ---
          // This single button now handles saving for all field types.
          onPressed: _addCustomField,
          child: const Text("Add custom field"),
        )
      ],
    );
  }
}

class DropdownOptions extends StatelessWidget {
  // --- SIMPLIFIED WIDGET ---
  // This widget is now stateless and only responsible for UI.
  final List<String> options;
  final Function(int, String) onOptionChanged;
  final Function(int) onOptionRemoved;
  final Function() onOptionAdded;

  const DropdownOptions({
    super.key,
    required this.options,
    required this.onOptionChanged,
    required this.onOptionRemoved,
    required this.onOptionAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Options", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            return DropDownSingleOption(
              // Using an IndexKey or ValueKey helps Flutter efficiently update the list
              key: ValueKey('option_$index'),
              initialText: option,
              onChanged: (s) => onOptionChanged(index, s),
              onRemoved: () => onOptionRemoved(index),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // --- DEDICATED ADD BUTTON ---
        // A clear, user-friendly button to add new options.
        ElevatedButton.icon(
          onPressed: onOptionAdded,
          icon: const Icon(Icons.add),
          label: const Text("Add Option"),
          style: ElevatedButton.styleFrom(
            // Make it less prominent than the main dialog buttons
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}

class DropDownSingleOption extends StatefulWidget {
  final String initialText;
  final Function(String) onChanged;
  final Function() onRemoved;
  const DropDownSingleOption({
    super.key,
    required this.initialText,
    required this.onChanged,
    required this.onRemoved,
  });

  @override
  State<DropDownSingleOption> createState() => _DropDownSingleOptionState();
}

class _DropDownSingleOptionState extends State<DropDownSingleOption> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // This lifecycle method is called when the parent widget rebuilds and provides
  // a new instance of this widget with updated properties.
  @override
  void didUpdateWidget(covariant DropDownSingleOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the initialText from the parent has changed (e.g., due to state
    // changes), update the controller's text if it differs.
    if (widget.initialText != _controller.text) {
      _controller.text = widget.initialText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(labelText: "Option"),
          ),
        ),
        IconButton(
          onPressed: widget.onRemoved,
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
        ),
      ],
    );
  }
}
