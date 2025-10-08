import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/custom_fields.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:mush_on/settings/user_settings.dart';
import 'package:mush_on/shared/distance_warning_widget/main.dart';
import 'package:mush_on/shared/text_title.dart';

import 'stripe/stripe_payment_settings.dart';

class SettingsMain extends ConsumerStatefulWidget {
  static final BasicLogger logger = BasicLogger();
  const SettingsMain({super.key});

  @override
  ConsumerState<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends ConsumerState<SettingsMain> {
  @override
  Widget build(BuildContext context) {
    var settingsAsync = ref.watch(settingsProvider);
    return settingsAsync.when(
      data: (settings) {
        final settingsRepo =
            SettingsRepository(account: ref.watch(accountProvider).value ?? "");
        return SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              spacing: 20,
              children: [
                const TextTitle("Custom fields"),
                CustomFieldsOptions(
                  customFieldTemplates: settings.customFieldTemplates,
                  onCustomFieldAdded: (newCustomField) =>
                      settingsRepo.addCustomField(newCustomField, settings),
                  onCustomFieldDeleted: (id) =>
                      settingsRepo.deleteCustomField(id, settings),
                ),
                const TextTitle("Global distance warnings"),
                DistanceWarningWidget(
                  warnings: settings.globalDistanceWarnings,
                  onWarningAdded: (warning) async {
                    try {
                      await settingsRepo.addDistanceWarning(warning, settings);
                    } catch (e, s) {
                      SettingsMain.logger.error("Couldn't add distance warning",
                          error: e, stackTrace: s);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Couldn't add distance warning"));
                      }
                    }
                  },
                  onWarningEdited: (warning) async {
                    try {
                      await settingsRepo.editDistanceWarning(warning, settings);
                    } catch (e, s) {
                      SettingsMain.logger.error(
                          "Couldn't edit distance warning",
                          error: e,
                          stackTrace: s);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Couldn't edit distance warning"));
                      }
                    }
                  },
                  onWarningRemoved: (id) async {
                    try {
                      await settingsRepo.removeDistanceWarning(id, settings);
                    } catch (e, s) {
                      SettingsMain.logger.error(
                          "Couldn't remove distance warning",
                          error: e,
                          stackTrace: s);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Couldn't remove distance warning"));
                      }
                    }
                  },
                ),
                const PaymentSettingsWidget(),
                const UserSettings(),
              ],
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
