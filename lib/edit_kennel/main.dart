import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:provider/provider.dart';

class EditKennelMain extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
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
              if (v.isEmpty) logger.debug("Empty list");
              String toPrint = "";
              for (Dog d in v) {
                toPrint = "$toPrint, ${d.name}";
              }
              logger.debug("RESULT of filter: $toPrint");
            },
          ),
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, "/dog", arguments: dog),
        child: Text(dog.name));
  }
}
