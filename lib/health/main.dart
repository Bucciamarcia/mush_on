import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/health/display_cards/health_event.dart';
import 'package:mush_on/health/display_cards/heat_cycle.dart';
import 'package:mush_on/health/display_cards/vaccination.dart';
import 'package:mush_on/health/health_event_editor_alert.dart';
import 'package:mush_on/health/heat_cycle_editor_alert.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/health/vaccination_editor_alert.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/riverpod/dog_notes.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:mush_on/shared/dog_list_alert_dialog.dart';
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
    final dogNotes = ref.watch(dogNotesProvider(latestDate: null));

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

    final cantRun = dogNotes.typeFatal();
    final cantRunDogIds = cantRun.map((note) => note.dogId).toSet();

    List<Dog> cantRunDogs =
        dogs.where((dog) => cantRunDogIds.contains(dog.id)).toList();
    final canRun = List<Dog>.from(dogs);
    canRun.removeWhere(
      (dog) {
        for (var note in cantRun) {
          if (dog.id == note.dogId) return true;
        }
        return false;
      },
    );
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadiusGeometry.all(Radius.circular(20))),
                      label: Text("${canRun.length} can run"),
                      avatar: Icon(Icons.check_circle, color: Colors.green),
                      backgroundColor: Colors.green[100],
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => DogListAlertDialog(
                            title: "Dogs that can run", dogs: canRun),
                      ),
                    ),
                    SizedBox(width: 8),
                    if (cantRun.isNotEmpty)
                      ActionChip(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadiusGeometry.all(Radius.circular(20))),
                        label: Text("${cantRun.length} can't run"),
                        avatar: Icon(Icons.cancel, color: Colors.red),
                        backgroundColor: Colors.red[100],
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => DogListAlertDialog(
                              title: "Dogs that can't run", dogs: cantRunDogs),
                        ),
                      ),
                    if (healthEvents.active.isNotEmpty)
                      ActionChip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(20))),
                          label: Text(
                              "${healthEvents.active.length} active health events"),
                          avatar:
                              Icon(Icons.check_circle, color: Colors.orange),
                          backgroundColor: Colors.orange[100],
                          onPressed: () {
                            var healthEventDogs = <Dog>[];
                            for (var e in healthEvents.active) {
                              var r = dogs.getDogFromId(e.dogId);
                              if (r != null && !healthEventDogs.contains(r)) {
                                healthEventDogs.add(r);
                              }
                            }
                            showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                  title: "Dogs with health events",
                                  dogs: healthEventDogs),
                            );
                          }),
                    if (heatCycles.active.isNotEmpty)
                      ActionChip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(20))),
                          label: Text("${heatCycles.active.length} in heat"),
                          avatar: Icon(Icons.check_circle, color: Colors.pink),
                          backgroundColor: Colors.pink[100],
                          onPressed: () {
                            var dogsInHeat = <Dog>[];
                            for (var e in heatCycles.active) {
                              var r = dogs.getDogFromId(e.dogId);
                              if (r != null && !dogsInHeat.contains(r)) {
                                dogsInHeat.add(r);
                              }
                            }
                            showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                  title: "Dogs in heat", dogs: dogsInHeat),
                            );
                          }),
                    if (vaccinations.expiringSoon(days: 30).isNotEmpty)
                      ActionChip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(20))),
                          label: Text(
                              "${vaccinations.expiringSoon(days: 30).length} vaccines expiring soon"),
                          avatar: Icon(Icons.check_circle, color: Colors.amber),
                          backgroundColor: Colors.amber[100],
                          onPressed: () {
                            var dogse = <Dog>[];
                            for (var e in vaccinations.expiringSoon(days: 30)) {
                              var r = dogs.getDogFromId(e.dogId);
                              if (r != null && !dogse.contains(r)) {
                                dogse.add(r);
                              }
                            }
                            showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                  title: "Dogs with vaccinations expiring soon",
                                  dogs: dogse),
                            );
                          }),
                  ],
                ),
                SizedBox(height: 8),
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
        if (vaccinations.overdue.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Icon(Icons.error, color: colorScheme.error),
                SizedBox(width: 8),
                TextTitle("⚠️ Overdue Vaccinations"),
              ],
            ),
          ),
          ...vaccinations.overdue.map((v) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: VaccinationDisplayCard(event: v),
              )),
        ],

        // Active health events
        if (healthEvents.active.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextTitle("Active Health Events"),
          ),
          ...healthEvents.active.map((e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: HealthEventDisplayCard(event: e),
              )),
        ],

        // Dogs in heat
        if (heatCycles.active.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextTitle("Dogs in Heat"),
          ),
          ...heatCycles.active.map((h) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: HeatCycleDisplayCard(event: h),
              )),
        ],

        //Upcoming health events
        if (healthEvents.startingInNext(days: 30).isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextTitle("Upcoming Health Events"),
          ),
          ...healthEvents.startingInNext(days: 30).map((v) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: HealthEventDisplayCard(event: v),
              )),
        ],

        // Upcoming vaccinations
        if (vaccinations.expiringSoon(days: 30).isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextTitle("Vaccinations Expiring Soon"),
          ),
          ...vaccinations.expiringSoon(days: 30).map((v) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: VaccinationDisplayCard(event: v),
              )),
        ],

        // Recent events
        if (healthEvents.getRecentlySolved(days: 7).isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextTitle("Recently Resolved"),
          ),
          ...healthEvents.getRecentlySolved(days: 7).map((e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: HealthEventDisplayCard(event: e),
              )),
        ],

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

}
