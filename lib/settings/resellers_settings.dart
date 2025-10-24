import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'resellers_settings.g.dart';

class ResellersSettings extends ConsumerStatefulWidget {
  final String account;
  const ResellersSettings({super.key, required this.account});

  @override
  ConsumerState<ResellersSettings> createState() => _ResellersSettingsState();
}

class _ResellersSettingsState extends ConsumerState<ResellersSettings> {
  late TextEditingController _delayController;
  late bool _delayedPaymentAllowed;
  @override
  void initState() {
    super.initState();
    _delayController = TextEditingController();
    _delayedPaymentAllowed = false;
  }

  @override
  void dispose() {
    _delayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logger = BasicLogger();
    final resellerSettingsAsync = ref.watch(resellerSettingsProvider);
    final isSaving = ref.watch(isSavingProvider);

    // Listen for changes and update controllers without setState in build
    ref.listen(resellerSettingsProvider, (previous, next) {
      next.whenData((settings) {
        _delayController.text = settings.paymentDelayDays.toString();
        _delayedPaymentAllowed = settings.allowedDelayedPayment;
      });
    });

    return resellerSettingsAsync.when(
        data: (settings) {
          return Column(
            spacing: 20,
            children: [
              const TextTitle("Reseller settings"),
              TextField(
                controller: _delayController,
                decoration: const InputDecoration(
                    label: Text(
                        "how many days before the tour the reseller must pay")),
              ),
              DropdownMenu<bool>(
                onSelected: (v) {
                  if (v != null) {
                    _delayedPaymentAllowed = v;
                  }
                },
                label: const Text(
                    "Resellers allowed to pay after placing a booking?"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: true, label: "yes"),
                  DropdownMenuEntry(value: false, label: "no"),
                ],
                initialSelection: settings.allowedDelayedPayment,
              ),
              ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final notifier = ref.watch(isSavingProvider.notifier);
                          notifier.change(true);
                          late ResellerSettings obj;
                          try {
                            obj = ResellerSettings(
                                paymentDelayDays:
                                    int.parse(_delayController.text),
                                allowedDelayedPayment: _delayedPaymentAllowed);
                          } catch (e, s) {
                            logger.warning(
                                "Couldn't parse data to reseller settings object",
                                error: e,
                                stackTrace: s);
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context,
                                    "Couldn't save: maybe the number of days is invalid?"));
                            notifier.change(false);
                            return;
                          }
                          try {
                            await saveSettings(obj);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  confirmationSnackbar(
                                      context, "Reseller settings saved!"));
                            }
                          } catch (e, s) {
                            logger.error("Couldn't save settings",
                                error: e, stackTrace: s);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(
                                      context, "Couldn't save settings"));
                            }
                          } finally {
                            notifier.change(false);
                          }
                        },
                  child: isSaving
                      ? const CircularProgressIndicator.adaptive()
                      : const Text("Save settings")),
              const TextTitle("Invite reseller"),
              const Text("Invite a reseller to join your platform"),
              const InviteResellerSnippet(),
            ],
          );
        },
        error: (e, s) {
          logger.error("Couldn't load reseller settings");
          return const Text("Error: couldn't load reseller settings");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }

  Future<void> saveSettings(ResellerSettings settings) async {
    final db = FirebaseFirestore.instance;
    final path = "accounts/${widget.account}/data/settings/resellers/settings";
    final docRef = db.doc(path);
    final logger = BasicLogger();
    try {
      await docRef.set(settings.toJson());
    } catch (e, s) {
      logger.error("Couldn't save settings", error: e, stackTrace: s);
      rethrow;
    }
  }
}

class InviteResellerSnippet extends StatefulWidget {
  const InviteResellerSnippet({super.key});

  @override
  State<InviteResellerSnippet> createState() => _InviteResellerSnippetState();
}

class _InviteResellerSnippetState extends State<InviteResellerSnippet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _discountAmountController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _discountAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _discountAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Reseller email"),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !value.contains("@") ||
                  !value.contains(".")) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _discountAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: "Discount % amount (e.g. 15)", suffix: Text("%")),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a discount amount';
              }
              final discount = double.tryParse(value);
              if (discount == null || discount < 0 || discount > 100) {
                return 'Please enter a discount between 0 (no discount) and 100 (all bookings are free)';
              }
              return null;
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process the invitation logic here
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Invitation sent to ${_emailController.text}')));
                }
              },
              child: const Text("Send Invitation")),
        ],
      ),
    );
  }
}

@riverpod
Stream<ResellerSettings> resellerSettings(Ref ref) async* {
  final account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  final path = "accounts/$account/data/settings/resellers/settings";
  final docRef = db.doc(path);
  yield* docRef.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return const ResellerSettings();
    } else {
      return ResellerSettings.fromJson(data);
    }
  });
}

@riverpod
class IsSaving extends _$IsSaving {
  @override
  bool build() {
    return false;
  }

  void change(bool v) {
    state = v;
  }
}
