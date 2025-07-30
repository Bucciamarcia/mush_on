import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

import '../models.dart';
import '../riverpod.dart';
import 'dog_selector.dart';

class PairRetriever extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final int teamNumber;
  final int rowNumber;
  final List<TeamWorkspace> teams;
  final List<Dog> dogs;
  final List<String> runningDogs;
  final List<DogNote> notes;
  final Function(DogSelection) onDogSelected;
  final Function(int, int) onRowRemoved;
  final Function(int, int, int) onDogRemoved;
  const PairRetriever(
      {super.key,
      required this.teamNumber,
      required this.rowNumber,
      required this.notes,
      required this.teams,
      required this.dogs,
      required this.runningDogs,
      required this.onDogSelected,
      required this.onRowRemoved,
      required this.onDogRemoved});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DogSelector(
          teamNumber: teamNumber,
          rowNumber: rowNumber,
          teams: teams,
          positionNumber: 0,
          dogs: dogs,
          runningDogs: runningDogs,
          notes: notes,
          onDogSelected: (Dog newDog) => onDogSelected(
            DogSelection(
                dog: newDog,
                rowNumber: rowNumber,
                teamNumber: teamNumber,
                dogPosition: 0),
          ),
          onDogRemoved: (teamNumber, rowNumber) =>
              onDogRemoved(teamNumber, rowNumber, 0),
        ),
        Text(" - "),
        DogSelector(
          teamNumber: teamNumber,
          rowNumber: rowNumber,
          teams: teams,
          notes: notes,
          positionNumber: 1,
          dogs: dogs,
          runningDogs: runningDogs,
          onDogSelected: (Dog newDog) => onDogSelected(
            DogSelection(
                dog: newDog,
                rowNumber: rowNumber,
                teamNumber: teamNumber,
                dogPosition: 1),
          ),
          onDogRemoved: (teamNumber, rowNumber) =>
              onDogRemoved(teamNumber, rowNumber, 1),
        ),
        IconButton(
          key: Key("Row remover: $teamNumber - $rowNumber"),
          onPressed: () {
            onRowRemoved(teamNumber, rowNumber);
          },
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Theme.of(context).colorScheme.error,
            ),
            child: Icon(
              Icons.remove,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
      ],
    );
  }
}
