import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/vaccination_editor_alert.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';

class VaccinationDisplayCard extends ConsumerWidget {
  final Vaccination event;
  const VaccinationDisplayCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final dogs = ref.watch(dogsProvider).valueOrNull ?? [];
    final dog = dogs.where((d) => d.id == event.dogId).firstOrNull;

    final bool isOverdue = event.expirationDate != null && 
        event.expirationDate!.isBefore(DateTimeUtils.today());
    final bool isExpiringSoon = event.expirationDate != null && 
        !isOverdue &&
        event.expirationDate!.isBefore(DateTimeUtils.today().add(const Duration(days: 30))) &&
        event.expirationDate!.isAfter(DateTimeUtils.today());

    // Vaccinations have blue/teal theme
    Color cardColor = Colors.teal[50] ?? colorScheme.surfaceContainerHighest;
    Color borderColor = Colors.teal[300] ?? colorScheme.outline;
    Color textColor = colorScheme.onSurface;
    Color accentColor = Colors.teal[700] ?? colorScheme.secondary;

    if (isOverdue) {
      cardColor = colorScheme.errorContainer;
      borderColor = colorScheme.error;
      textColor = colorScheme.onErrorContainer;
      accentColor = colorScheme.error;
    } else if (isExpiringSoon) {
      cardColor = Colors.amber[50] ?? cardColor;
      borderColor = Colors.amber[400] ?? borderColor;
      accentColor = Colors.amber[700] ?? accentColor;
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
          builder: (context) => VaccinationEditorAlert(
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
                      Icons.vaccines,
                      size: 16,
                      color: isOverdue 
                          ? colorScheme.onError 
                          : (isExpiringSoon 
                              ? Colors.amber[900] 
                              : Colors.white),
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
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "OVERDUE",
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (isExpiringSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "EXPIRES SOON",
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
                    "Administered ${DateFormat("MMM d, yyyy").format(event.dateAdministered)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              if (event.expirationDate != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isOverdue ? Icons.error : Icons.schedule,
                      size: 14,
                      color: accentColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOverdue 
                          ? "Expired ${DateFormat("MMM d, yyyy").format(event.expirationDate!)}"
                          : "Expires ${DateFormat("MMM d, yyyy").format(event.expirationDate!)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontWeight: isOverdue || isExpiringSoon ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  event.vaccinationType,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
