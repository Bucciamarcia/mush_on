import 'package:flutter/material.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';

class CreateTeamScreen extends StatelessWidget {
  final Map<String, dynamic>? loadedTeam;

  const CreateTeamScreen({super.key, this.loadedTeam});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CreateTeamProvider(),
        child: TemplateScreen(
            title: "Create team",
            child: CreateTeamMain(loadedTeam: loadedTeam)));
  }
}
