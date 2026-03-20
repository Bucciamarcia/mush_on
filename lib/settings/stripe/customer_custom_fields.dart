import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/shared/text_title.dart';

import 'riverpod.dart';
import 'stripe_models.dart';

class CustomerCustomFieldsMain extends ConsumerWidget {
  final List<CustomerCustomField> tempCustomerFields;
  final BookingManagerKennelInfo? kennelInfo;
  final Function() onSubmit;
  const CustomerCustomFieldsMain(
      {super.key,
      required this.tempCustomerFields,
      required this.kennelInfo,
      required this.onSubmit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomerCustomFieldsEditor(fields: tempCustomerFields),
        ref.watch(isCustomerCustomFieldsEditedProvider)
            ? const Text(
                "You have unsaved changes in the customer custom fields.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              )
            : const SizedBox.shrink(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  onSubmit();
                  ref
                      .read(isCustomerCustomFieldsEditedProvider.notifier)
                      .setEdited(false);
                },
                child: const Text("Save changes")),
            ElevatedButton(
                onPressed: () async {
                  ref.invalidate(tempCustomerFieldsProvider);
                  ref
                      .read(tempCustomerFieldsProvider.notifier)
                      .setInitialFields(kennelInfo?.customerCustomFields ?? []);
                  ref
                      .read(isCustomerCustomFieldsEditedProvider.notifier)
                      .setEdited(false);
                },
                child: const Text("Reset changes")),
          ],
        ),
      ],
    );
  }
}

class CustomerCustomFieldsEditor extends ConsumerWidget {
  final List<CustomerCustomField> fields;
  const CustomerCustomFieldsEditor({super.key, required this.fields});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const TextTitle("Customer custom fields"),
        const Text(
          "Add custom fields to the checkout page. You can use these to ask for extra information from your customers, like their dog's name or dietary restrictions. You can also make the fields required.",
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            ...fields.asMap().entries.map((entry) {
              final index = entry.key;
              final field = entry.value;
              return SizedBox(
                width: 400,
                child: FieldDisplayWidget(
                  field: field,
                  onChanged: (v) {
                    ref
                        .read(tempCustomerFieldsProvider.notifier)
                        .updateField(index, v);
                    ref
                        .read(isCustomerCustomFieldsEditedProvider.notifier)
                        .setEdited(true);
                  },
                  onDeleted: () {
                    ref
                        .read(tempCustomerFieldsProvider.notifier)
                        .removeField(index);
                    ref
                        .read(isCustomerCustomFieldsEditedProvider.notifier)
                        .setEdited(true);
                  },
                ),
              );
            }),
            SizedBox(
              width: 300,
              child: IconButton(
                  onPressed: () {
                    ref.read(tempCustomerFieldsProvider.notifier).addField();
                    ref
                        .read(isCustomerCustomFieldsEditedProvider.notifier)
                        .setEdited(true);
                  },
                  icon: const Icon(Icons.add)),
            )
          ],
        ),
      ],
    );
  }
}

class FieldDisplayWidget extends StatefulWidget {
  final CustomerCustomField field;
  final Function(CustomerCustomField) onChanged;
  final Function() onDeleted;
  const FieldDisplayWidget(
      {super.key,
      required this.field,
      required this.onChanged,
      required this.onDeleted});

  @override
  State<FieldDisplayWidget> createState() => _FieldDisplayWidgetState();
}

class _FieldDisplayWidgetState extends State<FieldDisplayWidget> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late bool isRequired;
  late bool canEditName;
  late bool canEditDescription;
  @override
  void initState() {
    nameController = TextEditingController(text: widget.field.name);
    descriptionController =
        TextEditingController(text: widget.field.description);
    isRequired = widget.field.isRequired;
    canEditName = false;
    canEditDescription = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Name"),
                    controller: nameController,
                    enabled: canEditName,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (canEditName) {
                        widget.onChanged(
                            widget.field.copyWith(name: nameController.text));
                      }
                      setState(() {
                        canEditName = !canEditName;
                      });
                    },
                    icon: canEditName
                        ? const Icon(Icons.check)
                        : const Icon(Icons.edit)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Description"),
                    controller: descriptionController,
                    maxLines: 3,
                    enabled: canEditDescription,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (canEditDescription) {
                        widget.onChanged(widget.field
                            .copyWith(description: descriptionController.text));
                      }
                      setState(() {
                        canEditDescription = !canEditDescription;
                      });
                    },
                    icon: canEditDescription
                        ? const Icon(Icons.check)
                        : const Icon(Icons.edit)),
              ],
            ),
            CheckboxListTile.adaptive(
                value: isRequired,
                title: const Text("Required"),
                onChanged: (v) {
                  if (v != null) {
                    widget.onChanged(widget.field.copyWith(isRequired: v));
                    setState(() {
                      isRequired = v;
                    });
                  }
                }),
            ElevatedButton(
                onPressed: () => widget.onDeleted(),
                child: const Text("Delete"))
          ],
        ),
      ),
    );
  }
}
