import 'package:flutter/material.dart';
import 'package:mush_on/services/models/dog.dart';

/// Returns an alert dialog of a list of dogs, which can be clicked to go to the dog card.
class DogListAlertDialog extends StatelessWidget {
  final List<Dog> dogs;
  final String title;
  const DogListAlertDialog(
      {super.key, required this.dogs, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(title),
      content: Wrap(
        spacing: 5,
        children: dogs
            .map(
              (dog) => ActionChip(
                label: Text(dog.name),
                onPressed: () =>
                    Navigator.of(context).pushNamed("/dog", arguments: dog.id),
              ),
            )
            .toList(),
      ),
    );
  }
}
