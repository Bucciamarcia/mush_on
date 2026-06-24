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
