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

  static const positionOrder = ["lead", "swing", "team", "wheel"];

  @override
  Widget build(BuildContext context) {
    final activePositions = positionOrder
        .where((position) => dog.positions[position] == true)
        .join(', ');

    return Card(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  Text(dog.name),
                  Text(activePositions),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                dog.deleteDog();
              },
            ),
          )
        ],
      ),
    );
  }
}
