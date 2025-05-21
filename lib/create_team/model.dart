import 'package:flutter/widgets.dart';
import 'package:mush_on/services/models.dart';

class DogError {
  final Dog dog;
  List<DogErrorMessage> dogErrorMessages;

  DogError({required this.dog, required this.dogErrorMessages});
}

/// All the errors that a CreateDog can have.
enum DogErrorMessage {
  duplicate(
      color: Color.fromARGB(255, 255, 0, 0),
      isFatal: true,
      message: "Duplicate dog!");

  final Color color;
  final String message;
  final bool isFatal;
  const DogErrorMessage(
      {required this.color, required this.message, required this.isFatal});
}

