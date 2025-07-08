import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mush_on/general/loading_overlay.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/dog.dart';

// TODO: Possibilty to add multiple dogs.
// TODO: Add other fields to add dog.
class AddDogButton extends StatelessWidget {
  final Dog dog;
  final File? imageData;
  final Function() onDogAdded;
  const AddDogButton({
    super.key,
    required this.dog,
    required this.imageData,
    required this.onDogAdded,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        LoadingOverlay.show(context);
        if (dog.name == "") {
          LoadingOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(context, "You forgot to add the dog name"));
          return;
        }
        try {
          await FirestoreService().addDogToDb(dog, imageData);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(context, "Couldnt add dog to db"));
          }
        }
        LoadingOverlay.hide();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Dog has been added",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
        onDogAdded();
        if (context.mounted) Navigator.of(context).pop();
      },
      icon: Icon(Icons.add),
      label: Text("Add dog"),
    );
  }
}
