import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/settings/hub_tile.dart';

class SettingsMain extends ConsumerWidget {
  static final BasicLogger logger = BasicLogger();
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final user = userAsync.value;

    if (user == null) {
      if (userAsync.isLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return const Center(child: Text("User is null"));
    }

    final userNameAsync = ref.watch(UserNameProvider(user.uid));
    final userName = userNameAsync.value;
    if (userName == null) {
      if (userNameAsync.isLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return const Center(child: Text("Username is null"));
    }

    return settingsAsync.when(
      data: (settings) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Settings",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Manage your profile, workspace configuration, and team access.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 32),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width < 700 ? 1 : 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.4,
                      children: [
                        SettingsHubTile(
                          title: "My Profile",
                          description:
                              "Update your personal details and profile picture.",
                          icon: Icons.person_outline_rounded,
                          onTap: () => context.go("/settings/profile"),
                        ),
                        SettingsHubTile(
                          title: "Workspace",
                          description:
                              "Configure custom fields and global distance warnings.",
                          icon: Icons.work_outline_rounded,
                          status: "${settings.customFieldTemplates.length} fields",
                          onTap: () => context.go("/settings/workspace"),
                        ),
                        if (userName.userLevel.rank >= UserLevel.musher.rank)
                          SettingsHubTile(
                            title: "Team & Access",
                            description:
                                "Manage team members, roles, and workspace invitations.",
                            icon: Icons.group_add_outlined,
                            onTap: () => context.go("/settings/team"),
                          ),
                        if (userName.userLevel.rank >= UserLevel.musher.rank)
                          SettingsHubTile(
                            title: "Billing & Payments",
                            description:
                                "Connect Stripe and configure checkout settings.",
                            icon: Icons.payments_outlined,
                            onTap: () => context.go("/settings/billing"),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (e, s) {
        logger.error("Couldn't load settings", error: e, stackTrace: s);
        return const Center(child: Text("Error: couldn't load settings"));
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
