import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/shared/loading_overlay.dart';

// TODO: Possibilty to add multiple dogs.
// TODO: Add other fields to add dog.
class AddDogButton extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
          String account = await ref.watch(accountProvider.future);
          await FirestoreService().addDogToDb(dog, imageData, account);
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
      icon: const Icon(Icons.add),
      label: const Text("Add dog"),
    );
  }
}
