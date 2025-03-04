import 'package:flutter/material.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:provider/provider.dart';

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CreateTeamProvider(),
        child: const TemplateScreen(
            title: "Create team", child: CreateTeamMain()));
  }
}
