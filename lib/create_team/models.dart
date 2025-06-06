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

class DogNote {
  final String dogId;
  List<DogNoteMessage> dogNoteMessage;

  DogNote({required this.dogId, required this.dogNoteMessage});
}

class DogNoteMessage {
  final DogNoteType type;
  final String? details;

  DogNoteMessage({required this.type, this.details});

  String get message {
    if (details == null) {
      return type.message;
    } else {
      return type.message + details!;
    }
  }
}

/// All the errors that a CreateDog can have.
enum DogNoteType {
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
  const DogNoteType(
      {required this.color, required this.message, required this.isFatal});
}

enum ErrorType {
  fatal(color: Color.fromARGB(255, 255, 170, 170)),
  warning(color: Color.fromARGB(255, 255, 220, 100)),
  none(color: Color.fromARGB(255, 204, 255, 204));

  final Color color;

  const ErrorType({required this.color});
}

/// Operations on the DogNote class
class DogErrorRepository {
  /// Adds an error message to a list and returns it.
  ///
  /// If the dogId exists, it will add the error to the list.
  /// If it doesn't, it will create a new DogNote entry.
  static List<DogNote> addError(
      {required List<DogNote> errors,
      required String dogId,
      required DogNoteMessage newError}) {
    DogNote? errorToEdit = findById(errors, dogId);
    if (errorToEdit == null) {
      errors.add(DogNote(dogId: dogId, dogNoteMessage: [newError]));
      return errors;
    } else {
      // Adds the error to the dog id.
      errorToEdit.dogNoteMessage.add(newError);
      return errors;
    }
  }

  /// Removes errors of a certain type from a DogNote.
  static DogNote removeErrorType(DogNote dogNote, DogNoteType type) {
    dogNote.dogNoteMessage.removeWhere((e) => e.type == type);
    return dogNote;
  }

  /// Finds the DogNote with that dog id.
  /// If that dog doesn't have an error, returns null.
  static DogNote? findById(List<DogNote> errors, String id) {
    for (DogNote error in errors) {
      if (error.dogId == id) {
        return error;
      }
    }
    return null;
  }

  /// Returns the worst type of error for this list of error messages.
  /// Ths assume only warning and fatal exist.
  static ErrorType worstErrorType(List<DogNoteMessage> errorMessages) {
    if (errorMessages.isEmpty) {
      return ErrorType.none;
    } else {
      for (DogNoteMessage e in errorMessages) {
        if (e.type.isFatal) {
          return ErrorType.fatal;
        }
      }
      return ErrorType.warning;
    }
  }
}
