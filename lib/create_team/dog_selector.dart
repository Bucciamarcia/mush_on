import 'package:flutter/material.dart';
import 'package:mush_on/create_team/main.dart';
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
  late String? _dogIdValue;
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
    var dogPairReference =
        widget.teams[widget.teamNumber].dogPairs[widget.rowNumber];
    if (widget.positionNumber == 0) {
      _dogIdValue = dogPairReference.firstDogId;
    } else {
      _dogIdValue = dogPairReference.secondDogId;
    }
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
  void setState(VoidCallback fn) {
    super.setState(fn);
    logger.info("Dogsidvalue: $_dogIdValue");
  }

  @override
  Widget build(BuildContext context) {
    String? currentValue = _getCurrentValue();
    bool isDuplicate = widget.duplicateDogs.contains(currentValue);

    final autoCompleteKey = ValueKey(
        '${widget.teamNumber}_${widget.rowNumber}_${widget.positionNumber}_$currentValue');

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Autocomplete<Dog>(
                  key: autoCompleteKey,
                  displayStringForOption: (Dog dog) => dog.name,
                  // Set initial value based on current ID
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
                    // Return the TextField wired with fieldController
                    return Focus(
                      onFocusChange: (bool isInFocus) {
                        logger.info("Setting dogidvalue on focuschange");
                        setState(() {
                          _dogIdValue = fieldController.text;
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          key: Key(
                              "Select Dog - ${widget.teamNumber} - ${widget.rowNumber} - ${widget.positionNumber}"),
                          style: TextStyle(fontSize: 14),
                          controller:
                              fieldController, // Use the one from the builder!
                          focusNode: focusNode,
                          onSubmitted: (String value) {
                            setState(() {
                              logger.info("Setting dogidvalue on onsubmitted");
                              _dogIdValue = fieldController.text;
                            });
                            onFieldSubmitted();
                          },
                          // Remove complex onTap - Autocomplete should handle showing options
                          // onTap: () { ... }
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
                    // Simpler options logic - show all if empty
                    if (textEditingValue.text.isEmpty) {
                      return widget.dogs;
                    } else {
                      return widget.dogs.where((option) => option.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    }
                  },
                  onSelected: (Dog selectedDog) {
                    // Autocomplete updates the controller, just call the callback
                    logger.info(
                        "Setting dogidvalue on onselected selecteddog: ${selectedDog.name}");
                    setState(() => _dogIdValue = selectedDog.name);
                    widget.onDogSelected(selectedDog);
                  },
                ),
                // ... rest of the widget (duplicate text, delete icon) ...
                isDuplicate
                    ? Text(
                        "this dog is duplicate!",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
          (currentValue != null && currentValue.isNotEmpty)
              ? Center(
                  child: IconDeleteDog(
                    teamNumber: widget.teamNumber,
                    rowNumber: widget.rowNumber,
                    positionNumber: widget.positionNumber,
                    // Ensure this callback signature matches IconDeleteDog
                    onDogRemoved: widget
                        .onDogRemoved, // Pass the function directly if signature matches
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
