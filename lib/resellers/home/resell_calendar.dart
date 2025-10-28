import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

class ResellCalendar extends ConsumerWidget {
  const ResellCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final accountToResell = ref.watch(accountToResellProvider).value;
    if (accountToResell == null) return const SizedBox.shrink();
    final tourTypesAsync =
        ref.watch(tourTypesProvider(accountToResell.accountName));
    return tourTypesAsync.when(
        data: (tourTypes) {
          return Text(tourTypes.toString());
        },
        error: (e, s) {
          logger.error("Error loading tour types for resell calendar",
              error: e, stackTrace: s);
          return Text("Error loading tour types: $e");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
