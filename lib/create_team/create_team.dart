import 'package:flutter/material.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

class CreateTeamScreen extends StatelessWidget {
  final TeamGroup? loadedTeam;

  const CreateTeamScreen({super.key, this.loadedTeam});

  @override
  Widget build(BuildContext context) {
    var mainProvider = context.watch<MainProvider>();
    return ChangeNotifierProvider(
        create: (context) => CreateTeamProvider(mainProvider),
        child: TemplateScreen(
            title: "Create team",
            child: CreateTeamMain(loadedTeam: loadedTeam)));
  }
}
