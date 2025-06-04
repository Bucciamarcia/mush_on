import 'package:flutter/widgets.dart';

import '../services/models.dart';

/// Helper class with the data to pass up the chain in a callback function.
class DogSelection {
  final Dog dog;
  final int teamNumber;
  final int rowNumber;
  final int dogPosition;

  DogSelection(
      {required this.dog,
      required this.teamNumber,
      required this.rowNumber,
      required this.dogPosition});
}

class DogError {
  final String dogId;
  List<DogErrorMessage> dogErrorMessages;

  DogError({required this.dogId, required this.dogErrorMessages});
}

class DogErrorMessage {
  final DogErrorType type;
  final String? details;

  DogErrorMessage({required this.type, this.details});

  String get message {
    if (details == null) {
      return type.message;
    } else {
      return type.message + details!;
    }
  }
}

/// All the errors that a CreateDog can have.
enum DogErrorType {
  duplicate(
      color: Color.fromARGB(255, 255, 0, 0),
      isFatal: true,
      message: "Duplicate dog!"),
  tagPreventing(
      color: Color.fromARGB(255, 255, 0, 0),
      isFatal: true,
      message: "Has tag: ");

  final Color color;
  final String message;
  final bool isFatal;
  const DogErrorType(
      {required this.color, required this.message, required this.isFatal});
}

enum ErrorType {
  fatal(color: Color.fromARGB(255, 255, 170, 170)),
  warning(color: Color.fromARGB(255, 255, 220, 100)),
  none(color: Color.fromARGB(255, 204, 255, 204));

  final Color color;

  const ErrorType({required this.color});
}

/// Operations on the DogError class
class DogErrorRepository {
  /// Adds an error message to a list and returns it.
  ///
  /// If the dogId exists, it will add the error to the list.
  /// If it doesn't, it will create a new DogError entry.
  static List<DogError> addError(
      {required List<DogError> errors,
      required String dogId,
      required DogErrorMessage newError}) {
    DogError? errorToEdit = findById(errors, dogId);
    if (errorToEdit == null) {
      errors.add(DogError(dogId: dogId, dogErrorMessages: [newError]));
      return errors;
    } else {
      // Adds the error to the dog id.
      errorToEdit.dogErrorMessages.add(newError);
      return errors;
    }
  }

  /// Removes errors of a certain type from a DogError.
  static DogError removeErrorType(DogError dogError, DogErrorType type) {
    dogError.dogErrorMessages.removeWhere((e) => e.type == type);
    return dogError;
  }

  /// Finds the DogError with that dog id.
  /// If that dog doesn't have an error, returns null.
  static DogError? findById(List<DogError> errors, String id) {
    for (DogError error in errors) {
      if (error.dogId == id) {
        return error;
      }
    }
    return null;
  }

  /// Returns the worst type of error for this list of error messages.
  /// Ths assume only warning and fatal exist.
  static ErrorType worstErrorType(List<DogErrorMessage> errorMessages) {
    if (errorMessages.isEmpty) {
      return ErrorType.none;
    } else {
      for (DogErrorMessage e in errorMessages) {
        if (e.type.isFatal) {
          return ErrorType.fatal;
        }
      }
      return ErrorType.warning;
    }
  }
}
