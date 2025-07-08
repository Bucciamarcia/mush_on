import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/models/teamgroup.dart';

import 'main.dart';

class DogScreen extends StatelessWidget {
  final TeamGroup? loadedTeam;
  final String dog;
  const DogScreen({super.key, this.loadedTeam, required this.dog});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "Dog page",
      child: DogMain(dogId: dog),
    );
  }
}
