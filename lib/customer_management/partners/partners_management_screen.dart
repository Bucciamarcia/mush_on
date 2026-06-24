import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/partners/models.dart';
import 'package:mush_on/customer_management/partners/partners_management_view.dart';
import 'package:mush_on/customer_management/partners/repository.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
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

  Future<void> _save(Partner partner) async {
    try {
      await _repo.savePartner(partner);
      _reload();
    } catch (e, s) {
      BasicLogger().error("Failed to save partner", error: e, stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBar(context, "Failed to save partner"));
      }
    }
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

  Future<void> _openEditor({Partner? partner}) async {
    final result = await showDialog<Partner>(
      context: context,
      builder: (_) => _PartnerEditorDialog(partner: partner),
    );
    if (result != null) await _save(result);
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
              onAdd: () => _openEditor(),
              onEdit: (p) => _openEditor(partner: p),
              onArchive: _archive,
            );
          },
        ),
      ),
    );
  }
}

class _PartnerEditorDialog extends StatefulWidget {
  final Partner? partner;
  const _PartnerEditorDialog({this.partner});

  @override
  State<_PartnerEditorDialog> createState() => _PartnerEditorDialogState();
}

class _PartnerEditorDialogState extends State<_PartnerEditorDialog> {
  late final TextEditingController _name;
  late final TextEditingController _code;
  late final TextEditingController _email;
  late final TextEditingController _discountPercent;
  late final TextEditingController _deferredDays;
  late bool _allowDeferred;

  @override
  void initState() {
    super.initState();
    final p = widget.partner;
    _name = TextEditingController(text: p?.name ?? "");
    _code = TextEditingController(text: p?.code ?? "");
    _email = TextEditingController(text: p?.email ?? "");
    _discountPercent = TextEditingController(
      text: p?.discountRate == null
          ? ""
          : (p!.discountRate! * 100).toStringAsFixed(0),
    );
    _deferredDays = TextEditingController(text: (p?.deferredDays ?? 0).toString());
    _allowDeferred = p?.allowDeferred ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _email.dispose();
    _discountPercent.dispose();
    _deferredDays.dispose();
    super.dispose();
  }

  Partner _build() {
    final percent = double.tryParse(_discountPercent.text.trim());
    final email = _email.text.trim();
    return Partner(
      id: widget.partner?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      code: _code.text.trim(),
      email: email.isEmpty ? null : email,
      discountRate: (percent == null || percent <= 0) ? null : percent / 100.0,
      allowDeferred: _allowDeferred,
      deferredDays: int.tryParse(_deferredDays.text.trim()) ?? 0,
      archived: widget.partner?.archived ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(widget.partner == null ? "Add partner" : "Edit partner"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: "Display name"),
            ),
            TextField(
              controller: _code,
              decoration: const InputDecoration(
                labelText: "Code (used in &partner=...)",
              ),
            ),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "Email (receives payment links)",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _discountPercent,
              decoration: const InputDecoration(
                labelText: "Discount %",
                hintText: "e.g. 10",
              ),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Allow deferred payment"),
              value: _allowDeferred,
              onChanged: (v) => setState(() => _allowDeferred = v),
            ),
            TextField(
              controller: _deferredDays,
              decoration: const InputDecoration(
                labelText: "Days before tour the balance is due",
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_build()),
          child: const Text("Save"),
        ),
      ],
    );
  }
}
