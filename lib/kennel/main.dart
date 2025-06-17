import 'package:flutter/material.dart';
import 'package:mush_on/kennel/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:provider/provider.dart';

class EditKennelMain extends StatelessWidget {
  static BasicLogger logger = BasicLogger();
  const EditKennelMain({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<MainProvider>();
    var kennelProvider = context.watch<KennelProvider>();
    // INFO: This plugin doesn't differentiate between inactive filter and filter returning no results.
    // INFO: Ideally it should differentiate with a nullable List<Dog>?, but since I want to dispaly all dogs anyways,
    // INFO: It treats no filter and empty filter the same way.
    // INFO: Keep in mind if want different behaviour in future.
    var dd = provider.dogs;
    dd.sort((a, b) => a.name.compareTo(b.name));
    List<Dog> dogList = (kennelProvider.displayDogList.isEmpty)
        ? dd
        : kennelProvider.displayDogList;
    return ListView(
      children: [
        Card(
          child: ExpansionTile(
            title: Text("Filter dogs"),
            children: [
              DogFilterWidget(
                dogs: provider.dogs,
                templates: provider.settings.customFieldTemplates,
                onResult: (v) {
                  logger.debug("Len of list: ${v.length}");
                  // TODO: This now only orders by alpabetical order.
                  // TODO: Ordering should be done by dog fiter.
                  kennelProvider.setDisplayDogList(v);
                  if (v.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(
                        context, "Search came up empty. Showing all dogs"));
                  }
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
