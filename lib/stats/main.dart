import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:mush_on/stats/repository.dart';
import 'package:mush_on/stats/riverpod.dart';

import 'run_table/main.dart';

class StatsMain extends ConsumerWidget {
  const StatsMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final colorScheme = Theme.of(context).colorScheme;
    final selectedDateRange = ref.watch(selectedDateRangeProvider);
    final allDogsAsync = ref.watch(dogsProvider);
    final selectedDogs = ref.watch(selectedDogsProvider);
    final account = ref.watch(accountProvider).value;
    return allDogsAsync.when(
        data: (allDogs) {
          if (account == null) {
            return const CircularProgressIndicator.adaptive();
          }
          late final List<Dog> dogsToDisplay;
          if (selectedDogs.isEmpty) {
            dogsToDisplay = allDogs;
          } else {
            dogsToDisplay = selectedDogs;
          }
          return FutureBuilder(
              future: StatsRepository(account: account)
                  .teamGroupsWorkspaceFromDateRange(
                      selectedDateRange.start, selectedDateRange.end),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator.adaptive(),
                        Text(
                            "Calculating the distances by each dog. This might take a while..."),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  logger.error("Couldn't load the teamgroups",
                      error: snapshot.error, stackTrace: snapshot.stackTrace);
                  return Text("Error: ${snapshot.error.toString()}");
                }
                if (snapshot.hasData) {
                  final teamGroups = snapshot.data!;
                  logger.debug("Number of teamgroups: ${teamGroups.length}");
                  return DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            children: [
                              RunTable(
                                  selectedDogs: dogsToDisplay,
                                  teamGroups: teamGroups),
                              const Placeholder(),
                            ],
                          ),
                        ),
                        TabBar(
                          labelColor: colorScheme.primary,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const [
                            Tab(text: "Run table"),
                            Tab(text: "Insights"),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                logger.error("Error: state of teamgroup future unknown.");
                return const Text("Error: state of teamgroup future unknown");
              });
        },
        error: (e, s) {
          logger.error("Couldn't load all dogs in stats");
          return const Text("Error: couldn't load the dogs");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class DogFilter extends ConsumerWidget {
  final List<Dog> allDogs;
  const DogFilter({super.key, required this.allDogs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsModel? settings = ref.watch(settingsProvider).value;
    return ExpansionTile(
      title: const Text("Filter dogs"),
      children: [
        DogFilterWidget(
            dogs: allDogs,
            onResult: (resultDogs) {
              ref.read(selectedDogsProvider.notifier).change(resultDogs);
              if (resultDogs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(
                    context, "Result is empty: showing all dogs"));
              }
            },
            templates: settings?.customFieldTemplates ?? []),
      ],
    );
  }
}
