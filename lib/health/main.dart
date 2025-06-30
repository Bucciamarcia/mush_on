import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/new_health_event_alert_dialog.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
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
    if (dogs == null) {
      return CircularProgressIndicator.adaptive();
    } else {
      return ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextTitle("Health Overview"),
            ),
          ),
          ...healthEvents.map((e) => Text(e.title)),
          ...vaccinations.map((e) => Text(e.name)),
        ],
      );
    }
  }
}
