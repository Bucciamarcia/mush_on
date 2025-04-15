import 'package:flutter/material.dart';
import 'package:mush_on/services/models.dart';

class DogSelectedInterface extends StatelessWidget {
  final String currentValue;
  final Map<String, Dog> dogsById;
  final bool isDuplicate;

  const DogSelectedInterface(
      {super.key,
      required this.currentValue,
      required this.dogsById,
      required this.isDuplicate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dogsById[currentValue] != null
            ? Text(dogsById[currentValue]!.name)
            : Text("Dog not found in db"),
        (isDuplicate == true) ? DogDuplicateWarning() : SizedBox.shrink(),
      ],
    );
  }
}

class DogDuplicateWarning extends StatelessWidget {
  const DogDuplicateWarning({
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
