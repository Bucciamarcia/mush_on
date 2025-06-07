import 'package:flutter/material.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

/// This is simply the logic between the main DogSelectedChip
///
/// It will display when a dog in a certain position has been selected
class DogSelectedInterface extends StatelessWidget {
  final Dog dog;
  final List<DogNote> notes;
  final Function() onDogRemoved;

  const DogSelectedInterface(
      {super.key,
      required this.dog,
      required this.notes,
      required this.onDogRemoved});

  @override
  Widget build(BuildContext context) {
    DogNote? dogNote = DogNoteRepository.findById(notes, dog.id);
    return Column(
      children: [
        DogSelectedChip(
          dog: dog,
          dogNote: dogNote,
          onDogRemoved: () => onDogRemoved(),
        ),
        dogNote != null ? NotesList(notes: dogNote) : SizedBox.shrink(),
      ],
    );
  }
}

/// The chip itself, displaying the dog name and info.
class DogSelectedChip extends StatelessWidget {
  final Dog dog;
  final DogNote? dogNote;
  final Function() onDogRemoved;
  static final BasicLogger logger = BasicLogger();
  const DogSelectedChip(
      {super.key,
      required this.dog,
      required this.onDogRemoved,
      required this.dogNote});

  @override
  Widget build(BuildContext context) {
    NoteType noteType = DogNoteRepository.worstNoteType(
        dogNote == null ? [] : dogNote!.dogNoteMessage);
    return InputChip(
      padding: EdgeInsets.all(10),
      backgroundColor:
          _isOnlyFilteredOut(dogNote) ? NoteType.none.color : noteType.color,
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

class NotesList extends StatelessWidget {
  final DogNote notes;
  const NotesList({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    if (_isOnlyFilteredOut(notes)) {
      return SizedBox.shrink();
    } else {
      DogNoteRepository.removeNoteType(notes, DogNoteType.filteredOut);
      if (notes.dogNoteMessage.isEmpty) return SizedBox.shrink();
      return Column(
        children: notes.dogNoteMessage
            .map((e) => Text(
                  e.message,
                  style: TextStyle(color: e.type.color),
                ))
            .toList(),
      );
    }
  }
}

// Returns true if the only note type is filtered out.
bool _isOnlyFilteredOut(DogNote? note) {
  if (note == null) return false;
  List<DogNoteMessage> messages = note.dogNoteMessage;

  // If there's more than 1 message, filtered out can't be the only one.
  if (messages.length != 1) return false;

  // Now check if the only message is a filtered out.
  if (messages.first.type == DogNoteType.filteredOut) return true;
  return false;
}
