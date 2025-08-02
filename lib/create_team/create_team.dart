import 'package:flutter/material.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/page_template.dart';

class CreateTeamScreen extends StatelessWidget {
  final String? loadedTeamId;

  const CreateTeamScreen({super.key, this.loadedTeamId});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
        title: "Create team",
        child: CreateTeamMain(loadedTeamId: loadedTeamId));
  }
}
