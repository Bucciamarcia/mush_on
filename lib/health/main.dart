import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';

class HealthMain extends ConsumerWidget {
  static final logger = BasicLogger();
  const HealthMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogs = ref.watch(dogsProvider);
    var colorScheme = Theme.of(context).colorScheme;
    switch (dogs) {
      case AsyncData(:final value):
        return ListView(
          children: [
            TextTitle(value[0].name),
            Card(
              color: colorScheme.surfaceContainer,
              child: Column(
                children: [],
              ),
            )
          ],
        );
      case AsyncError(:final error):
        logger.error("Error in async dog fetch: $error");
        return Text("error");
      default:
        return const CircularProgressIndicator();
    }
  }
}
