import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/customer_management/partners/models.dart';
import 'package:mush_on/customer_management/partners/partners_management_view.dart';
import 'package:mush_on/customer_management/partners/repository.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/settings/invoicing_details_form.dart';
import 'package:mush_on/settings/section_shell.dart';
import 'package:uuid/uuid.dart';

class PartnersManagementScreen extends ConsumerStatefulWidget {
  const PartnersManagementScreen({super.key});

  @override
  ConsumerState<PartnersManagementScreen> createState() =>
      _PartnersManagementScreenState();
}

class _PartnersManagementScreenState
    extends ConsumerState<PartnersManagementScreen> {
  Future<List<Partner>>? _future;
  String? _account;

  PartnersRepository get _repo => PartnersRepository(account: _account!);

  void _reload() {
    setState(() {
      _future = _repo.fetchPartners();
    });
  }

  Future<void> _archive(Partner partner) async {
    try {
      await _repo.archivePartner(partner.id);
      _reload();
    } catch (e, s) {
      BasicLogger().error("Failed to archive partner", error: e, stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBar(context, "Failed to archive partner"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider).value;
    if (account == null) {
      return const TemplateScreen(
        title: "Partners",
        minUserRank: UserLevel.musher,
        child: Center(child: Text("Account not available")),
      );
    }
    if (_account != account) {
      _account = account;
      _future = _repo.fetchPartners();
    }

    return TemplateScreen(
      title: "Partners",
      minUserRank: UserLevel.musher,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: FutureBuilder<List<Partner>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            final partners = snapshot.data ?? const <Partner>[];
            return PartnersManagementView(
              partners: partners,
              onAdd: () async {
                context.goNamed("partnerAdd");
              },
              onEdit: (p) async {
                context.goNamed(
                  "partnerEdit",
                  pathParameters: {"partnerId": p.id},
                );
              },
              onArchive: _archive,
            );
          },
        ),
      ),
    );
  }
}

class PartnerEditorScreen extends ConsumerStatefulWidget {
  final String? partnerId;
  const PartnerEditorScreen({super.key, this.partnerId});

  @override
  ConsumerState<PartnerEditorScreen> createState() =>
      _PartnerEditorScreenState();
}

