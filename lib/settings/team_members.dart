import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:mush_on/settings/section_shell.dart';

/// Lists the members of the kennel and lets an admin remove them.
class TeamMembers extends ConsumerStatefulWidget {
  final String account;
  final SettingsRepository? repository;
  const TeamMembers({super.key, required this.account, this.repository});

  @override
  ConsumerState<TeamMembers> createState() => _TeamMembersState();
}

class _TeamMembersState extends ConsumerState<TeamMembers> {
  late final SettingsRepository _repository =
      widget.repository ?? SettingsRepository(account: widget.account);
  late Future<List<UserName>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _repository.listUsers();
  }

  void _refresh() {
    setState(() {
      _usersFuture = _repository.listUsers();
    });
  }

  Future<void> _confirmAndRemove(UserName member) async {
    final displayName = member.name.isNotEmpty ? member.name : member.email;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove user"),
        content: Text(
          "Remove $displayName from the kennel? They will lose access immediately.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _repository.removeUser(member.uid);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        confirmationSnackbar(context, "User removed from the kennel"),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      final serverMessage = e is FirebaseFunctionsException ? e.message : null;
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          serverMessage != null && serverMessage.isNotEmpty
              ? "Couldn't remove user: $serverMessage"
              : "Couldn't remove user",
        ),
      );
      // The list may be stale (e.g. someone else already removed the user).
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = ref.watch(userProvider).value?.uid;
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsSectionShell(
      title: "Team members",
      description:
          "People with access to this kennel. Removed users keep their login but lose access to the kennel's data.",
      badge: "Team access",
      trailing: IconButton(
        tooltip: "Refresh",
        onPressed: _refresh,
        icon: const Icon(Icons.refresh),
      ),
      child: SettingsSurface(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FutureBuilder<List<UserName>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(18),
                child: Text("Couldn't load team members."),
              );
            }
            final members = snapshot.data ?? [];
            if (members.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(18),
                child: Text("No team members found."),
              );
            }
            return Column(
              children: [
                for (final member in members)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      child: const Icon(Icons.person),
                    ),
                    title: Text(
                      member.name.isNotEmpty ? member.name : member.email,
                    ),
                    subtitle: member.name.isNotEmpty
                        ? Text(member.email)
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _RoleChip(label: member.userLevel.name),
                        const SizedBox(width: 8),
                        if (member.uid == currentUid)
                          const SizedBox(
                            width: 48,
                            child: Center(child: Text("You")),
                          )
                        // Don't offer removal until we know who "you" are.
                        else if (currentUid == null)
                          const SizedBox(width: 48)
                        else
                          IconButton(
                            tooltip: "Remove from kennel",
                            color: colorScheme.error,
                            onPressed: () => _confirmAndRemove(member),
                            icon: const Icon(Icons.person_remove),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  const _RoleChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
