import 'package:flutter/widgets.dart';

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

