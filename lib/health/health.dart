import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';

import 'main.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthEvents = ref.watch(healthEventsProvider(null));
    final vaccinations = ref.watch(vaccinationsProvider(null));
    final heatCycles = ref.watch(heatCyclesProvider(null));
    if (healthEvents.hasError) {
      BasicLogger().error("Health events error: ${healthEvents.error}");
      return TemplateScreen(
        title: "Health dashboard",
        child: Align(
          alignment: Alignment.center,
          child: TextTitle("There has been an error!"),
        ),
      );
    }
    if (vaccinations.hasError) {
      BasicLogger().error("Vaccinations error: ${vaccinations.error}");
      return TemplateScreen(
        title: "Health dashboard",
        child: Align(
          alignment: Alignment.center,
          child: TextTitle("There has been an error!"),
        ),
      );
    }
    if (heatCycles.hasError) {
      BasicLogger().error("Heat cycles error: ${heatCycles.error}");
      return TemplateScreen(
        title: "Health dashboard",
        child: Align(
          alignment: Alignment.center,
          child: TextTitle("There has been an error!"),
        ),
      );
    }
    return TemplateScreen(title: "Health dashboard", child: HealthMain());
  }
}
