import 'package:flutter/material.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/models/teamgroup.dart';

class CreateTeamScreen extends StatelessWidget {
  final TeamGroup? loadedTeam;

  const CreateTeamScreen({super.key, this.loadedTeam});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
        title: "Create team", child: CreateTeamMain(loadedTeam: loadedTeam));
  }
}
