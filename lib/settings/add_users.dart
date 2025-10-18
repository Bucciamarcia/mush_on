import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:mush_on/shared/text_title.dart';

class AddUsers extends ConsumerStatefulWidget {
  final String account;
  const AddUsers({super.key, required this.account});

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextTitle("Add new user"),
          const SizedBox(height: 8),
          const Text(
            "Allows you to add a new user to this account.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email address",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          DropdownMenu(
            initialSelection: UserLevel.handler,
            label: const Text("User Level"),
            leadingIcon: const Icon(Icons.admin_panel_settings),
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
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async =>
                  await SettingsRepository(account: widget.account).addUser(
                      email: _emailController.text,
                      userLevel: userLevel,
                      senderUser: userName),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Add user"),
            ),
          ),
        ],
      ),
    );
  }
}
