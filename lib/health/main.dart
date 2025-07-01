import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/new_health_event_alert_dialog.dart';
import 'package:mush_on/health/new_heat_cycle_alert_dialog.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:mush_on/shared/text_title.dart';

import 'new_vaccination_alert_dialog.dart';

class HealthMain extends ConsumerWidget {
  static final logger = BasicLogger();
  const HealthMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Dog>? dogs = ref.watch(dogsProvider).valueOrNull;
    List<HealthEvent> healthEvents =
        ref.watch(healthEventsProvider(null)).valueOrNull ?? [];
    List<Vaccination> vaccinations =
        ref.watch(vaccinationsProvider(null)).valueOrNull ?? [];
    List<HeatCycle> heatCycles =
        ref.watch(heatCyclesProvider(null)).valueOrNull ?? [];
    final AsyncValue<DogsWithWarnings> warningDogsAsync =
        ref.watch(warningDogsProvider);
    ref.listen(
      triggerAddhealthEventProvider,
      (previous, next) async {
        if (previous == false && next == true && dogs != null) {
          ref.read(triggerAddhealthEventProvider.notifier).setValue(false);
          await showDialog(
              context: context,
              builder: (BuildContext context) => NewHealthEventAlertDialog());
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
              builder: (BuildContext context) => NewVaccinationAlertDialog());
        }
      },
    );
    ref.listen(triggerAddHeatCycleProvider, (previous, next) async {
      if (previous == false && next == true && dogs != null) {
        ref.read(triggerAddHeatCycleProvider.notifier).setValue(false);
        await showDialog(
            context: context,
            builder: (BuildContext context) => NewHeatCycleAlertDialog());
      }
    });
    if (dogs == null) {
      return CircularProgressIndicator.adaptive();
    } else {
      final distanceWarningsAsync = ref.watch(distanceWarningsProvider);
      return ListView(
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextTitle("Right now"),
                ),
                warningDogsAsync.when(
                    data: (dogsWithWarnings) => Text(
                        "Dogs that can run: ${dogs.length - dogsWithWarnings.fatal.length}/${dogs.length}"),
                    loading: () => const Center(
                        child: CircularProgressIndicator.adaptive()),
                    error: (e, s) {
                      logger.error("Couldn't load dogs",
                          error: e, stackTrace: s);
                      return Text("Couldn't fetch dogs that can run");
                    }),
                Text("Active health events: ${healthEvents.active.length}"),
                Text("Dogs in heat: ${heatCycles.active.length}"),
                Text(
                    "Vaccinations expiring in next 30 days: ${vaccinations.expiringSoon(days: 30).length}"),
              ],
            ),
          ),
          healthEvents.active.isNotEmpty
              ? Card(
                  child: Column(
                    children: [
                      TextTitle("Active health events"),
                      ...healthEvents.active.map((e) => Text(
                          "${dogs.getDogFromId(e.dogId)?.name ?? "Unknown"}: ${e.title} - ${e.eventType}"))
                    ],
                  ),
                )
              : SizedBox.shrink(),
          heatCycles.active.isNotEmpty
              ? Card(
                  child: Column(
                  children: [
                    TextTitle("Dogs in heat"),
                    ...heatCycles.active.map((e) => Text(
                        "${dogs.getDogFromId(e.dogId)?.name ?? "Unknown"}"))
                  ],
                ))
              : SizedBox.shrink(),
          vaccinations.overdue.isNotEmpty
              ? Card(
                  child: Column(
                  children: [
                    TextTitle("Vaccinations overdue"),
                    ...vaccinations.overdue.map((e) => Text(
                        "${dogs.getDogFromId(e.dogId)?.name ?? "Unknown"}: ${DateFormat("yyyy-MM-dd").format(e.expirationDate!)}"))
                  ],
                ))
              : SizedBox.shrink(),
          vaccinations.expiringSoon(days: 30).isNotEmpty
              ? Card(
                  child: Column(
                  children: [
                    TextTitle("Vaccinations expiring soon"),
                    ...vaccinations.expiringSoon(days: 30).map((e) => Text(
                        "${dogs.getDogFromId(e.dogId)?.name ?? "Unknown"}: ${DateFormat("yyyy-MM-dd").format(e.expirationDate!)}"))
                  ],
                ))
              : SizedBox.shrink(),
          healthEvents.getRecentlySolved(days: 7).isNotEmpty
              ? Card(
                  child: Column(
                    children: [
                      TextTitle("Recently solved events"),
                      ...healthEvents.getRecentlySolved(days: 7).map((e) => Text(
                          "${dogs.getDogFromId(e.dogId)?.name ?? "Unknown"}: ${e.title} - ${e.eventType}"))
                    ],
                  ),
                )
              : SizedBox.shrink(),
          distanceWarningsAsync.when(
            data: (distanceWarnings) {
              return Column(
                children: distanceWarnings
                    .map((w) => Text(
                        "${w.distanceWarning.distanceWarningType} - ${w.dog.name}: ${w.distanceRan}/${w.distanceWarning.distance} in ${w.distanceWarning.daysInterval}"))
                    .toList(),
              );
            },
            error: (e, s) {
              logger.error("Couldn't get distanceWarningsAsync provider",
                  error: e, stackTrace: s);
              return Text("Error: couln't get warnings: $e");
            },
            loading: () => Center(child: CircularProgressIndicator.adaptive()),
          ),
        ],
      );
    }
  }
}
