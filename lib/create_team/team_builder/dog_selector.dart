import 'package:flutter/material.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

import 'autocomplete_dogs.dart';
import 'dog_chip_interface.dart';

class DogSelector extends StatefulWidget {
  const DogSelector({
    super.key,
    required this.teamNumber,
    required this.notes,
    required this.rowNumber,
    required this.teams,
    required this.positionNumber,
    required this.dogs,
    required this.runningDogs,
    required this.onDogSelected,
    required this.onDogRemoved,
  });

  final int teamNumber;
  final List<DogNote> notes;
  final int rowNumber;
  final List<TeamWorkspace> teams;
  final int positionNumber;
  final List<Dog> dogs;
  final List<String> runningDogs;
  final Function(Dog newDog) onDogSelected;
  final Function(int p1, int p2) onDogRemoved;

  @override
  State<DogSelector> createState() => _DogSelectorState();
}

class _DogSelectorState extends State<DogSelector> {
  static final BasicLogger logger = BasicLogger();
  late Map<String, Dog> _dogsById;
  bool _errorShown = false;

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

  @override
  void initState() {
    super.initState();
    _dogsById = Dog.dogsById(widget.dogs);

    // Check for missing dogs after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForMissingDog();
    });
  }

  @override
  void didUpdateWidget(covariant DogSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local map if the input list changes
    if (widget.dogs != oldWidget.dogs) {
      _dogsById = Dog.dogsById(widget.dogs);
      _errorShown = false; // Reset error flag when dogs list changes

      // Check again after widget update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkForMissingDog();
      });
    }
  }

  void _checkForMissingDog() {
    String? currentValue = _getCurrentValue();

    if (currentValue != null &&
        currentValue.isNotEmpty &&
        _dogsById[currentValue] == null &&
        !_errorShown &&
        mounted) {
      _errorShown = true;
      logger.error("The dog with ID '$currentValue' is not in the _dogsById");

      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(context,
          "Some dogs from the loaded team are no longer available. They have been removed."));

      // Automatically remove the invalid dog reference
      widget.onDogRemoved(widget.teamNumber, widget.rowNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentValue = _getCurrentValue();

    // If there's a current value but the dog doesn't exist, show empty autocomplete
    if (currentValue != null && currentValue.isNotEmpty) {
      if (_dogsById[currentValue] == null) {
        logger.warning(
            "Dog with ID '$currentValue' not found, showing empty selector");
        // Don't show error here - it will be handled in the post-frame callback
        currentValue = null; // Treat as empty
      }
    }

    final autoCompleteKey = ValueKey(
        '${widget.teamNumber}_${widget.rowNumber}_${widget.positionNumber}_$currentValue');

    return Expanded(
      child: (currentValue != null &&
              currentValue.isNotEmpty &&
              _dogsById[currentValue] != null)
          // If a Dog is selected and exists, show the interface with chip and notes.
          ? DogSelectedInterface(
              dog: _dogsById[currentValue]!,
              notes: widget.notes,
              onDogRemoved: () =>
                  widget.onDogRemoved(widget.teamNumber, widget.rowNumber),
            )
          // If no dog is selected for this position, show the autocomplete with textfield.
          : AutocompleteDogs(
              autoCompleteKey: autoCompleteKey,
              currentValue:
                  null, // Always pass null since we've validated above
              notes: widget.notes,
              teamNumber: widget.teamNumber,
              rowNumber: widget.rowNumber,
              positionNumber: widget.positionNumber,
              onDogSelected: widget.onDogSelected,
              dogs: widget.dogs,
              runningDogs: widget.runningDogs),
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
          color: Theme.of(context).colorScheme.error,
        ),
        constraints: BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
