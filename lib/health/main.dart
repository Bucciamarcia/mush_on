import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/health/health_event_editor_alert.dart';
import 'package:mush_on/health/heat_cycle_editor_alert.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/health/vaccination_editor_alert.dart';
import 'package:mush_on/home_page/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:mush_on/shared/text_title.dart';

class HealthMain extends ConsumerWidget {
  static final logger = BasicLogger();
  const HealthMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    List<Dog>? dogs = ref.watch(dogsProvider).valueOrNull;
    List<HealthEvent> healthEvents =
        ref.watch(healthEventsProvider(null)).valueOrNull ?? [];
    List<Vaccination> vaccinations =
        ref.watch(vaccinationsProvider(null)).valueOrNull ?? [];
    List<HeatCycle> heatCycles =
        ref.watch(heatCyclesProvider(null)).valueOrNull ?? [];
    final AsyncValue<DogsWithWarnings> warningDogsAsync =
        ref.watch(dogsWithWarningsProvider);

    // Dialog listeners
    ref.listen(
      triggerAddhealthEventProvider,
      (previous, next) async {
        if (previous == false && next == true && dogs != null) {
          ref.read(triggerAddhealthEventProvider.notifier).setValue(false);
          await showDialog(
              context: context,
              builder: (BuildContext context) => HealthEventEditorAlert());
        }
      },
    );
    ref.listen(
      triggerAddVaccinationProvider,
      (previous, next) async {
        if (previous == false && next == true && dogs != null) {
          ref.read(triggerAddVaccinationProvider.notifier).setValue(false);
          await showDialog(
              context: context,
              builder: (BuildContext context) => VaccinationEditorAlert());
        }
      },
    );
    ref.listen(triggerAddHeatCycleProvider, (previous, next) async {
      if (previous == false && next == true && dogs != null) {
        ref.read(triggerAddHeatCycleProvider.notifier).setValue(false);
        await showDialog(
            context: context,
            builder: (BuildContext context) => HeatCycleEditorAlert());
      }
    });

    if (dogs == null) {
      return Center(child: CircularProgressIndicator.adaptive());
    }

