import 'package:flutter/material.dart';
import 'package:mush_on/general/loading_overlay.dart';
import 'package:mush_on/kennel/add_dog/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';

// TODO: Possibilty to add multiple dogs.
// TODO: Add other fields to add dog.
class AddDogButton extends StatelessWidget {
  const AddDogButton({
    super.key,
    required this.addDogProvider,
  });

  final AddDogProvider addDogProvider;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        LoadingOverlay.show(context);
        if (addDogProvider.name == "") {
          LoadingOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(context, "You forgot to add the dog name"));
          return;
        }
        try {
          await FirestoreService()
              .addDogToDb(addDogProvider.dog, addDogProvider.imageFile);
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
        addDogProvider.updateNameController("");
        if (context.mounted) Navigator.of(context).pop();
      },
      icon: Icon(Icons.add),
      label: Text("Add dog"),
    );
  }
}
