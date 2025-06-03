import 'package:flutter/material.dart';
import 'package:mush_on/create_team/model.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

/// This is simply the logic between the main DogSelectedChip
///
/// It will display when a dog in a certain position has been selected
class DogSelectedInterface extends StatelessWidget {
  final Dog dog;
  final List<DogError> errors;
  final Function() onDogRemoved;

  const DogSelectedInterface(
      {super.key,
      required this.dog,
      required this.errors,
      required this.onDogRemoved});

  @override
  Widget build(BuildContext context) {
    DogError? dogError = DogErrorRepository.findById(errors, dog.id);
    return Column(
      children: [
        DogSelectedChip(
          dog: dog,
          errorType: DogErrorRepository.worstErrorType(
              dogError == null ? [] : dogError.dogErrorMessages),
          onDogRemoved: () => onDogRemoved(),
        ),
        dogError != null ? ErrorsList(errors: dogError) : SizedBox.shrink(),
      ],
    );
  }
}

/// The chip itself, displaying the dog name and info.
class DogSelectedChip extends StatelessWidget {
  final Dog dog;
  final ErrorType errorType;
  final Function() onDogRemoved;
  static final BasicLogger logger = BasicLogger();
  const DogSelectedChip(
      {super.key,
      required this.dog,
      required this.onDogRemoved,
      required this.errorType});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      padding: EdgeInsets.all(10),
      backgroundColor: errorType.color,
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

class ErrorsList extends StatelessWidget {
  final DogError errors;
  const ErrorsList({super.key, required this.errors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: errors.dogErrorMessages
          .map((e) => Text(
                e.message,
                style: TextStyle(color: e.color),
              ))
          .toList(),
    );
  }
}
