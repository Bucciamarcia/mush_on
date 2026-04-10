import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/shared/text_title.dart';

import 'riverpod.dart';
import 'stripe_models.dart';

class BookingCustomFieldsMain extends ConsumerWidget {
  final List<BookingCustomField> tempBookingFields;
  final BookingManagerKennelInfo? kennelInfo;
  final Future<void> Function() onSubmit;
  const BookingCustomFieldsMain({
    super.key,
    required this.tempBookingFields,
    required this.kennelInfo,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BookingCustomFieldsEditor(fields: tempBookingFields),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: ref.watch(isBookingCustomFieldsEditedProvider)
                ? Container(
                    key: const ValueKey('unsaved_booking_custom_fields'),
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "You have unsaved changes in the booking custom fields.",
                            style: TextStyle(
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () async {
                  await onSubmit();
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text("Save changes"),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  ref.invalidate(tempBookingFieldsProvider);
                  ref
                      .read(tempBookingFieldsProvider.notifier)
                      .setInitialFields(kennelInfo?.bookingCustomFields ?? []);
                  ref
                      .read(isBookingCustomFieldsEditedProvider.notifier)
                      .setEdited(false);
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text("Reset changes"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingCustomFieldsEditor extends ConsumerWidget {
  final List<BookingCustomField> fields;
  const BookingCustomFieldsEditor({super.key, required this.fields});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTitle("Booking custom fields"),
        const SizedBox(height: 4),
        Text(
          "Add custom fields for the overall booking. Use these for information that applies to the reservation itself, like pickup point, arrival notes or preferred drop-off time.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      "Configuration",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Text(
                    "${fields.length} field${fields.length == 1 ? '' : 's'} configured",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (fields.isNotEmpty)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...fields.asMap().entries.map((entry) {
                      final index = entry.key;
                      final field = entry.value;
                      return SizedBox(
                        width: 420,
                        child: _BookingFieldDisplayWidget(
                          field: field,
                          onChanged: (v) {
                            ref
                                .read(tempBookingFieldsProvider.notifier)
                                .updateField(index, v);
                            ref
                                .read(
                                  isBookingCustomFieldsEditedProvider.notifier,
                                )
                                .setEdited(true);
                          },
                          onDeleted: () {
                            ref
                                .read(tempBookingFieldsProvider.notifier)
                                .removeField(index);
                            ref
                                .read(
                                  isBookingCustomFieldsEditedProvider.notifier,
                                )
                                .setEdited(true);
                          },
                        ),
                      );
                    }),
                  ],
                )
              else
                _BookingEmptyFieldsState(
                  onPressed: () {
                    ref.read(tempBookingFieldsProvider.notifier).addField();
                    ref
                        .read(isBookingCustomFieldsEditedProvider.notifier)
                        .setEdited(true);
                  },
                ),
              const SizedBox(height: 16),
              _BookingAddFieldButton(
                onPressed: () {
                  ref.read(tempBookingFieldsProvider.notifier).addField();
                  ref
                      .read(isBookingCustomFieldsEditedProvider.notifier)
                      .setEdited(true);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookingFieldDisplayWidget extends StatefulWidget {
  final BookingCustomField field;
  final Function(BookingCustomField) onChanged;
  final Function() onDeleted;
  const _BookingFieldDisplayWidget({
    required this.field,
    required this.onChanged,
    required this.onDeleted,
  });

  @override
  State<_BookingFieldDisplayWidget> createState() =>
      _BookingFieldDisplayWidgetState();
}

class _BookingFieldDisplayWidgetState
    extends State<_BookingFieldDisplayWidget> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late bool isRequired;
  late bool canEditName;
  late bool canEditDescription;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.field.name);
    descriptionController = TextEditingController(
      text: widget.field.description,
    );
    isRequired = widget.field.isRequired;
    canEditName = false;
    canEditDescription = false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _BookingFieldDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field.name != widget.field.name &&
        nameController.text != widget.field.name &&
        !canEditName) {
      nameController.text = widget.field.name;
    }
    if (oldWidget.field.description != widget.field.description &&
        descriptionController.text != widget.field.description &&
        !canEditDescription) {
      descriptionController.text = widget.field.description;
    }
    if (oldWidget.field.isRequired != widget.field.isRequired) {
      isRequired = widget.field.isRequired;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameController.text.isEmpty
                            ? "Unnamed field"
                            : nameController.text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isRequired ? "Required" : "Optional",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: "Delete field",
                  onPressed: () => widget.onDeleted(),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer.withValues(
                      alpha: 0.55,
                    ),
                    foregroundColor: colorScheme.error,
                  ),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _BookingEditableFieldRow(
              label: "Field name",
              controller: nameController,
              hintText: "Name",
              enabled: canEditName,
              maxLines: 1,
              onToggle: () {
                if (canEditName) {
                  widget.onChanged(
                    widget.field.copyWith(name: nameController.text),
                  );
                }
                setState(() {
                  canEditName = !canEditName;
                });
              },
            ),
            const SizedBox(height: 14),
            _BookingEditableFieldRow(
              label: "Description",
              controller: descriptionController,
              hintText: "Description",
              enabled: canEditDescription,
              maxLines: 3,
              onToggle: () {
                if (canEditDescription) {
                  widget.onChanged(
                    widget.field.copyWith(
                      description: descriptionController.text,
                    ),
                  );
                }
                setState(() {
                  canEditDescription = !canEditDescription;
                });
              },
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Required at checkout",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Customers must complete this field for the booking before checkout.",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch.adaptive(
                    value: isRequired,
                    onChanged: (v) {
                      widget.onChanged(widget.field.copyWith(isRequired: v));
                      setState(() {
                        isRequired = v;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingEditableFieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final int maxLines;
  final VoidCallback onToggle;

  const _BookingEditableFieldRow({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.maxLines,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: enabled
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.55),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                controller: controller,
                enabled: enabled,
                maxLines: maxLines,
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.tonalIcon(
              onPressed: onToggle,
              style: FilledButton.styleFrom(
                minimumSize: const Size(54, 56),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              icon: Icon(enabled ? Icons.check : Icons.edit_outlined),
              label: Text(enabled ? "Save" : "Edit"),
            ),
          ],
        ),
      ],
    );
  }
}

class _BookingAddFieldButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BookingAddFieldButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            style: BorderStyle.solid,
          ),
          color: colorScheme.surfaceContainerLowest,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.add, color: colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add new field",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Create another booking-level question for your checkout form.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingEmptyFieldsState extends StatelessWidget {
  final VoidCallback onPressed;

  const _BookingEmptyFieldsState({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onPressed,
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
          color: colorScheme.surfaceContainerLowest,
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: colorScheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "No booking custom fields yet",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Start with a question like pickup point, arrival notes or preferred drop-off details.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
