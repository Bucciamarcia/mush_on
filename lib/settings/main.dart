import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/settings/add_users.dart';
import 'package:mush_on/settings/custom_fields.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:mush_on/settings/section_shell.dart';
import 'package:mush_on/settings/user_settings.dart';
import 'package:mush_on/shared/distance_warning_widget/main.dart';

import 'stripe/stripe_payment_settings.dart';

class SettingsMain extends ConsumerStatefulWidget {
  static final BasicLogger logger = BasicLogger();
  final SettingsRepository Function(String account)? repositoryBuilder;
  const SettingsMain({super.key, this.repositoryBuilder});

  @override
  ConsumerState<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends ConsumerState<SettingsMain> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final user = userAsync.value;
    if (user == null) {
      if (userAsync.isLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return const Text("User is null");
    }

    final userNameAsync = ref.watch(UserNameProvider(user.uid));
    final userName = userNameAsync.value;
    if (userName == null) {
      if (userNameAsync.isLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return const Text("Username is null");
    }

    final account = ref.watch(accountProvider).value;
    if (account == null) return const Text("Account is null");
    return settingsAsync.when(
      data: (settings) {
        final settingsRepo = widget.repositoryBuilder?.call(account) ??
            SettingsRepository(account: account);
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 760;

                    final customFieldsSection = CustomFieldsOptions(
                      customFieldTemplates: settings.customFieldTemplates,
                      onCustomFieldAdded: (newCustomField) =>
                          settingsRepo.addCustomField(newCustomField, settings),
                      onCustomFieldDeleted: (id) =>
                          settingsRepo.deleteCustomField(id, settings),
                    );

                    final warningsSection = SettingsSectionShell(
                      title: "Global distance warnings",
                      description:
                          "Set account-wide rules for recent mileage so handlers see consistent soft and hard warnings everywhere.",
                      badge: "Safety",
                      child: SettingsSurface(
                        child: DistanceWarningWidget(
                          warnings: settings.globalDistanceWarnings,
                          onWarningAdded: (warning) async {
                            try {
                              await settingsRepo.addDistanceWarning(
                                  warning, settings);
                            } catch (e, s) {
                              SettingsMain.logger.error(
                                  "Couldn't add distance warning",
                                  error: e,
                                  stackTrace: s);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(context,
                                        "Couldn't add distance warning"));
                              }
                            }
                          },
                          onWarningEdited: (warning) async {
                            try {
                              await settingsRepo.editDistanceWarning(
                                  warning, settings);
                            } catch (e, s) {
                              SettingsMain.logger.error(
                                  "Couldn't edit distance warning",
                                  error: e,
                                  stackTrace: s);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(context,
                                        "Couldn't edit distance warning"));
                              }
                            }
                          },
                          onWarningRemoved: (id) async {
                            try {
                              await settingsRepo.removeDistanceWarning(
                                  id, settings);
                            } catch (e, s) {
                              SettingsMain.logger.error(
                                  "Couldn't remove distance warning",
                                  error: e,
                                  stackTrace: s);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(context,
                                        "Couldn't remove distance warning"));
                              }
                            }
                          },
                        ),
                      ),
                    );

                    final leadingColumn = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        customFieldsSection,
                        if (userName.userLevel.rank >=
                            UserLevel.musher.rank) ...[
                          const SizedBox(height: 20),
                          AddUsers(
                            account: account,
                            repository: settingsRepo,
                          ),
                        ],
                      ],
                    );

                    final trailingColumn = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        warningsSection,
                        if (userName.userLevel.rank >=
                            UserLevel.musher.rank) ...[
                          const SizedBox(height: 20),
                          const PaymentSettingsWidget(),
                        ],
                        const SizedBox(height: 20),
                        const UserSettings(),
                      ],
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Wrap(
                            spacing: 14,
                            runSpacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Workspace settings",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              _SettingsStatChip(
                                label: "Custom fields",
                                value: settings.customFieldTemplates.length
                                    .toString(),
                              ),
                              _SettingsStatChip(
                                label: "Warnings",
                                value: settings.globalDistanceWarnings.length
                                    .toString(),
                              ),
                              _SettingsStatChip(
                                label: "Access",
                                value: userName.userLevel.name,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: leadingColumn,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: trailingColumn,
                              ),
                            ],
                          )
                        else ...[
                          leadingColumn,
                          const SizedBox(height: 20),
                          trailingColumn,
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      error: (e, s) {
        BasicLogger().error("Couldn't load settings repo");
        return const Text("Error: couldn't load settings");
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _SettingsStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _SettingsStatChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          children: [
            TextSpan(
              text: "$value ",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(text: label),
          ],
        ),
      ),
    );
  }
}
