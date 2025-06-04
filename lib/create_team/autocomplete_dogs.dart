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
    required this.errors,
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
  final List<DogError> errors;
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
              SearchInputDecoration(hint: Text("Select dog")),
          suggestions: sortedDogs
              .map((dog) => SearchFieldListItem<Dog>(dog.name,
                  key: ValueKey(dog.id), // Add a unique key here
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

  /// Takes all the unavailable dogs (with errors) and puts them at the bottom,
  /// preserving the original sort.
  List<Dog> sortDogs() {
    var tp = [];
    for (Dog dog in dogs) {
      tp.add(dog.name);
    }

    final Set<String> dogsWithErrorSet = errors.map((e) => e.dogId).toSet();

    final List<Dog> unavailableDogs = [];
    final List<Dog> availableDogs = [];

    for (final dog in dogs) {
      if (dogsWithErrorSet.contains(dog.id) || runningDogs.contains(dog.id)) {
        unavailableDogs.add(dog);
      } else {
        availableDogs.add(dog);
      }
    }
    return [...availableDogs, ...unavailableDogs];
  }

  /// Formats the text with unavailable
  String formatText(Dog dog) {
    DogError? error = DogErrorRepository.findById(errors, dog.id);
    bool isFatalError = error != null &&
        DogErrorRepository.worstErrorType(error.dogErrorMessages) ==
            ErrorType.fatal;

    if (runningDogs.contains(dog.id) || isFatalError) {
      return "${dog.name} - Unavailable";
    }
    return dog.name;
  }

  /// Picks grey if has fatal errors or is duplicate
  Color pickColor(Dog dog) {
    DogError? error = DogErrorRepository.findById(errors, dog.id);
    bool isFatalError = error != null &&
        DogErrorRepository.worstErrorType(error.dogErrorMessages) ==
            ErrorType.fatal;

    if (runningDogs.contains(dog.id) || isFatalError) {
      return Colors.grey;
    }
    return Colors.black;
  }
}
