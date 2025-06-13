import 'package:flutter/material.dart';
import 'package:mush_on/kennel/add_dog/provider.dart';

class DogNameWidget extends StatelessWidget {
  const DogNameWidget({
    super.key,
    required this.addDogProvider,
  });

  final AddDogProvider addDogProvider;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: addDogProvider.nameController,
      onChanged: (value) {
        addDogProvider.updateName(value);
      },
      decoration: InputDecoration(labelText: "Name of the dog"),
    );
  }
}
