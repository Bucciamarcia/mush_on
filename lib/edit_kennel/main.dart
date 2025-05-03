import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:provider/provider.dart';

class EditKennelMain extends StatefulWidget {
  const EditKennelMain({super.key});

  @override
  State<EditKennelMain> createState() => _EditKennelMainState();
}

class _EditKennelMainState extends State<EditKennelMain> {
  late List<Dog> dogList;
  late BasicLogger logger;
  @override
  void initState() {
    super.initState();
    logger = BasicLogger();
    dogList = [];
  }

  @override
  Widget build(BuildContext context) {
    var dogProvider = context.watch<DogProvider>();
    if (dogList.isEmpty) {
      setState(() {
        dogList = List.from(dogProvider.dogs);
      });
    }
    return ListView(
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, "/adddog"),
          label: Text("Add a dog"),
          icon: Icon(Icons.add),
        ),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            border: Border.all(color: Colors.grey),
          ),
          child: DogFilterWidget(
            onResult: (v) {
              logger.debug("Len of list: ${v.length}");
              setState(() {
                dogList = v;
              });
            },
          ),
        ),
        ...dogList.map(
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
