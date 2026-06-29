import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/invoicing_details_form.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/settings/section_shell.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_payment_settings.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';

class BillingSettingsPage extends StatelessWidget {
  const BillingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "Billing & Payments",
      minUserRank: UserLevel.musher,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 18,
              children: [PaymentSettingsWidget(), InvoicingSettingsWidget()],
            ),
          ),
        ),
      ),
    );
  }
}

class InvoicingSettingsWidget extends ConsumerStatefulWidget {
  const InvoicingSettingsWidget({super.key});

  @override
  ConsumerState<InvoicingSettingsWidget> createState() =>
      _InvoicingSettingsWidgetState();
}

class _InvoicingSettingsWidgetState
    extends ConsumerState<InvoicingSettingsWidget> {
  final _formKey = GlobalKey<FormState>();
  final _legalName = TextEditingController();
  final _address = TextEditingController();
  final _businessId = TextEditingController();
  final _prefix = TextEditingController();
  final _nextNumber = TextEditingController(text: "1");
  bool _invoicingEnabled = false;
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _legalName.dispose();
    _address.dispose();
    _businessId.dispose();
    _prefix.dispose();
    _nextNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kennelInfoAsync = ref.watch(bookingManagerKennelInfoProvider());
    return SettingsSectionShell(
      title: "Invoicing",
      description:
          "Store the legal issuer details and invoice sequence used when invoices are generated.",
      badge: "Invoices",
      child: kennelInfoAsync.when(
        data: (kennelInfo) {
          _syncFromInfo(kennelInfo);
          return Form(
            key: _formKey,
            child: SettingsSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.receipt_long_outlined),
                    title: const Text("Activate invoicing"),
                    subtitle: Text(
                      _invoicingEnabled
                          ? "Invoice data can be configured for future invoice generation."
                          : "Invoices stay disabled, but this setup is available anytime.",
                    ),
                    value: _invoicingEnabled,
                    onChanged: _isSaving
                        ? null
                        : (value) => setState(() => _invoicingEnabled = value),
                  ),
                  if (_invoicingEnabled) ...[
                    InvoicingDetailsForm(
                      legalNameController: _legalName,
                      addressController: _address,
                      businessIdController: _businessId,
                    ),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 280,
                          child: TextFormField(
                            controller: _prefix,
                            decoration: const InputDecoration(
                              labelText: "Invoice number prefix",
                              hintText: "e.g. 2026-",
                              prefixIcon: Icon(Icons.tag_outlined),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: TextFormField(
                            controller: _nextNumber,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "Next invoice number",
                              prefixIcon: Icon(Icons.numbers_outlined),
                            ),
                            validator: _positiveNumberValidator,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _isSaving ? null : _openSetNumberDialog,
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text("Set number"),
                        ),
                      ],
                    ),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _isSaving ? null : () => _save(kennelInfo),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: const Text("Save invoicing"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (e, s) {
          BasicLogger().error(
            "Error loading invoicing settings",
            error: e,
            stackTrace: s,
          );
          return SettingsSurface(child: Text("Error loading invoicing: $e"));
        },
        loading: () => const SettingsSurface(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }

  void _syncFromInfo(BookingManagerKennelInfo? info) {
    if (_initialized) return;
    _initialized = true;
    _invoicingEnabled = info?.invoicingEnabled ?? false;
    _legalName.text = info?.invoiceLegalName ?? "";
    _address.text = info?.invoiceAddress ?? "";
    _businessId.text = info?.invoiceBusinessId ?? "";
    _prefix.text = info?.invoiceNumberPrefix ?? "";
    _nextNumber.text = (info?.nextInvoiceNumber ?? 1).toString();
  }

  String? _positiveNumberValidator(String? value) {
    final number = int.tryParse((value ?? "").trim());
    if (number == null || number < 1) {
      return "Enter a positive number";
    }
    return null;
  }

  Future<void> _openSetNumberDialog() async {
    final controller = TextEditingController(text: _nextNumber.text);
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text("Set invoice number"),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Next invoice number",
              helperText:
                  "This is the next number that will be used for a generated invoice.",
            ),
            validator: _positiveNumberValidator,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() != true) return;
              Navigator.of(context).pop(int.parse(controller.text.trim()));
            },
            child: const Text("Set number"),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;
    setState(() => _nextNumber.text = result.toString());
  }

  Future<void> _save(BookingManagerKennelInfo? kennelInfo) async {
    if (_formKey.currentState?.validate() != true) return;
    final account = await ref.read(accountProvider.future);
    final nextNumber = int.parse(_nextNumber.text.trim());
    setState(() => _isSaving = true);
    try {
      final repo = StripeRepository(account: account);
      await repo.saveBookingManagerInvoicingSettings(
        invoicingEnabled: _invoicingEnabled,
        invoiceLegalName: _legalName.text.trim(),
        invoiceAddress: _address.text.trim(),
        invoiceBusinessId: _businessId.text.trim(),
        invoiceNumberPrefix: _prefix.text.trim(),
        nextInvoiceNumber: nextNumber,
      );
      ref.invalidate(bookingManagerKennelInfoProvider());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(confirmationSnackbar(context, "Invoicing settings saved"));
    } catch (e, s) {
      BasicLogger().error(
        "Couldn't save invoicing settings",
        error: e,
        stackTrace: s,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(context, "Couldn't save invoicing settings"),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
