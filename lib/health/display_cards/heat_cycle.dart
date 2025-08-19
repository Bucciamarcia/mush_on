import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/heat_cycle_editor_alert.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';

class HeatCycleDisplayCard extends ConsumerWidget {
  final HeatCycle event;
  const HeatCycleDisplayCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final dogs = ref.watch(dogsProvider).valueOrNull ?? [];
    final dog = dogs.where((d) => d.id == event.dogId).firstOrNull;

    final bool isActive = event.endDate == null || event.endDate!.isAfter(DateTimeUtils.today());
    final bool requiresAttention = isActive && event.preventFromRunning;
    
    // Heat cycles have pink/purple theme
    Color cardColor = Colors.pink[50] ?? colorScheme.surfaceContainerHighest;
    Color borderColor = Colors.pink[300] ?? colorScheme.outline;
    Color textColor = colorScheme.onSurface;
    Color accentColor = Colors.pink[700] ?? colorScheme.secondary;

    if (requiresAttention) {
      cardColor = colorScheme.errorContainer;
      borderColor = colorScheme.error;
      textColor = colorScheme.onErrorContainer;
      accentColor = colorScheme.error;
    } else if (!isActive) {
      // Ended heat cycles have muted colors
      cardColor = Colors.grey[100] ?? colorScheme.surfaceContainerHighest;
      borderColor = Colors.grey[400] ?? colorScheme.outline;
      accentColor = Colors.grey[600] ?? colorScheme.secondary;
    }

    int? daysSinceStart;
    if (isActive) {
      daysSinceStart = DateTimeUtils.today().difference(event.startDate).inDays;
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => HeatCycleEditorAlert(
            event: event,
            dogs: dogs,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: accentColor,
                    child: Icon(
                      Icons.favorite,
                      size: 16,
                      color: requiresAttention
                          ? colorScheme.onError
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dog?.name ?? "Unknown Dog",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          isActive ? "Heat Cycle (Active)" : "Heat Cycle (Ended)",
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (event.preventFromRunning && isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.block, size: 12, color: colorScheme.onError),
                          const SizedBox(width: 4),
                          Text(
                            "CAN'T RUN",
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onError,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "ACTIVE",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: textColor.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Started ${DateFormat("MMM d, yyyy").format(event.startDate)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              if (event.endDate != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 14,
                      color: textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Ended ${DateFormat("MMM d, yyyy").format(event.endDate!)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ] else if (isActive && daysSinceStart != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: accentColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      daysSinceStart == 0 
                          ? "Started today" 
                          : "Day ${daysSinceStart + 1} of cycle",
                      style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (event.notes.isNotEmpty) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.notes,
                    style: TextStyle(
                      fontSize: 11,
                      color: textColor.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
