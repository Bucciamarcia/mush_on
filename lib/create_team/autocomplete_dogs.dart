import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

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
  }) : _dogsById = dogsById;

  final ValueKey<String> autoCompleteKey;
  final String? currentValue;
  final Map<String, Dog> _dogsById;
  final int teamNumber;
  final int rowNumber;
  final int positionNumber;
  final bool isDuplicate;
  final List<Dog> dogs;
  final Function(Dog) onDogSelected;
  static final BasicLogger logger = BasicLogger();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Autocomplete<Dog>(
            key: autoCompleteKey,
            displayStringForOption: (Dog dog) => dog.name,
            initialValue: TextEditingValue(
              text: (currentValue != null
                      ? _dogsById[currentValue]?.name
                      : null) ??
                  "",
            ),
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return Focus(
                onFocusChange: (bool isInFocus) {
                  logger.info("Setting dogidvalue on focuschange");
                },
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    key: Key(
                        "Select Dog - $teamNumber - $rowNumber - $positionNumber"),
                    style: TextStyle(fontSize: 14),
                    controller: fieldController,
                    focusNode: focusNode,
                    onSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    decoration: InputDecoration(
                      labelText: "Select a dog",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: isDuplicate ? Colors.red : null,
                    ),
                  ),
                ),
              );
            },
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return dogs;
              } else {
                return dogs.where((option) => option.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              }
            },
            onSelected: (Dog selectedDog) {
              logger.info(
                  "Setting dogidvalue on onselected selecteddog: ${selectedDog.name}");
              onDogSelected(selectedDog);
            },
          ),
        ],
      ),
    );
  }
}
