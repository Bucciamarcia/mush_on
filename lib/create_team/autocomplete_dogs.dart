import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:searchfield/searchfield.dart';

class AutocompleteDogs extends StatelessWidget {
  const AutocompleteDogs({
    super.key,
    required this.autoCompleteKey,
    required this.currentValue,
    required Map<String, Dog> dogsById,
    required this.teamNumber,
    required this.rowNumber,
    required this.positionNumber,
    required this.isDuplicate,
    required this.dogs,
    required this.onDogSelected,
  });

  final ValueKey<String> autoCompleteKey;
  final String? currentValue;
  final int teamNumber;
  final int rowNumber;
  final int positionNumber;
  final bool isDuplicate;
  final List<Dog> dogs;
  final Function(Dog) onDogSelected;
  static final BasicLogger logger = BasicLogger();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField<Dog>(
          key: autoCompleteKey,
          hint: "Select dog",
          suggestions: dogs
              .map((dog) => SearchFieldListItem<Dog>(dog.name, item: dog))
              .toList(),
          onSuggestionTap: (x) {
            if (x.item != null) onDogSelected(x.item!);
          },
        ),
      ],
    );
  }
}
