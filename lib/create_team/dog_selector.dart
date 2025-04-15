import 'package:flutter/material.dart';
import 'package:mush_on/create_team/autocomplete_dogs.dart';
import 'package:mush_on/create_team/dog_chip_interface.dart';
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
                  child: DogSelectedInterface(
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
