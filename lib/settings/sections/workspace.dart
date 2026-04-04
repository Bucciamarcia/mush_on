import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/custom_fields.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:mush_on/settings/section_shell.dart';
import 'package:mush_on/shared/distance_warning_widget/main.dart';

class WorkspaceSettingsPage extends ConsumerWidget {
  static final BasicLogger logger = BasicLogger();
  const WorkspaceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final account = ref.watch(accountProvider).value;

    if (account == null) {
      return const TemplateScreen(
        title: "Workspace",
        child: Center(child: Text("Account not available")),
      );
    }

    return TemplateScreen(
      title: "Workspace Settings",
      child: settingsAsync.when(
        data: (settings) {
          final settingsRepo = SettingsRepository(account: account);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomFieldsOptions(
                      customFieldTemplates: settings.customFieldTemplates,
                      onCustomFieldAdded: (newCustomField) =>
                          settingsRepo.addCustomField(newCustomField, settings),
                      onCustomFieldDeleted: (id) =>
                          settingsRepo.deleteCustomField(id, settings),
                    ),
                    const SizedBox(height: 24),
                    SettingsSectionShell(
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
                              logger.error("Couldn't add distance warning",
                                  error: e, stackTrace: s);
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
                              logger.error("Couldn't edit distance warning",
                                  error: e, stackTrace: s);
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
                              logger.error("Couldn't remove distance warning",
                                  error: e, stackTrace: s);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(context,
                                        "Couldn't remove distance warning"));
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