class _PartnerEditorScreenState extends ConsumerState<PartnerEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _code;
  late final TextEditingController _email;
  late final TextEditingController _discountPercent;
  late final TextEditingController _deferredDays;
  late final TextEditingController _invoiceLegalName;
  late final TextEditingController _invoiceAddress;
  late final TextEditingController _invoiceBusinessId;
  late bool _allowDeferred;
  late bool _invoiceEnabled;
  late bool _reverseChargeVat;
  Future<Partner?>? _partnerFuture;
  String? _account;
  bool _initialized = false;
  bool _isSaving = false;

  bool get _isEditing => widget.partnerId != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _code = TextEditingController();
    _email = TextEditingController();
    _discountPercent = TextEditingController();
    _deferredDays = TextEditingController(text: "0");
    _invoiceLegalName = TextEditingController();
    _invoiceAddress = TextEditingController();
    _invoiceBusinessId = TextEditingController();
    _allowDeferred = false;
    _invoiceEnabled = false;
    _reverseChargeVat = false;
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _email.dispose();
    _discountPercent.dispose();
    _deferredDays.dispose();
    _invoiceLegalName.dispose();
    _invoiceAddress.dispose();
    _invoiceBusinessId.dispose();
    super.dispose();
  }

  void _initializeFromPartner(Partner? partner) {
    if (_initialized) return;
    _initialized = true;
    final p = partner;
    _name.text = p?.name ?? "";
    _code.text = p?.code ?? "";
    _email.text = p?.email ?? "";
    _discountPercent.text = p?.discountRate == null
        ? ""
        : (p!.discountRate! * 100).toStringAsFixed(0);
    _deferredDays.text = (p?.deferredDays ?? 0).toString();
    _invoiceLegalName.text = p?.invoiceLegalName ?? "";
    _invoiceAddress.text = p?.invoiceAddress ?? "";
    _invoiceBusinessId.text = p?.invoiceBusinessId ?? "";
    _allowDeferred = p?.allowDeferred ?? false;
    _invoiceEnabled = p?.invoiceEnabled ?? false;
    _reverseChargeVat = p?.reverseChargeVat ?? false;
  }

  Partner _buildPartner(Partner? current) {
    final percent = double.tryParse(_discountPercent.text.trim());
    final email = _email.text.trim();
    return Partner(
      id: current?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      code: _code.text.trim(),
      email: email.isEmpty ? null : email,
      discountRate: (percent == null || percent <= 0) ? null : percent / 100.0,
      allowDeferred: _allowDeferred,
      deferredDays: int.tryParse(_deferredDays.text.trim()) ?? 0,
      invoiceEnabled: _invoiceEnabled,
      invoiceLegalName: _invoiceLegalName.text.trim(),
      invoiceAddress: _invoiceAddress.text.trim(),
      invoiceBusinessId: _invoiceBusinessId.text.trim(),
      reverseChargeVat: _reverseChargeVat,
      archived: current?.archived ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider).value;
    if (account == null) {
      return const TemplateScreen(
        title: "Partner",
        minUserRank: UserLevel.musher,
        child: Center(child: Text("Account not available")),
      );
    }
    if (_account != account) {
      _account = account;
      _partnerFuture = _isEditing
          ? PartnersRepository(account: account).fetchPartner(widget.partnerId!)
          : Future.value(null);
      _initialized = false;
    }

    return TemplateScreen(
      title: _isEditing ? "Edit partner" : "Add partner",
      minUserRank: UserLevel.musher,
      child: FutureBuilder<Partner?>(
        future: _partnerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final partner = snapshot.data;
          if (_isEditing && partner == null) {
            return const Center(child: Text("Partner not found"));
          }
          _initializeFromPartner(partner);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 18,
                    children: [
                      SettingsSectionShell(
                        title: "Partner details",
                        description:
                            "Set the reseller identity, booking code, payment contact, and commercial terms.",
                        badge: "Partner",
                        child: SettingsSurface(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 14,
                            children: [
                              TextFormField(
                                controller: _name,
                                decoration: const InputDecoration(
                                  labelText: "Display name",
                                  prefixIcon: Icon(Icons.handshake_outlined),
                                ),
                              ),
                              TextFormField(
                                controller: _code,
                                decoration: const InputDecoration(
                                  labelText: "Code (used in &partner=...)",
                                  prefixIcon: Icon(Icons.link_outlined),
                                ),
                              ),
                              TextFormField(
                                controller: _email,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  helperText:
                                      "Used for payment and invoice sending. Not printed on invoices.",
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  SizedBox(
                                    width: 220,
                                    child: TextFormField(
                                      controller: _discountPercent,
                                      decoration: const InputDecoration(
                                        labelText: "Discount %",
                                        hintText: "e.g. 10",
                                        prefixIcon: Icon(
                                          Icons.percent_outlined,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 320,
                                    child: TextFormField(
                                      controller: _deferredDays,
                                      decoration: const InputDecoration(
                                        labelText:
                                            "Days before tour balance is due",
                                        prefixIcon: Icon(
                                          Icons.calendar_month_outlined,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Allow deferred payment"),
                                subtitle: const Text(
                                  "The partner can reserve seats now and pay later.",
                                ),
                                value: _allowDeferred,
                                onChanged: _isSaving
                                    ? null
                                    : (v) => setState(() => _allowDeferred = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SettingsSectionShell(
                        title: "Partner invoicing",
                        description:
                            "Store the legal recipient details used when this partner is invoiced.",
                        badge: "Invoices",
                        child: SettingsSurface(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 16,
                            children: [
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                secondary: const Icon(
                                  Icons.receipt_long_outlined,
                                ),
                                title: const Text("Activate invoice"),
                                subtitle: const Text(
                                  "Future partner bookings can generate invoices for this business.",
                                ),
                                value: _invoiceEnabled,
                                onChanged: _isSaving
                                    ? null
                                    : (v) =>
                                          setState(() => _invoiceEnabled = v),
                              ),
                              if (_invoiceEnabled)
                                InvoicingDetailsForm(
                                  legalNameController: _invoiceLegalName,
                                  addressController: _invoiceAddress,
                                  businessIdController: _invoiceBusinessId,
                                ),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                secondary: const Icon(
                                  Icons.public_off_outlined,
                                ),
                                title: const Text("Reverse charge VAT"),
                                subtitle: const Text(
                                  "If checked, VAT will be removed from this partner's invoice under EU's reverse charge regulations",
                                ),
                                value: _reverseChargeVat,
                                onChanged: _isSaving
                                    ? null
                                    : (v) => setState(
                                        () => _reverseChargeVat = v ?? false,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSaving
                                ? null
                                : () => _closeEditor(context),
                            child: const Text("Cancel"),
                          ),
                          FilledButton.icon(
                            onPressed: _isSaving
                                ? null
                                : () => _savePartner(partner),
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: const Text("Save partner"),
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
      ),
    );
  }

  Future<void> _savePartner(Partner? current) async {
    if (_formKey.currentState?.validate() != true) return;
    final account = ref.read(accountProvider).value;
    if (account == null) return;
    setState(() => _isSaving = true);
    try {
      final partner = _buildPartner(current);
      await PartnersRepository(account: account).savePartner(partner);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(confirmationSnackbar(context, "Partner saved"));
      _closeEditor(context);
    } catch (e, s) {
      BasicLogger().error("Failed to save partner", error: e, stackTrace: s);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "Failed to save partner"));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _closeEditor(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go("/client_management/partners");
    }
  }
}
