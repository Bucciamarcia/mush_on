import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/text_title.dart';

class NowTabView extends StatelessWidget {
  final List<Task> tasks;
  final List<Dog> dogs;
  final Function(Task) onTaskEdited;
  const NowTabView(
      {super.key,
      required this.tasks,
      required this.onTaskEdited,
      required this.dogs});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Wrap(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                TextTitle("Today"),
                ...tasks.dueTodayOrOverdue.urgentFirst().map(
                      (t) => TaskElement(
                        key: ValueKey(t.id),
                        dog: dogs.firstWhereOrNull((d) => d.id == t.dogId),
                        task: t,
                        onTaskEdited: (t) => onTaskEdited(t),
                      ),
                    ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                TextTitle("Tasks with no expiration"),
                ...tasks.notDone.dontExpire.urgentFirst().map(
                      (t) => TaskElement(
                        key: ValueKey(t.id),
                        dog: dogs.firstWhereOrNull((d) => d.id == t.dogId),
                        task: t,
                        onTaskEdited: (t) => onTaskEdited(t),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskElement extends StatelessWidget {
  final Task task;
  final Dog? dog;
  final Function(Task) onTaskEdited;
  const TaskElement(
      {super.key, required this.task, required this.onTaskEdited, this.dog});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check task state
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isExpired = task.expiration != null &&
        DateTime(task.expiration!.year, task.expiration!.month,
                task.expiration!.day)
            .isBefore(today);

    // Determine the appropriate color based on task state
    Color? getCheckboxColor() {
      if (task.isDone) {
        return colorScheme.primary;
      }
      if (isExpired) {
        return colorScheme.error;
      }
      if (task.isUrgent) {
        return colorScheme.tertiary;
      }
      return colorScheme.primary;
    }

    // Get text color for title/subtitle based on state
    Color? getTitleColor() {
      if (task.isDone) {
        return colorScheme.onSurface.withValues(alpha: 0.6);
      }
      if (isExpired) {
        return colorScheme.error;
      }
      return null;
    }

    // Get font weight based on urgency
    FontWeight? getFontWeight() {
      return task.isUrgent && !task.isDone ? FontWeight.bold : null;
    }

    // Get the appropriate icon based on priority
    Widget? getLeadingIcon() {
      // Priority: overdue > urgent > done
      if (isExpired && !task.isDone) {
        return Icon(
          Icons.warning_amber_rounded,
          color: colorScheme.error,
          size: 24,
        );
      }
      if (task.isUrgent && !task.isDone) {
        return Icon(
          Icons.priority_high_rounded,
          color: colorScheme.tertiary,
          size: 24,
        );
      }
      if (task.isDone) {
        return Icon(
          Icons.check_circle_outline_rounded,
          color: colorScheme.primary.withValues(alpha: 0.6),
          size: 24,
        );
      }
      // Default icon for regular tasks
      return Icon(
        Icons.circle_outlined,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        size: 24,
      );
    }

    // Build subtitle with description and additional info
    Widget? buildSubtitle() {
      final List<InlineSpan> spans = [];

      // Always show description first if present
      if (task.description.isNotEmpty) {
        spans.add(TextSpan(
          text: task.description,
          style: TextStyle(
            color: getTitleColor()?.withValues(alpha: 0.8) ??
                colorScheme.onSurfaceVariant,
            fontWeight: task.isUrgent && !task.isDone ? FontWeight.w500 : null,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ));
      }

      // Build metadata parts
      final metaParts = <String>[];

      // Add expiration date if present
      if (task.expiration != null) {
        final formatter = DateFormat('MMM d');
        final expirationText = formatter.format(task.expiration!);

        if (isExpired && !task.isDone) {
          metaParts.add('Overdue: $expirationText');
        } else {
          metaParts.add('Due: $expirationText');
        }
      }

      // Add dog indicator if dogId is present
      if (task.dogId != null) {
        metaParts.add('🐕 - ${dog?.name ?? ""}');
      }

      // Add recurring info if present
      if (task.recurring != RecurringType.none) {
        metaParts.add('🔄 ${task.recurring.name}');
      }

      // Add metadata as a separate span with different styling
      if (metaParts.isNotEmpty) {
        if (spans.isNotEmpty) {
          spans.add(const TextSpan(text: '\n'));
        }

        // Determine metadata color
        Color metaColor;
        if (isExpired && !task.isDone) {
          metaColor = colorScheme.error;
        } else if (task.isDone) {
          metaColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
        } else {
          metaColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.7);
        }

        spans.add(TextSpan(
          text: metaParts.join(' • '),
          style: TextStyle(
            color: metaColor,
            fontSize: 12,
            fontWeight:
                isExpired && !task.isDone ? FontWeight.w600 : FontWeight.normal,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ));
      }

      if (spans.isEmpty) return null;

      return RichText(
        text: TextSpan(children: spans),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }

    return ListTile(
      leading: getLeadingIcon(),
      title: Text(
        task.title,
        style: TextStyle(
          color: getTitleColor(),
          fontWeight: getFontWeight(),
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: buildSubtitle(),
      trailing: Checkbox(
        value: task.isDone,
        activeColor: getCheckboxColor(),
        onChanged: (b) {
          if (b != null) {
            onTaskEdited(task.copyWith(isDone: b));
          }
        },
      ),
      onTap: () {
        // You can add navigation to task details or inline editing here
        onTaskEdited(task.copyWith(isDone: !task.isDone));
      },
    );
  }
}
