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
      create: (context) {
        // Create and initialize the provider before returning it
        final provider = SingleDogProvider();
        // Use a non-notify initialization or schedule the update
        provider.initDog(dog);
        return provider;
      },
      child: TemplateScreen(
        title: dog.name,
        child: DogMain(dog: dog),
      ),
    );
  }
}
