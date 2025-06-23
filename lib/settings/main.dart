import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/settings/custom_fields.dart';
import 'package:mush_on/settings/provider.dart';
import 'package:mush_on/settings/save_cancel_buttons.dart';
import 'package:mush_on/shared/distance_warning_widget/main.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:provider/provider.dart';

class SettingsMain extends StatefulWidget {
  static final BasicLogger logger = BasicLogger();
  const SettingsMain({super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Discard Changes?'),
              content: const Text(
                  'You have unsaved changes. Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Stay on page
                  },
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Discard and exit
                  },
                  child: const Text('Discard'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = context.watch<SettingsProvider>();
    SettingsModel settings = settingsProvider.settings;
    return PopScope(
      canPop: !settingsProvider.didSomethingChange,
      onPopInvokedWithResult: (didpop, result) async {
        if (didpop) {
          return;
        }
        final bool shouldPop = await _showExitConfirmationDialog();
        if (shouldPop) {
          // If the user confirmed to discard, then manually pop the route.
          // This will now succeed as we've confirmed the user's intent.
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: settingsProvider.isInitLoading
          ? Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  spacing: 20,
                  children: [
                    TextTitle("Custom fields"),
                    CustomFieldsOptions(
                      customFieldTemplates: settings.customFieldTemplates,
                      onCustomFieldAdded: (newCustomField) =>
                          settingsProvider.addCustomField(newCustomField),
                      onCustomFieldDeleted: (id) =>
                          settingsProvider.deleteCustomField(id),
                    ),
                    SaveCancelButtons(
                      onSavePressed: () async {
                        try {
                          await settingsProvider.saveSettingsToDb();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Settings saved successfully",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            );
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        } catch (e, s) {
                          SettingsMain.logger.error("Couldn't save settings",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(context, "Couldn't save settings"),
                            );
                          }
                        }
                      },
                      onCancelPressed: () async {
                        if (settingsProvider.didSomethingChange) {
                          final bool shouldPop =
                              await _showExitConfirmationDialog();
                          if (shouldPop && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      didSomethingChange: settingsProvider.didSomethingChange,
                    ),
                    TextTitle("Global distance warnings"),
                    DistanceWarningWidget(
                        warnings:
                            settingsProvider.settings.globalDistanceWarnings,
                        onWarningAdded: (warning) async {
                          try {
                            await settingsProvider.addWarning(warning);
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
                            await settingsProvider.editWarning(warning);
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
                            await settingsProvider.removeWarning(id);
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
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}

class ReturnAlertDialog extends StatelessWidget {
  final Function() onCancelled;
  final Function() onConfirm;
  const ReturnAlertDialog(
      {super.key, required this.onCancelled, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Unsaved data"),
      actions: [
        ElevatedButton(
            onPressed: () => onCancelled(), child: Text("No, go back")),
        ElevatedButton(onPressed: onConfirm(), child: Text("Yes, I'm sure"))
      ],
    );
  }
}
