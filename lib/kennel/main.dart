import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/kennel/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/main.dart';

class EditKennelMain extends ConsumerWidget {
  static BasicLogger logger = BasicLogger();
  const EditKennelMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dogsAsync = ref.watch(dogsProvider);
    // INFO: This plugin doesn't differentiate between inactive filter and filter returning no results.
    // INFO: Ideally it should differentiate with a nullable List<Dog>?, but since I want to dispaly all dogs anyways,
    // INFO: It treats no filter and empty filter the same way.
    // INFO: Keep in mind if want different behaviour in future.
    return dogsAsync.when(
        data: (dogs) {
          ref.listen<AsyncValue<List<Dog>>>(dogsProvider, (previous, next) {
            // When we get new data (and not a repeat), update the display list.
            if (next.hasValue) {
              ref.read(dogsDisplayListProvider.notifier).setDogs(next.value!);
            }
          });
          var customFieldTemplates = ref.watch(settingsProvider).valueOrNull;
          return ListView(
            children: [
              Card(
                child: ExpansionTile(
                  title: const Text("Filter dogs"),
                  children: [
                    DogFilterWidget(
                      dogs: dogs,
                      templates:
                          customFieldTemplates?.customFieldTemplates ?? [],
                      onResult: (v) {
                        logger.debug("Len of list: ${v.length}");
                        // TODO: This now only orders by alpabetical order.
                        // TODO: Ordering should be done by dog fiter.
                        ref.read(dogsDisplayListProvider.notifier).setDogs(v);
                        if (v.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(context,
                                  "Search came up empty. Showing all dogs"));
                        }
                      },
                    ),
                  ],
                ),
              ),
              ...ref.watch(dogsDisplayListProvider).map(
                    (dog) => DogCard(dog: dog),
                  ),
            ],
          );
        },
        error: (e, s) {
          BasicLogger()
              .error("Error while loading dogs", error: e, stackTrace: s);
          return const Text("ERROR: couldn't load dogs");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class DogCard extends StatelessWidget {
  final Dog dog;
  const DogCard({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => context.pushNamed(
              "/dog",
              queryParameters: {"dogId": dog.id},
            ),
        child: Text(dog.name));
  }
}
