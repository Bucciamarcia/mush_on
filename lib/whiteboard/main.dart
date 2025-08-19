import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/home_page/whiteboard_element.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/whiteboard/repository.dart';

import 'riverpod.dart';

class GeneralWhiteboard extends ConsumerWidget {
  static final logger = BasicLogger();
  const GeneralWhiteboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elementsAsync = ref.watch(permanentWhiteboardElementsProvider);
    return elementsAsync.when(
        data: (elements) {
          elements.sort((a, b) => a.date.compareTo(b.date));
          return Column(
            children: [
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => WhiteboardElementEditor(
                    onSaved: (element) async {
                      final repo = PermanentWhiteboardRepository(
                        account: await ref.watch(accountProvider.future),
                      );
                      try {
                        await repo.setElement(element);
                      } catch (e, s) {
                        logger.error("Error saving whiteboard element",
                            error: e, stackTrace: s);
                        ScaffoldMessenger.of(context).showSnackBar(
                          errorSnackBar(context, "Couldn't save element"),
                        );
                      }
                    },
                    onDeleted: (id) async {
                      final repo = PermanentWhiteboardRepository(
                        account: await ref.watch(accountProvider.future),
                      );
                      try {
                        await repo.deleteElement(id);
                      } catch (e, s) {
                        logger.error("Error deleting whiteboard element",
                            error: e, stackTrace: s);
                        ScaffoldMessenger.of(context).showSnackBar(
                          errorSnackBar(context, "Couldn't delete element"),
                        );
                      }
                    },
                  ),
                ),
                child: const Text("Add new element"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: elements.length,
                  itemBuilder: (itemContext, index) =>
                      WhiteboardElementDisplayWidget(
                          element: elements[index],
                          onSaved: (element) async {
                            final repo = PermanentWhiteboardRepository(
                                account:
                                    await ref.watch(accountProvider.future));
                            try {
                              await repo.setElement(element);
                            } catch (e, s) {
                              logger.error("Error saving whiteboard element",
                                  error: e, stackTrace: s);
                              ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context, "Couldn't save element"),
                              );
                            }
                          },
                          onDeleted: (id) async {
                            final repo = PermanentWhiteboardRepository(
                                account:
                                    await ref.watch(accountProvider.future));
                            try {
                              await repo.deleteElement(id);
                            } catch (e, s) {
                              logger.error("Error deleting whiteboard element",
                                  error: e, stackTrace: s);
                              ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(
                                    context, "Couldn't delete element"),
                              );
                            }
                          }),
                ),
              ),
            ],
          );
        },
        error: (e, s) {
          logger.error("Error loading whiteboard elements",
              error: e, stackTrace: s);
          return const Text("Error: couldn't get elements");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