    final distanceWarningsAsync =
        ref.watch(distanceWarningsProvider(latestDate: DateTimeUtils.today()));

    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        // Summary Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitle("Health Status"),
                SizedBox(height: 12),
                warningDogsAsync.when(
                  data: (dogsWithWarnings) {
                    final canRun = dogs.length - dogsWithWarnings.fatal.length;
                    final cantRun = dogsWithWarnings.fatal.length;
                    return Row(
                      children: [
                        _StatusChip(
                          icon: Icons.check_circle,
                          label: "$canRun can run",
                          color: Colors.green,
                        ),
                        SizedBox(width: 8),
                        if (cantRun > 0)
                          _StatusChip(
                            icon: Icons.cancel,
                            label: "$cantRun can't run",
                            color: colorScheme.error,
                          ),
                      ],
                    );
                  },
                  loading: () => LinearProgressIndicator(),
                  error: (e, s) {
                    logger.error("Couldn't load status",
                        error: e, stackTrace: s);
                    return Text("Error loading status");
                  },
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (healthEvents.active.isNotEmpty)
                      _StatusChip(
                        icon: Icons.warning,
                        label: "${healthEvents.active.length} active events",
                        color: Colors.orange,
                      ),
                    if (heatCycles.active.isNotEmpty)
                      _StatusChip(
                        icon: Icons.favorite,
                        label: "${heatCycles.active.length} in heat",
                        color: Colors.pink,
                      ),
                    if (vaccinations.expiringSoon(days: 30).isNotEmpty)
                      _StatusChip(
                        icon: Icons.schedule,
                        label:
                            "${vaccinations.expiringSoon(days: 30).length} vaccines expiring",
                        color: Colors.amber,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // All healthy message
        if (healthEvents.active.isEmpty &&
            heatCycles.active.isEmpty &&
            vaccinations.overdue.isEmpty)
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.celebration, color: colorScheme.primary),
                  SizedBox(width: 12),
                  Text(
                    "All dogs are healthy! 🎉",
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Overdue vaccinations (HIGH PRIORITY)
        if (vaccinations.overdue.isNotEmpty)
          Card(
            color: colorScheme.errorContainer,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error, color: colorScheme.error),
                      SizedBox(width: 8),
                      TextTitle("⚠️ Overdue Vaccinations"),
                    ],
                  ),
                  SizedBox(height: 8),
                  ...vaccinations.overdue.map((v) => InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (dialogContext) => VaccinationEditorAlert(
                                  event: v,
                                  dogs: dogs,
                                )),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.pets, size: 16),
                              SizedBox(width: 8),
                              Text(
                                dogs.getDogFromId(v.dogId)?.name ?? "Unknown",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(" - ${v.title}"),
                              Spacer(),
                              Text(
                                "Expired ${DateFormat("MMM d").format(v.expirationDate!)}",
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

        // Active health events
        if (healthEvents.active.isNotEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitle("Active Health Events"),
                  SizedBox(height: 8),
                  ...healthEvents.active.map((e) => ListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return HealthEventEditorAlert(
                                event: e,
                                dogs: dogs,
                              );
                            }),
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: e.preventFromRunning
                              ? colorScheme.errorContainer
                              : colorScheme.secondaryContainer,
                          child: Icon(
                            _getEventIcon(e.eventType),
                            size: 20,
                            color: e.preventFromRunning
                                ? colorScheme.error
                                : colorScheme.secondary,
                          ),
                        ),
                        title:
                            Text(dogs.getDogFromId(e.dogId)?.name ?? "Unknown"),
                        subtitle: Text(
                            "${e.title} • ${_formatEventType(e.eventType)}"),
                        trailing: e.preventFromRunning
                            ? Chip(
                                label: Text("Can't run",
                                    style: TextStyle(fontSize: 12)),
                                backgroundColor: colorScheme.errorContainer,
                              )
                            : null,
                      )),
                ],
              ),
            ),
          ),

        // Dogs in heat
        if (heatCycles.active.isNotEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitle("Dogs in Heat"),
                  SizedBox(height: 8),
                  ...heatCycles.active.map((h) => ListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return HeatCycleEditorAlert(event: h, dogs: dogs);
                            }),
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink,
                          child: Icon(Icons.favorite,
                              size: 20, color: Colors.pink),
                        ),
                        title:
                            Text(dogs.getDogFromId(h.dogId)?.name ?? "Unknown"),
                        subtitle: Text(
                            "Started ${DateFormat("MMM d").format(h.startDate)}"),
                        trailing: h.preventFromRunning
                            ? Chip(
                                label: Text("Can't run",
                                    style: TextStyle(fontSize: 12)),
                                backgroundColor: colorScheme.errorContainer,
                              )
                            : null,
                      )),
                ],
              ),
            ),
          ),

        //Upcoming health events
        if (healthEvents.startingInNext(days: 30).isNotEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitle("Upcoming health events"),
                  SizedBox(height: 8),
                  ...healthEvents.startingInNext(days: 30).map((v) => ListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                HealthEventEditorAlert(dogs: dogs, event: v)),
                        dense: true,
                        leading: Icon(Icons.healing, color: Colors.amber),
                        title:
                            Text(dogs.getDogFromId(v.dogId)?.name ?? "Unknown"),
                        subtitle: Text(v.title),
                        trailing: Text(
                          DateFormat("MMM d").format(v.date),
                          style: TextStyle(color: Colors.amber[700]),
                        ),
                      )),
                ],
              ),
            ),
          ),

        // Upcoming vaccinations
        if (vaccinations.expiringSoon(days: 30).isNotEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitle("Vaccinations Expiring Soon"),
                  SizedBox(height: 8),
                  ...vaccinations.expiringSoon(days: 30).map((v) => ListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                VaccinationEditorAlert(dogs: dogs, event: v)),
                        dense: true,
                        leading: Icon(Icons.vaccines, color: Colors.amber),
                        title:
                            Text(dogs.getDogFromId(v.dogId)?.name ?? "Unknown"),
                        subtitle: Text(v.title),
                        trailing: Text(
                          DateFormat("MMM d").format(v.expirationDate!),
                          style: TextStyle(color: Colors.amber[700]),
                        ),
                      )),
                ],
              ),
            ),
          ),

        // Recent events
        if (healthEvents.getRecentlySolved(days: 7).isNotEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextTitle("Recently Resolved"),
                  SizedBox(height: 8),
                  ...healthEvents.getRecentlySolved(days: 7).map((e) =>
                      ListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => HealthEventEditorAlert(
                                  dogs: dogs,
                                  event: e,
                                )),
                        dense: true,
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title:
                            Text(dogs.getDogFromId(e.dogId)?.name ?? "Unknown"),
                        subtitle: Text(
                            "${e.title} • Resolved ${DateFormat("MMM d").format(e.resolvedDate!)}"),
                      )),
                ],
              ),
            ),
          ),

        // Distance warnings
        distanceWarningsAsync.when(
          data: (warnings) {
            if (warnings.isEmpty) return SizedBox.shrink();
            return Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle("Distance Warnings"),
                    SizedBox(height: 8),
                    ...warnings.map((w) => ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor:
                                w.distanceWarning.distanceWarningType ==
                                        DistanceWarningType.hard
                                    ? colorScheme.errorContainer
                                    : Colors.orange[100],
                            child: Icon(
                              Icons.speed,
                              size: 20,
                              color: w.distanceWarning.distanceWarningType ==
                                      DistanceWarningType.hard
                                  ? colorScheme.error
                                  : Colors.orange,
                            ),
                          ),
                          title: Text(w.dog.name),
                          subtitle: Text(
                            "${w.distanceRan.toStringAsFixed(1)}km / ${w.distanceWarning.distance}km in ${w.distanceWarning.daysInterval} days",
                          ),
                          trailing: Icon(
                            w.distanceWarning.distanceWarningType ==
                                    DistanceWarningType.hard
                                ? Icons.error
                                : Icons.warning,
                            color: w.distanceWarning.distanceWarningType ==
                                    DistanceWarningType.hard
                                ? colorScheme.error
                                : Colors.orange,
                          ),
                        )),
                  ],
                ),
              ),
            );
          },
          error: (e, s) => SizedBox.shrink(),
          loading: () => LinearProgressIndicator(),
        ),

        SizedBox(height: 80), // Space for FAB
      ],
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

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
