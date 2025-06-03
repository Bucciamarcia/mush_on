import 'package:flutter/widgets.dart';

class DogError {
  final String dogId;
  List<DogErrorMessage> dogErrorMessages;

  DogError({required this.dogId, required this.dogErrorMessages});
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

enum ErrorType {
  fatal(color: Color.fromARGB(255, 255, 170, 170)),
  warning(color: Color.fromARGB(255, 255, 220, 100)),
  none(color: Color.fromARGB(255, 204, 255, 204));

  final Color color;

  const ErrorType({required this.color});
}

/// Operations on the DogError class
class DogErrorRepository {
  /// Adds an error message to a list.
  ///
  /// If the dogId exists, it will add the error to the list.
  /// If it doesn't, it will create a new DogErrr entry.
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
        if (e.isFatal) {
          return ErrorType.fatal;
        }
      }
      return ErrorType.warning;
    }
  }
}
