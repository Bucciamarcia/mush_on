import 'package:flutter/material.dart';
import 'package:mush_on/kennel/dog/provider.dart';
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
      create: (context) {
        final provider = SingleDogProvider();
        provider.initDog(dog);
        return provider;
      },
      child: TemplateScreen(
        title: "Dog page",
        child: DogMain(dog: dog),
      ),
    );
  }
}
