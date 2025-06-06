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

/// All the notes that a CreateDog can have.
enum DogNoteType {
  duplicate(
      color: Color.fromARGB(255, 255, 0, 0),
      noteType: NoteType.fatal,
      message: "Duplicate dog!"),
  tagPreventing(
      color: Color.fromARGB(255, 255, 0, 0),
      noteType: NoteType.fatal,
      message: "Has tag: "),
  showTagInBuilder(
    color: Color.fromARGB(255, 100, 149, 237),
    noteType: NoteType.info,
    message: "Tag: ",
  );

  final Color color;
  final String message;
  final NoteType noteType;
  const DogNoteType(
      {required this.color, required this.message, required this.noteType});
}

enum NoteType {
  fatal(color: Color.fromARGB(255, 255, 170, 170)),
  warning(color: Color.fromARGB(255, 255, 220, 100)),
  info(color: Color.fromARGB(255, 100, 149, 237)),
  none(color: Color.fromARGB(255, 144, 238, 144));

  final Color color;

  const NoteType({required this.color});
}

/// Operations on the DogNote class
class DogNoteRepository {
  /// Adds a note message to a list and returns it.
  ///
  /// If the dogId exists, it will add the note to the list.
  /// If it doesn't, it will create a new DogNote entry.
  static List<DogNote> addNote(
      {required List<DogNote> notes,
      required String dogId,
      required DogNoteMessage newNote}) {
    DogNote? noteToEdit = findById(notes, dogId);
    if (noteToEdit == null) {
      notes.add(DogNote(dogId: dogId, dogNoteMessage: [newNote]));
      return notes;
    } else {
      // Adds the note to the dog id.
      noteToEdit.dogNoteMessage.add(newNote);
      return notes;
    }
  }

  /// Removes notes of a certain type from a DogNote.
  static DogNote removeNoteType(DogNote dogNote, DogNoteType type) {
    dogNote.dogNoteMessage.removeWhere((e) => e.type == type);
    return dogNote;
  }

  /// Finds the DogNote with that dog id.
  /// If that dog doesn't have a note, returns null.
  static DogNote? findById(List<DogNote> notes, String id) {
    for (DogNote note in notes) {
      if (note.dogId == id) {
        return note;
      }
    }
    return null;
  }

  /// Returns the worst type of note for this list of note messages.
  /// Ths assume only warning and fatal exist.
  static NoteType worstNoteType(List<DogNoteMessage> noteMessages) {
    if (noteMessages.isEmpty) {
      return NoteType.none;
    } else {
      for (DogNoteMessage e in noteMessages) {
        if (e.type.noteType == NoteType.fatal) {
          return NoteType.fatal;
        }
      }
      for (DogNoteMessage e in noteMessages) {
        if (e.type.noteType == NoteType.warning) {
          return NoteType.warning;
        }
      }
      return NoteType.info;
    }
  }
}
