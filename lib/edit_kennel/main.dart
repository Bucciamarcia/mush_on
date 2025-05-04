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
  late List<Dog> initialDogList;
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
    setState(() {
      initialDogList = List.from(dogProvider.dogs);
    });
    if (dogList.isEmpty) {
      setState(() {
        dogList = List.from(dogProvider.dogs);
      });
    }
    return ListView(
      children: [
        Card(
          child: ExpansionTile(
            title: Text("Filter dogs"),
            children: [
              DogFilterWidget(
                dogs: initialDogList,
                onResult: (v) {
                  logger.debug("Len of list: ${v.length}");
                  if (v.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar(
                        "Search came up empty. Showing all dogs"));
                  }
                  setState(() {
                    dogList = v;
                  });
                },
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, "/adddog"),
          label: Text("Add a dog"),
          icon: Icon(Icons.add),
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
