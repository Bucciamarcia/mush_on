import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/create_account/main.dart';
import 'package:mush_on/resellers/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

class ResellerTemplate extends ConsumerWidget {
  final Widget child;
  final String title;
  const ResellerTemplate({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final resellerAsync = ref.watch(resellerDataProvider);
    return resellerAsync.when(
        data: (resellerData) {
          if (resellerData == null) {
            return const ResellerScaffold(
                title: "Create a reseller account",
                child: ResellerCreateAccount());
          } else {
            return ResellerScaffold(
              title: title,
              child: child,
            );
          }
        },
        error: (e, s) {
          logger.error("Couldn't load reseller data", error: e, stackTrace: s);
          return ResellerError(message: e.toString());
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class ResellerScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  const ResellerScaffold({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: child);
  }
}

class ResellerError extends StatelessWidget {
  final String message;
  const ResellerError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text(message)));
  }
}
