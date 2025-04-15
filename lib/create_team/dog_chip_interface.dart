import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

/// This is simply the logic between the main DogSelectedChip
/// And the DogChipWarnings if the dog is duplicate
/// (will turn into generic warnings in future)
class DogSelectedInterface extends StatelessWidget {
  final Dog dog;
  final bool isDuplicate;
  final Function() onDogRemoved;

  const DogSelectedInterface(
      {super.key,
      required this.dog,
      required this.isDuplicate,
      required this.onDogRemoved});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DogSelectedChip(
          dog: dog,
          onDogRemoved: () => onDogRemoved(),
        ),
        (isDuplicate == true) ? DogChipWarnings() : SizedBox.shrink(),
      ],
    );
  }
}

/// The chip itself, displaying the dog name and info.
class DogSelectedChip extends StatelessWidget {
  final Dog dog;
  final Function() onDogRemoved;
  static final BasicLogger logger = BasicLogger();
  const DogSelectedChip(
      {super.key, required this.dog, required this.onDogRemoved});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      padding: EdgeInsets.all(10),
      backgroundColor: Colors.green[200],
      side: BorderSide(color: Colors.greenAccent, width: 3),
      key: Key("DogSelectedChip - ${dog.id}"),
      label: Text(
        dog.name,
        overflow: TextOverflow.fade,
        softWrap: true,
        maxLines: 2,
      ),
      onDeleted: () => onDogRemoved(),
    );
  }
}

/// The warning for duplicate dogs. Will turn into generic warnings.
class DogChipWarnings extends StatelessWidget {
  const DogChipWarnings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "this dog is duplicate!",
      overflow: TextOverflow.visible,
      softWrap: true,
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}
