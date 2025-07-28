import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:uuid/uuid.dart';

class CustomerGroupEditorAlert extends ConsumerStatefulWidget {
  final Function(CustomerGroup) onCgEdited;
  final Function() onCustomerGroupDeleted;
  final CustomerGroup? customerGroup;
  const CustomerGroupEditorAlert({
    super.key,
    required this.onCgEdited,
    required this.onCustomerGroupDeleted,
    this.customerGroup,
  });

  @override
  ConsumerState<CustomerGroupEditorAlert> createState() =>
      _CustomerGroupEditorAlertState();
}

class _CustomerGroupEditorAlertState
    extends ConsumerState<CustomerGroupEditorAlert> {
  late String id;
  late TextEditingController nameController;
  late DateTime dateTime;
  String? selectedTeamGroupId;

  @override
  void initState() {
    super.initState();
    id = widget.customerGroup?.id ?? Uuid().v4();
    nameController = TextEditingController(text: widget.customerGroup?.name);
    dateTime = widget.customerGroup?.datetime ?? DateTimeUtils.today();
    selectedTeamGroupId = widget.customerGroup?.teamGroupId;
  }

  @override
  Widget build(BuildContext context) {
    List<TeamGroup> possibleTeamGroups =
        ref.watch(teamGroupsByDateProvider(dateTime)).value ?? [];
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      scrollable: true,
      title: Row(
        children: [
          Icon(Icons.groups, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.customerGroup == null
                  ? "Add Customer Group"
                  : "Edit Customer Group",
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              TextField(
                controller: nameController,
                onChanged: (s) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "Customer Group Name",
                  hintText: "Internal name (not shown to customers)",
                  prefixIcon: const Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          "Date & Time",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.event,
                                  size: 18, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                "Selected Date & Time:",
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat("EEEE, MMMM d, yyyy 'at' HH:mm")
                                .format(dateTime),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 12,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              initialDate: dateTime,
                              context: context,
                              firstDate: DateTimeUtils.today().subtract(
                                Duration(days: 365),
                              ),
                              lastDate: DateTimeUtils.today().add(
                                Duration(days: 365),
                              ),
                            );
                            if (newDate != null) {
                              dateTime = dateTime.copyWith(
                                year: newDate.year,
                                month: newDate.month,
                                day: newDate.day,
                              );
                              setState(() {
                                selectedTeamGroupId = null;
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text("Change Date"),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: dateTime.hour, minute: dateTime.minute),
                            );
                            if (newTime != null) {
                              dateTime = dateTime.copyWith(
                                hour: newTime.hour,
                                minute: newTime.minute,
                              );
                              setState(() {
                                selectedTeamGroupId = null;
                              });
                            }
                          },
                          icon: const Icon(Icons.access_time),
                          label: const Text("Change Time"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group_work,
                            size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          "Team Group Assignment",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    possibleTeamGroups.isEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 18,
                                    color: colorScheme.onSurfaceVariant),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "No team groups available for this date and time",
                                    style: TextStyle(
                                        color: colorScheme.onSurfaceVariant),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : DropdownMenu<TeamGroup>(
                            controller: TextEditingController(
                                text: possibleTeamGroups
                                    .firstWhereOrNull(
                                        (t) => t.id == selectedTeamGroupId)
                                    ?.name),
                            label: const Text("Select team group"),
                            dropdownMenuEntries: possibleTeamGroups
                                .map((tg) => DropdownMenuEntry(
                                    value: tg, label: tg.name))
                                .toList(),
                            onSelected: (v) {
                              setState(() {
                                selectedTeamGroupId = v?.id;
                              });
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => AlertDialog.adaptive(
              title: Text("Are you sure?"),
              content:
                  Text("Are you sure you want to delete this customer group?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Nevermind",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onCustomerGroupDeleted();
                    Navigator.of(context).popUntil(
                      ModalRoute.withName("/client_management"),
                    );
                  },
                  child: Text("Delete"),
                ),
              ],
            ),
          ),
          child: Text("Delete"),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: nameController.text.isNotEmpty
              ? () {
                  widget.onCgEdited(
                    CustomerGroup(
                      id: id,
                      datetime: dateTime,
                      name: nameController.text,
                      teamGroupId: selectedTeamGroupId,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              : null,
          icon: const Icon(Icons.save),
          label:
              Text(widget.customerGroup == null ? "Add Group" : "Save Changes"),
        ),
      ],
    );
  }
}
