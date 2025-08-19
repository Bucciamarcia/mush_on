import 'package:flutter/material.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:searchfield/searchfield.dart';

class AutocompleteDogs extends StatelessWidget {
  const AutocompleteDogs({
    super.key,
    required this.autoCompleteKey,
    required this.currentValue,
    required this.notes,
    required this.teamNumber,
    required this.rowNumber,
    required this.positionNumber,
    required this.dogs,
    required this.runningDogs,
    required this.onDogSelected,
  });

  final ValueKey<String> autoCompleteKey;
  final String? currentValue;
  final int teamNumber;
  final int rowNumber;
  final int positionNumber;
  final List<Dog> dogs;
  final List<String> runningDogs;
  final List<DogNote> notes;
  final Function(Dog) onDogSelected;
  static final BasicLogger logger = BasicLogger();

  @override
  Widget build(BuildContext context) {
    List<Dog> sortedDogs = sortDogs();
    return Column(
      children: [
        SearchField<Dog>(
          key: autoCompleteKey,
          searchInputDecoration:
              SearchInputDecoration(hint: const Text("Select dog")),
          suggestions: sortedDogs
              .map((dog) => SearchFieldListItem<Dog>(dog.name,
                  key: ValueKey(dog.id),
                  child: Text(
                    formatText(dog),
                    style: TextStyle(color: pickColor(dog)),
                  ),
                  item: dog))
              .toList(),
          onSuggestionTap: (x) {
            if (x.item != null) onDogSelected(x.item!);
          },
        ),
      ],
    );
  }

  /// Takes all the unavailable dogs (with notes) and puts them at the bottom,
  /// preserving the original sort.
  List<Dog> sortDogs() {
    final Set<String?> dogsWithNoteSet = notes.map((e) {
      for (DogNoteMessage m in e.dogNoteMessage) {
        if (m.type.noteType == NoteType.fatal ||
            m.type == DogNoteType.filteredOut) {
          return e.dogId;
        }
      }
    }).toSet();

    final List<Dog> unavailableDogs = [];
    final List<Dog> availableDogs = [];

    for (final dog in dogs) {
      if (dogsWithNoteSet.contains(dog.id) || runningDogs.contains(dog.id)) {
        unavailableDogs.add(dog);
      } else {
        availableDogs.add(dog);
      }
    }
    return [...availableDogs, ...unavailableDogs];
  }

  /// Formats the text with unavailable
  String formatText(Dog dog) {
    DogNote? error = DogNoteRepository.findById(notes, dog.id);
    bool isFatalError = error != null &&
        DogNoteRepository.worstNoteType(error.dogNoteMessage) == NoteType.fatal;

    if (runningDogs.contains(dog.id) || isFatalError || _isFilteredOut(dog)) {
      return "${dog.name} - Unavailable";
    }
    return dog.name;
  }

  /// Picks grey if has fatal notes or is duplicate
  Color pickColor(Dog dog) {
    DogNote? error = DogNoteRepository.findById(notes, dog.id);
    bool isFatalError = error != null &&
        DogNoteRepository.worstNoteType(error.dogNoteMessage) == NoteType.fatal;

    if (runningDogs.contains(dog.id) || isFatalError || _isFilteredOut(dog)) {
      return Colors.grey;
    }
    return Colors.black;
  }

  bool _isFilteredOut(Dog dog) {
    DogNote? dogNote;
    try {
      dogNote = notes.firstWhere((note) => note.dogId == dog.id);
    } catch (e) {
      dogNote = null;
    }
    bool isFilteredOut = false;
    if (dogNote != null) {
      List<DogNoteMessage> messages = dogNote.dogNoteMessage;
      for (DogNoteMessage message in messages) {
        if (message.type == DogNoteType.filteredOut) {
          isFilteredOut = true;
          break;
        }
      }
    }
    return isFilteredOut;
  }
}
