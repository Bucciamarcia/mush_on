import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';

class EmailRemindersSettings extends ConsumerWidget {
  const EmailRemindersSettings({super.key});

  void _save(List<BookingReminder> reminders, String account) async {
    final db = FirebaseFirestore.instance;
    final path = "accounts/$account/data/bookingManager";
    final ref = db.doc(path);
    final remindersDoc = reminders.map((r) => r.toJson()).toList();
    final toSet = {"bookingReminders": remindersDoc};
    try {
      await ref.update(toSet);
    } catch (e, s) {
      BasicLogger().error(
        "Couldn't update email reminders",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Seed from the already-loaded value (listen only fires on subsequent changes).
    ref
        .watch(bookingManagerKennelInfoProvider(account: null))
        .whenData((kennelInfo) {
      ref
          .read(tempBookingRemindersProvider.notifier)
          .setInitialReminders(kennelInfo?.bookingReminders ?? []);
    });

    final reminders = ref.watch(tempBookingRemindersProvider);
    final isEdited = ref.watch(isBookingRemindersEditedProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTitle("Email reminders"),
        const SizedBox(height: 4),
        Text(
          "Configure when customers automatically receive reminder emails before their trip. Each reminder is sent at midnight on the specified day.",
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
                    "${reminders.length} reminder${reminders.length == 1 ? '' : 's'} configured",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (reminders.isNotEmpty)
                Column(
                  children: [
                    ...reminders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final reminder = entry.value;
                      return Padding(
                        key: ValueKey(reminder.uid),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ReminderRow(
                          reminder: reminder,
                          onChanged: (updated) {
                            ref
                                .read(tempBookingRemindersProvider.notifier)
                                .updateReminder(index, updated);
                            ref
                                .read(isBookingRemindersEditedProvider.notifier)
                                .setEdited(true);
                          },
                          onDeleted: () {
                            ref
                                .read(tempBookingRemindersProvider.notifier)
                                .removeReminder(index);
                            ref
                                .read(isBookingRemindersEditedProvider.notifier)
                                .setEdited(true);
                          },
                        ),
                      );
                    }),
                  ],
                )
              else
                _EmptyRemindersState(
                  onPressed: () {
                    ref
                        .read(tempBookingRemindersProvider.notifier)
                        .addReminder();
                    ref
                        .read(isBookingRemindersEditedProvider.notifier)
                        .setEdited(true);
                  },
                ),
              const SizedBox(height: 16),
              _AddReminderButton(
                onPressed: () {
                  ref.read(tempBookingRemindersProvider.notifier).addReminder();
                  ref
                      .read(isBookingRemindersEditedProvider.notifier)
                      .setEdited(true);
                },
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isEdited
              ? Container(
                  key: const ValueKey('unsaved_reminders'),
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
                          "You have unsaved changes in the email reminders.",
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
        if (isEdited) ...[
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: () async {
                  final account = ref.watch(accountProvider).value;
                  if (account == null) {
                    BasicLogger().error("Account ID not found");
                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "Error: account not found"),
                    );
                    return;
                  }
                  _save(reminders, account);
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text("Save changes"),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ref.invalidate(tempBookingRemindersProvider);
                  ref
                      .read(isBookingRemindersEditedProvider.notifier)
                      .setEdited(false);
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text("Reset changes"),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ReminderRow extends StatelessWidget {
  final BookingReminder reminder;
  final ValueChanged<BookingReminder> onChanged;
  final VoidCallback onDeleted;

  const _ReminderRow({
    required this.reminder,
    required this.onChanged,
    required this.onDeleted,
  });

  String get _label {
    if (reminder.daysBefore == 0) return "Day of the trip";
    if (reminder.daysBefore == 1) return "1 day before";
    return "${reminder.daysBefore} days before";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.mail_outline_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _DaysBeforeStepper(
            value: reminder.daysBefore,
            onChanged: (v) => onChanged(reminder.copyWith(daysBefore: v)),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: "Remove reminder",
            onPressed: onDeleted,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.errorContainer.withValues(
                alpha: 0.55,
              ),
              foregroundColor: colorScheme.error,
            ),
            icon: const Icon(Icons.delete_outline, size: 20),
          ),
        ],
      ),
    );
  }
}

class _DaysBeforeStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _DaysBeforeStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
            style: IconButton.styleFrom(
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              "$value",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => onChanged(value + 1),
            style: IconButton.styleFrom(
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddReminderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddReminderButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
                    "Add reminder",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Schedule another email before the trip.",
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

class _EmptyRemindersState extends StatelessWidget {
  final VoidCallback onPressed;

  const _EmptyRemindersState({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
                Icons.mail_outline_rounded,
                color: colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "No reminders configured",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Add a reminder to automatically notify customers before their trip.",
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
