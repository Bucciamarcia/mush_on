import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

class EditKennelMain extends StatelessWidget {
  const EditKennelMain({super.key});

  @override
  Widget build(BuildContext context) {
    var dogProvider = context.watch<DogProvider>();

    return ListView(
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, "/adddog"),
          label: Text("Add a dog"),
          icon: Icon(Icons.add),
        ),
        ...dogProvider.dogs.map(
          (dog) => DogCard(dog: dog),
        ),
      ],
    );
  }
}

class DogCard extends StatelessWidget {
  final Dog dog;
  const DogCard({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, "/dog", arguments: dog),
        child: Text(dog.name));
  }
}
