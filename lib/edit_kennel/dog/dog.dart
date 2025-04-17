import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/dog/provider.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class DogScreen extends StatelessWidget {
  final TeamGroup? loadedTeam;
  final Dog dog;

  const DogScreen({super.key, this.loadedTeam, required this.dog});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SingleDogProvider(),
      child: TemplateScreen(
        title: "Create team",
        child: DogMain(dog: dog),
      ),
    );
  }
}
