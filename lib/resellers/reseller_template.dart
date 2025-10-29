import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/resellers/create_account/main.dart';
import 'package:mush_on/resellers/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/error_handling.dart';

import 'login.dart';

class ResellerTemplate extends ConsumerWidget {
  final Widget child;
  final String title;
  const ResellerTemplate({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
        data: (user) {
          if (user == null) {
            return const ResellerLogin();
          }
          final resellerDataAsync = ref.watch(resellerDataProvider);
          return resellerDataAsync.when(
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
                logger.error("Couldn't load reseller data",
                    error: e, stackTrace: s);
                return ResellerError(message: e.toString());
              },
              loading: () => const CircularProgressIndicator.adaptive());
        },
        error: (e, s) {
          logger.error("Coulnd't load user", error: e, stackTrace: s);
          return const ResellerError(
              message: "Couldn't load the reseller user");
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
        drawer: const ResellerDrawer(),
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(width: 1200, child: child),
            ],
          )),
        ));
  }
}

class ResellerDrawer extends StatelessWidget {
  const ResellerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ResellerDrawerButton(
                text: "Log out",
                onPressed: () async {
                  await AuthService().signOut();
                  if (context.mounted) context.go("/reseller");
                })
          ],
        ),
      ),
    );
  }
}

class ResellerDrawerButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const ResellerDrawerButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => onPressed(), child: Text(text));
  }
}

class ResellerError extends StatelessWidget {
  final String message;
  const ResellerError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Text(message),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Go back")),
      ],
    )));
  }
}
