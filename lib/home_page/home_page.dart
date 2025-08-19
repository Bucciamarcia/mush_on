import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/home_page/main.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';

class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccount = ref.watch(accountProvider);
    return asyncAccount.when(
      data: (account) {
        return const TemplateScreen(title: "Kennel", child: HomePageScreenContent());
      },
      error: (e, s) => const Text("Error getting account"),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}
