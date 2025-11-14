import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:mush_on/stats/riverpod.dart';

class StatsMain extends ConsumerWidget {
  const StatsMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final colorScheme = Theme.of(context).colorScheme;
    final selectedDateRange = ref.watch(selectedDateRangeProvider);
    final allDogsAsync = ref.watch(dogsProvider);
    final selectedDogs = ref.watch(selectedDogsProvider);
    return allDogsAsync.when(
        data: (allDogs) {
          late final List<Dog> dogsToDisplay;
          if (selectedDogs.isEmpty) {
            dogsToDisplay = allDogs;
          } else {
            dogsToDisplay = selectedDogs;
          }
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          DogFilter(allDogs: allDogs),
                          Text(selectedDateRange.toString()),
                          Text("Numbero of dogs: ${dogsToDisplay.length}"),
                          Text(dogsToDisplay.justNames),
                        ],
                      ),
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
