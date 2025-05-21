import 'package:flutter/widgets.dart';
import 'package:mush_on/services/models.dart';

/// Represents a dog in the create team display widget.
/// Contains the dog itself, and the list of errors it needs to display.
class CreateDog {
  final Dog dog;
  List<SearchDogError> errors;
  CreateDog({required this.dog, required this.errors});
}

/// All the errors that a CreateDog can have.
enum SearchDogError {
  duplicate(
      color: Color.fromARGB(255, 255, 0, 0),
      isFatal: true,
      message: "Duplicate dog!");

  final Color color;
  final String message;
  final bool isFatal;
  const SearchDogError(
      {required this.color, required this.message, required this.isFatal});
}

