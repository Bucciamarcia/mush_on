import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

class DogSelector extends StatefulWidget {
  const DogSelector({
    super.key,
    required this.teamNumber,
    required this.rowNumber,
    required this.teams,
    required this.positionNumber,
    required this.duplicateDogs,
    required this.dogs,
    required this.onDogSelected,
    required this.onDogRemoved,
  });

  final int teamNumber;
  final int rowNumber;
  final List<Team> teams;
  final int positionNumber;
  final List<String> duplicateDogs;
  final List<Dog> dogs;
  final Function(Dog newDog) onDogSelected;
  final Function(int p1, int p2) onDogRemoved;

  @override
  State<DogSelector> createState() => _DogSelectorState();
}

class _DogSelectorState extends State<DogSelector> {
  static final BasicLogger logger = BasicLogger();

  String? _getCurrentValue() {
    // Ensure indices are valid before accessing
    if (widget.teamNumber < 0 ||
        widget.teamNumber >= widget.teams.length ||
        widget.rowNumber < 0 ||
        widget.rowNumber >= widget.teams[widget.teamNumber].dogPairs.length) {
      // Handle invalid index case, perhaps return null or log an error
      logger.warning(
          "Invalid indices in _getCurrentValue: T${widget.teamNumber}, R${widget.rowNumber}");
      return null;
    }
    if (widget.positionNumber == 0) {
      return widget
          .teams[widget.teamNumber].dogPairs[widget.rowNumber].firstDogId;
    } else {
      return widget
          .teams[widget.teamNumber].dogPairs[widget.rowNumber].secondDogId;
    }
  }

  // Keep dogsById logic if needed, update in didUpdateWidget if widget.dogs changes
  late Map<String, Dog> _dogsById;

  @override
  void initState() {
    super.initState();
    _dogsById = Dog.dogsById(widget.dogs);
  }

  @override
  void didUpdateWidget(covariant DogSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local map if the input list changes
    if (widget.dogs != oldWidget.dogs) {
      _dogsById = Dog.dogsById(widget.dogs);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentValue = _getCurrentValue();
    bool isDuplicate = widget.duplicateDogs.contains(currentValue);

    final autoCompleteKey = ValueKey(
        '${widget.teamNumber}_${widget.rowNumber}_${widget.positionNumber}_$currentValue');

    return Expanded(
      // This Expanded affects the Row's height/width within its parent
      child: Row(
        children: [
          (currentValue != null && currentValue.isNotEmpty)
              ? Expanded(
                  child: DogSelectedChip(
                    currentValue: currentValue,
                    dogsById: _dogsById,
                    isDuplicate: isDuplicate,
                  ),
                )
              : AutocompleteDogs(
                  autoCompleteKey: autoCompleteKey,
                  currentValue: currentValue,
                  dogsById: _dogsById,
                  teamNumber: widget.teamNumber,
                  rowNumber: widget.rowNumber,
                  positionNumber: widget.positionNumber,
                  isDuplicate: isDuplicate,
                  onDogSelected: widget.onDogSelected,
                  dogs: widget.dogs),
          (currentValue != null && currentValue.isNotEmpty)
              ? Center(
                  // Keep the icon size fixed
                  child: IconDeleteDog(
                    teamNumber: widget.teamNumber,
                    rowNumber: widget.rowNumber,
                    positionNumber: widget.positionNumber,
                    onDogRemoved: widget.onDogRemoved,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class DogSelectedChip extends StatelessWidget {
  final String currentValue;
  final Map<String, Dog> dogsById;
  final bool isDuplicate;

  const DogSelectedChip(
      {super.key,
      required this.currentValue,
      required this.dogsById,
      required this.isDuplicate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dogsById[currentValue]?.name ?? "Dog not found in db",
        ),
        (isDuplicate == true) ? DogDuplicateWarning() : SizedBox.shrink(),
      ],
    );
  }
}

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
          isDuplicate ? DogDuplicateWarning() : SizedBox.shrink()
        ],
      ),
    );
  }
}

class DogDuplicateWarning extends StatelessWidget {
  const DogDuplicateWarning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "this dog is duplicate!",
      overflow: TextOverflow.visible,
      softWrap: true,
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}

class IconDeleteDog extends StatelessWidget {
  final int teamNumber;
  final int rowNumber;
  final int positionNumber;
  final Function(int, int) onDogRemoved;

  const IconDeleteDog(
      {super.key,
      required this.teamNumber,
      required this.rowNumber,
      required this.positionNumber,
      required this.onDogRemoved});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: () => onDogRemoved(teamNumber, rowNumber),
        icon: Icon(
          key: Key(
              "Icon delete dog: $teamNumber - $rowNumber - $positionNumber"),
          Icons.delete,
          size: 25,
          color: Colors.red,
        ),
        constraints: BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
