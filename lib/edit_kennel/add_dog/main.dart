import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/add_dog/provider.dart';
import 'package:mush_on/general/loading_overlay.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:provider/provider.dart';

class AddDogMain extends StatelessWidget {
  const AddDogMain({super.key});

  @override
  Widget build(BuildContext context) {
    var dogProvider = context.watch<AddDogProvider>();
    return ListView(
      children: [
        TextField(
          controller: dogProvider.nameController,
          onChanged: (value) {
            dogProvider.updateName(value);
          },
          decoration: InputDecoration(labelText: "Name of the dog"),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            LoadingOverlay.show(context);
            await FirestoreService().addDogToDb(dogProvider.name);
            LoadingOverlay.hide();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Dog has been added"),
                  backgroundColor: Colors.green,
                ),
              );
            }
            dogProvider.updateNameController("");
          },
          icon: Icon(Icons.add),
          label: Text("Add dog"),
        )
      ],
    );
  }
}
