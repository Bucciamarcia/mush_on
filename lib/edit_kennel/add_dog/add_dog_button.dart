import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/add_dog/provider.dart';
import 'package:mush_on/general/loading_overlay.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';

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
          ScaffoldMessenger.of(context)
              .showSnackBar(ErrorSnackbar("You forgot to add the dog name"));
          return;
        }
        try {
          await FirestoreService()
              .addDogToDb(addDogProvider.dog, addDogProvider.imageFile);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(ErrorSnackbar("Couldnt add dog to db"));
          }
        }
        LoadingOverlay.hide();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Dog has been added"),
              backgroundColor: Colors.green,
            ),
          );
        }
        addDogProvider.updateNameController("");
      },
      icon: Icon(Icons.add),
      label: Text("Add dog"),
    );
  }
}
