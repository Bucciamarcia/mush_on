import 'package:flutter/material.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/shared/text_title.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({super.key});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
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
    return Column(
      children: [
        TextTitle("Add new user"),
        Text("Allows you to add a new user to this account."),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(label: Text("Email address")),
        ),
        DropdownMenu(
            dropdownMenuEntries: UserLevel.values
                .map((userLevel) =>
                    DropdownMenuEntry(value: userLevel, label: userLevel.name))
                .toList()),
        ElevatedButton(onPressed: () {}, child: Text("Add user")),
      ],
    );
  }
}
