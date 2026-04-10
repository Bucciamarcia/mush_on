import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/settings/add_users.dart';
import 'package:mush_on/settings/repository.dart';

class TeamSettingsPage extends ConsumerWidget {
  const TeamSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value;

    if (account == null) {
      return const TemplateScreen(
        title: "Team",
        child: Center(child: Text("Account not available")),
      );
    }

    final settingsRepo = SettingsRepository(account: account);

    return TemplateScreen(
      title: "Team & Access",
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: AddUsers(account: account, repository: settingsRepo),
          ),
        ),
      ),
    );
  }
}
