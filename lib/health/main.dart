import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/shared/text_title.dart';

class HealthMain extends ConsumerWidget {
  static final logger = BasicLogger();
  const HealthMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Dog>? dogs = ref.watch(dogsProvider).valueOrNull;
    var colorScheme = Theme.of(context).colorScheme;
    if (dogs == null) {
      return CircularProgressIndicator.adaptive();
    } else {
      return TextTitle(dogs[0].name);
    }
  }
}
