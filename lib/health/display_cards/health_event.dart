import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../health_event_editor_alert.dart';
import '../../riverpod.dart';

class HealthEventDisplayCard extends ConsumerWidget {
  final HealthEvent event;
  const HealthEventDisplayCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final dogs = ref.watch(dogsProvider).valueOrNull ?? [];
    final dog = dogs.where((d) => d.id == event.dogId).firstOrNull;
    
    final bool requiresAttention = event.preventFromRunning && event.isOngoing;
    
    // Health events have orange/amber theme
    Color cardColor = Colors.orange[50] ?? colorScheme.surfaceContainerHighest;
    Color borderColor = Colors.orange[300] ?? colorScheme.outline;
    Color textColor = colorScheme.onSurface;
    Color accentColor = Colors.orange[700] ?? colorScheme.secondary;

    // Override colors if requires attention (prevents running)
    if (requiresAttention) {
      cardColor = colorScheme.errorContainer;
      borderColor = colorScheme.error;
      textColor = colorScheme.onErrorContainer;
      accentColor = colorScheme.error;
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
          builder: (context) => HealthEventEditorAlert(
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
                      _getEventIcon(event.eventType),
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
                          event.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (event.preventFromRunning && event.isOngoing)
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
                    DateFormat("MMM d, yyyy").format(event.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatEventType(event.eventType),
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              if (event.isOngoing)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: accentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Ongoing",
                        style: TextStyle(
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEventIcon(HealthEventType type) {
    switch (type) {
      case HealthEventType.injury:
        return Icons.personal_injury;
      case HealthEventType.illness:
        return Icons.sick;
      case HealthEventType.vetVisit:
        return Icons.local_hospital;
      case HealthEventType.procedure:
        return Icons.medical_services;
      case HealthEventType.observation:
        return Icons.visibility;
      case HealthEventType.other:
        return Icons.more_horiz;
    }
  }

  String _formatEventType(HealthEventType type) {
    return type.name.substring(0, 1).toUpperCase() + type.name.substring(1);
  }
}
