import 'package:flutter/material.dart';
import 'package:mush_on/customer_management/partners/models.dart';

/// Thin presentational widget for managing partners (resellers).
///
/// Renders only [PartnersExtension.active] by default, with a toggle to reveal
/// archived ones. Each active row has an "Edit" and an "Archive" action.
/// There is intentionally NO delete action anywhere — partners are archived,
/// never deleted, to preserve history and allow recovery.
class PartnersManagementView extends StatefulWidget {
  final List<Partner> partners;
  final void Function() onAdd;
  final void Function(Partner) onEdit;
  final void Function(Partner) onArchive;

  const PartnersManagementView({
    super.key,
    required this.partners,
    required this.onAdd,
    required this.onEdit,
    required this.onArchive,
  });

  @override
  State<PartnersManagementView> createState() => _PartnersManagementViewState();
}

class _PartnersManagementViewState extends State<PartnersManagementView> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final visible = _showArchived
        ? widget.partners
        : widget.partners.active;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              "Partners",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              key: const Key('partners-help'),
              tooltip: 'How partners work',
              icon: const Icon(Icons.help_outline),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const PartnersHelpDialog(),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Text("Show archived"),
                Switch(
                  value: _showArchived,
                  onChanged: (value) =>
                      setState(() => _showArchived = value),
                ),
              ],
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              key: const Key('add-partner'),
              onPressed: widget.onAdd,
              icon: const Icon(Icons.add),
              label: const Text("Add partner"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [
              for (final partner in visible)
                ListTile(
                  key: Key('partner-${partner.id}'),
                  title: Text(partner.name),
                  subtitle: Text(partner.code),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        key: Key('edit-${partner.id}'),
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit),
                        onPressed: () => widget.onEdit(partner),
                      ),
                      if (!partner.archived)
                        IconButton(
                          key: Key('archive-${partner.id}'),
                          tooltip: 'Archive',
                          icon: const Icon(Icons.archive),
                          onPressed: () => widget.onArchive(partner),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Explains what partners (resellers) are and how to work with them.
/// Shown from the "?" button in the partners header.
class PartnersHelpDialog extends StatelessWidget {
  const PartnersHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog.adaptive(
      title: const Text("How partners work"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "A partner is a reseller (e.g. a hotel or tour agency) who books "
              "tours on behalf of their own customers. Each partner gets their "
              "own booking link that automatically applies their agreed "
              "discount.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const _HelpSection(
              icon: Icons.link,
              title: "1. Give them their link",
              body: "Take your public booking link and add "
                  "&partner=<code> to the end, using the partner's "
                  "Code (the field shown when you add or edit a partner).\n\n"
                  "Example:\n"
                  "/booking?kennel=<account>&tourId=<tour>&partner=acme\n\n"
                  "Anyone who books through that link is tracked as this "
                  "partner's booking.",
            ),
            const SizedBox(height: 12),
            const _HelpSection(
              icon: Icons.percent,
              title: "2. The discount is automatic",
              body: "The discount % you set is applied server-side to the "
                  "whole order — the customer never types a code, and the "
                  "discounted total is what gets charged.",
            ),
            const SizedBox(height: 12),
            const _HelpSection(
              icon: Icons.schedule_send,
              title: "3. Pay now or pay later",
              body: "If \"Allow deferred payment\" is on, the partner can "
                  "reserve seats now and pay later by invoice. The payment "
                  "link and reminders always go to the partner's email, and "
                  "the balance is due the set number of days before the tour. "
                  "If deferral is off, they pay immediately by card.",
            ),
            const SizedBox(height: 12),
            const _HelpSection(
              icon: Icons.archive_outlined,
              title: "4. Archive, never delete",
              body: "Partners can't be deleted — archive one to hide it while "
                  "keeping its booking history and stats. Toggle \"Show "
                  "archived\" to see archived partners.",
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Got it"),
        ),
      ],
    );
  }
}

class _HelpSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _HelpSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(body, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
