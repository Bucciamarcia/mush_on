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
        Text("In what position can it run?"),
        SizedBox(height: 20),
        CheckboxListTile(
          title: Text("Lead"),
          value: dogProvider.runPositions["lead"],
          onChanged: (bool? updateValue) {
            bool finalValue = false;
            if (updateValue == null) {
              finalValue = false;
            } else {
              finalValue = updateValue;
            }
            dogProvider.updatePositions("lead", finalValue);
          },
        ),
        CheckboxListTile(
          title: Text("Swing"),
          value: dogProvider.runPositions["swing"],
          onChanged: (bool? updateValue) {
            bool finalValue = false;
            if (updateValue == null) {
              finalValue = false;
            } else {
              finalValue = updateValue;
            }
            dogProvider.updatePositions("swing", finalValue);
          },
        ),
        CheckboxListTile(
          title: Text("Team"),
          value: dogProvider.runPositions["team"],
          onChanged: (bool? updateValue) {
            bool finalValue = false;
            if (updateValue == null) {
              finalValue = false;
            } else {
              finalValue = updateValue;
            }
            dogProvider.updatePositions("team", finalValue);
          },
        ),
        CheckboxListTile(
          title: Text("Wheel"),
          value: dogProvider.runPositions["wheel"],
          onChanged: (bool? updateValue) {
            bool finalValue = false;
            if (updateValue == null) {
              finalValue = false;
            } else {
              finalValue = updateValue;
            }
            dogProvider.updatePositions("wheel", finalValue);
          },
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            LoadingOverlay.show(context);
            await FirestoreService()
                .addDogToDb(dogProvider.name, dogProvider.runPositions);
            LoadingOverlay.hide();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Dog has been added"),
                backgroundColor: Colors.green,
              ),
            );
            dogProvider.updateNameController("");
            dogProvider.updatePositions("lead", false);
            dogProvider.updatePositions("swing", false);
            dogProvider.updatePositions("team", false);
            dogProvider.updatePositions("wheel", false);
          },
          icon: Icon(Icons.add),
          label: Text("Add dog"),
        )
      ],
    );
  }
}
