import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:mush_on/settings/section_shell.dart';

class AddUsers extends ConsumerStatefulWidget {
  final String account;
  final SettingsRepository? repository;
  const AddUsers({super.key, required this.account, this.repository});

  @override
  ConsumerState<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends ConsumerState<AddUsers> {
  late TextEditingController _emailController;
  late UserLevel userLevel;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    userLevel = UserLevel.handler;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;
    if (user == null) {
      return const Text("User not valid");
    }
    final userName = ref.watch(userNameProvider(user.uid)).value;
    if (userName == null) {
      return const Text("Username not valid");
    }
    if (userName.email.isEmpty) {
      return const Text(
          "Your email is empty. You must add a valid email on your profile first.");
    }
    return SettingsSectionShell(
      title: "Add new user",
      description:
          "Invite teammates to this account and set their access level.",
      badge: "Team access",
      child: SettingsSurface(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;

            final emailField = TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email address",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            );

            final roleField = DropdownMenu(
              initialSelection: UserLevel.handler,
              label: const Text("User Level"),
              leadingIcon: const Icon(Icons.admin_panel_settings),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: UserLevel.values
                  .map(
                    (userLevel) => DropdownMenuEntry(
                      value: userLevel,
                      label: userLevel.name,
                    ),
                  )
                  .toList(),
              onSelected: (UserLevel? value) {
                if (value != null) {
                  setState(() {
                    userLevel = value;
                  });
                }
              },
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        "Sender: ${userName.email}",
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: emailField),
                      const SizedBox(width: 16),
                      Expanded(child: roleField),
                    ],
                  )
                else ...[
                  emailField,
                  const SizedBox(height: 16),
                  roleField,
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: isWide ? null : double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      try {
                        await (widget.repository ??
                                SettingsRepository(account: widget.account))
                            .addUser(
                                email: _emailController.text,
                                userLevel: userLevel,
                                senderUser: userName);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(context, "Couldn't invite user"));
                        }
                      }
                    },
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text("Add user"),
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
