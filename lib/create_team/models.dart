import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../services/models.dart';
part 'models.freezed.dart';

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

@freezed
sealed class DogNote with _$DogNote {
  const factory DogNote({
    required String dogId,
    required List<DogNoteMessage> dogNoteMessage,
  }) = _DogNote;
}

extension DogNotesExtension on List<DogNote> {
  /// Adds a dog note to the list.
  ///
  /// If the dog already exists, adds a warning to the dog.
  List<DogNote> addOrModify(DogNote newNote) {
    if (_containsDog(this, newNote)) {
      var toReturn = List<DogNote>.from(this);
      var index = toReturn.indexWhere((note) => note.dogId == newNote.dogId);

      var existingNote = toReturn[index];
      var combinedMessages = [
        ...existingNote.dogNoteMessage,
        ...newNote.dogNoteMessage
      ];
      toReturn[index] = existingNote.copyWith(dogNoteMessage: combinedMessages);

      return toReturn;
    } else {
      return [...this, newNote];
    }
  }

  /// Returns a list of DogNotes where at least one note is type note.
  List<DogNote> typeNote() {
    return where(
      (note) {
        for (var n in note.dogNoteMessage) {
          if (n.type.noteType == NoteType.info) {
            return true;
          }
        }
        return false;
      },
    ).toList();
  }

  /// Returns a list of DogNotes where at least one note is type warning.
  List<DogNote> typeWarning() {
    return where(
      (note) {
        for (var n in note.dogNoteMessage) {
          if (n.type.noteType == NoteType.warning) {
            return true;
          }
        }
        return false;
      },
    ).toList();
  }

  /// Returns a list of DogNotes where at least one note is type fatal.
  List<DogNote> typeFatal() {
    return where(
      (note) {
        for (var n in note.dogNoteMessage) {
          if (n.type.noteType == NoteType.fatal) {
            return true;
          }
        }
        return false;
      },
    ).toList();
  }

  bool _containsDog(List<DogNote> notes, DogNote newNote) {
    return notes.any((note) => note.dogId == newNote.dogId);
  }
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
  distanceWarning(
      color: Color.fromARGB(255, 255, 165, 0),
      noteType: NoteType.warning,
      message: ""),
  distanceError(
      color: Color.fromARGB(255, 255, 0, 0),
      noteType: NoteType.fatal,
      message: ""),
  healthEventError(
      color: Color.fromARGB(255, 255, 0, 0),
      noteType: NoteType.fatal,
      message: "Health event: "),

  /// In heat, and cannot run.
  ///
  /// Heats that can run use heatLight.
  heat(
      color: Color.fromARGB(255, 255, 0, 0),
      noteType: NoteType.fatal,
      message: "In heat since: "),

  /// In heat, but can still run (return warning).
  heatLight(
      color: Color.fromARGB(255, 255, 165, 0),
      noteType: NoteType.warning,
      message: "In heat (can run)"),
  showTagInBuilder(
    color: Color.fromARGB(255, 100, 149, 237),
    noteType: NoteType.info,
    message: "Tag: ",
  ),

  filteredOut(
    color: Color.fromARGB(255, 45, 45, 45),
    noteType: NoteType.info,
    message: "Filtered out",
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
    var newdnm = List<DogNoteMessage>.from(dogNote.dogNoteMessage);
    newdnm.removeWhere((e) => e.type == type);
    return dogNote.copyWith(dogNoteMessage: newdnm);
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
