import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/firestore_dogs_to_id.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';
import 'save_teams_button.dart';
import 'select_datetime.dart';

class CreateTeamMain extends StatefulWidget {
  final TeamGroup? loadedTeam;
  const CreateTeamMain({super.key, this.loadedTeam});

  @override
  State<CreateTeamMain> createState() => _CreateTeamMainState();
}

class _CreateTeamMainState extends State<CreateTeamMain> {
  late TextEditingController globalNamecontroller;
  late TextEditingController notesController;
  @override
  void initState() {
    super.initState();
    globalNamecontroller = TextEditingController();
    notesController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeTeam();
    });
  }

  void initializeTeam() {
    final teamProvider =
        Provider.of<CreateTeamProvider>(context, listen: false);

    if (widget.loadedTeam != null) {
      // Process date with error handling
      DateTime date = widget.loadedTeam!.date;
      teamProvider.changeDate(date);

      TimeOfDay time = TimeOfDay.fromDateTime(date);
      teamProvider.changeTime(time);

      double distance = widget.loadedTeam!.distance;
      teamProvider.changeDistance(distance);

      // Process name with error handling
      String groupName = widget.loadedTeam!.name;
      teamProvider.changeGlobalName(groupName);

      String groupNotes = widget.loadedTeam!.notes;
      teamProvider.changeNotes(groupNotes);
      notesController.text = teamProvider.group.notes;

      // Process teams with error handling
      var teams = widget.loadedTeam!.teams;

      teamProvider.changeAllTeams(teams);
      logger.debug("All teams: ${teams[0].toJson().toString()}");

      // Update the controller text after setting the provider value
      globalNamecontroller.text = teamProvider.group.name;
    } else {
      globalNamecontroller.text = teamProvider.group.name;
    }
  }

  @override
  void dispose() {
    globalNamecontroller.dispose();
    super.dispose();
  }

  Future<bool?> showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Are you sure you want to leave this page? All unsaved changes will be lost'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<Team> teams = teamProvider.group.teams;

    return PopScope(
      canPop: !teamProvider.unsavedData,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showBackDialog() ?? false;
        if (shouldPop) {
          if (context.mounted) Navigator.of(context).pop(false);
        }
      },
      child: ListView(
        children: [
          DateTimePicker(),
          TextField(
            controller: globalNamecontroller,
            decoration: InputDecoration(labelText: "Group name"),
            onChanged: (String text) {
              Provider.of<CreateTeamProvider>(context, listen: false)
                  .changeUnsavedData(true);
              Provider.of<CreateTeamProvider>(context, listen: false)
                  .changeGlobalName(text);
            },
          ),
          TextField(
            controller: notesController,
            decoration: InputDecoration(labelText: "Group notes"),
            onChanged: (String text) {
              Provider.of<CreateTeamProvider>(context, listen: false)
                  .changeUnsavedData(true);
              Provider.of<CreateTeamProvider>(context, listen: false)
                  .changeNotes(text);
            },
          ),
          ...teams.asMap().entries.map(
            (entry) {
              return TeamRetriever(
                teamNumber: entry.key,
                duplicateDogs: teamProvider.duplicateDogs,
                dogs: context.watch<DogProvider>().dogs,
                teams: context.watch<CreateTeamProvider>().group.teams,
                onDogSelected: (DogSelection newDog) {
                  Provider.of<CreateTeamProvider>(context, listen: false)
                      .changeDog(
                          newId: newDog.dog.id,
                          teamNumber: newDog.teamNumber,
                          rowNumber: newDog.rowNumber,
                          dogPosition: newDog.dogPosition);
                },
                onTeamNameChanged: (int teamNumber, String newName) =>
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .changeTeamName(teamNumber, newName),
                onRowRemoved: (int teamNumber, int rowNumber) =>
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .removeRow(
                            teamNumber: teamNumber, rowNumber: rowNumber),
                onAddRow: (int teamNumber) =>
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .addRow(teamNumber: teamNumber),
                onDogRemoved:
                    (int teamNumber, int rowNumber, int dogPosition) =>
                        Provider.of<CreateTeamProvider>(context, listen: false)
                            .changeDog(
                                newId: "",
                                teamNumber: teamNumber,
                                rowNumber: rowNumber,
                                dogPosition: dogPosition),
                onAddTeam: (teamNumber) =>
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .addTeam(teamNumber: teamNumber),
                onRemoveTeam: (teamNumber) =>
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .removeTeam(teamNumber: teamNumber),
              );
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String teamString =
                  Provider.of<CreateTeamProvider>(context, listen: false)
                      .createTeamsString();
              Clipboard.setData(ClipboardData(text: teamString));
            },
            child: Text("Copy teams"),
          ),
          SaveTeamsButton(teamProvider: teamProvider)
        ],
      ),
    );
  }
}

class TeamRetriever extends StatefulWidget {
  final int teamNumber;
  final List<Dog> dogs;
  final List<String> duplicateDogs;
  final List<Team> teams;
  final Function(DogSelection) onDogSelected;
  final Function(int, String) onTeamNameChanged;
  final Function(int, int) onRowRemoved;
  final Function(int) onAddRow;
  final Function(int, int, int) onDogRemoved;
  final Function(int) onAddTeam;
  final Function(int) onRemoveTeam;
  const TeamRetriever(
      {super.key,
      required this.teamNumber,
      required this.dogs,
      required this.duplicateDogs,
      required this.teams,
      required this.onDogSelected,
      required this.onTeamNameChanged,
      required this.onRowRemoved,
      required this.onAddRow,
      required this.onDogRemoved,
      required this.onAddTeam,
      required this.onRemoveTeam});

  @override
  State<TeamRetriever> createState() => _TeamRetrieverState();
}

class _TeamRetrieverState extends State<TeamRetriever> {
  late BasicLogger logger;
  late TextEditingController textController;
  @override
  void initState() {
    super.initState();
    logger = BasicLogger();
    textController =
        TextEditingController(text: widget.teams[widget.teamNumber].name);
  }

  @override
  void didUpdateWidget(covariant TeamRetriever oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.teams[widget.teamNumber].name !=
        oldWidget.teams[widget.teamNumber].name) {
      logger.debug("Calling didUpdateWidget in TeamRetriever");
      logger.trace(
          " Old widget name: ${oldWidget.teams[widget.teamNumber].name}");
      logger.trace(" New widget name: ${widget.teams[widget.teamNumber].name}");
      textController.text = widget.teams[widget.teamNumber].name;
    } else {
      logger.debug("Not calling didUpdateWidget in TeamRetriever");
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.teamNumber >= widget.teams.length) {
      return const Text("Invalid team number");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            controller: textController,
            decoration: InputDecoration(labelText: "Team name"),
            onChanged: (String text) {
              widget.onTeamNameChanged(widget.teamNumber, text);
            }),
        SizedBox(height: 10),
        ...widget.teams[widget.teamNumber].dogPairs.asMap().entries.map(
              (entry) => PairRetriever(
                teamNumber: widget.teamNumber,
                rowNumber: entry.key,
                teams: widget.teams,
                duplicateDogs: widget.duplicateDogs,
                onDogSelected: (newDog) => widget.onDogSelected(newDog),
                dogs: widget.dogs,
                onRowRemoved: (teamNumber, rowNumber) =>
                    widget.onRowRemoved(teamNumber, rowNumber),
                onDogRemoved: (teamNumber, rowNumber, positionNumber) =>
                    widget.onDogRemoved(teamNumber, rowNumber, positionNumber),
              ),
            ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAddRow(widget.teamNumber);
          },
          child: Text("Add new row"),
        ),
        Row(
          children: [
            AddTeamWidget(
              teamNumber: widget.teamNumber,
              onAddTeam: (newTeamNumber) => widget.onAddTeam(newTeamNumber),
            ),
            RemoveTeamWidget(
              teamNumber: widget.teamNumber,
              onRemoveTeam: (teamNumber) => widget.onRemoveTeam(teamNumber),
              totalTeams: widget.teams.length,
            ),
          ],
        ),
      ],
    );
  }
}

class PairRetriever extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final int teamNumber;
  final int rowNumber;
  final List<Team> teams;
  final List<Dog> dogs;
  final List<String> duplicateDogs;
  final Function(DogSelection) onDogSelected;
  final Function(int, int) onRowRemoved;
  final Function(int, int, int) onDogRemoved;
  const PairRetriever(
      {super.key,
      required this.teamNumber,
      required this.rowNumber,
      required this.teams,
      required this.dogs,
      required this.duplicateDogs,
      required this.onDogSelected,
      required this.onRowRemoved,
      required this.onDogRemoved});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DogSelector(
          teamNumber: teamNumber,
          rowNumber: rowNumber,
          teams: teams,
          positionNumber: 0,
          duplicateDogs: duplicateDogs,
          dogs: dogs,
          onDogSelected: (Dog newDog) => onDogSelected(
            DogSelection(
                dog: newDog,
                rowNumber: rowNumber,
                teamNumber: teamNumber,
                dogPosition: 0),
          ),
          onDogRemoved: (teamNumber, rowNumber) =>
              onDogRemoved(teamNumber, rowNumber, 0),
        ),
        Text(" - "),
        DogSelector(
          teamNumber: teamNumber,
          rowNumber: rowNumber,
          teams: teams,
          positionNumber: 1,
          duplicateDogs: duplicateDogs,
          dogs: dogs,
          onDogSelected: (Dog newDog) => onDogSelected(
            DogSelection(
                dog: newDog,
                rowNumber: rowNumber,
                teamNumber: teamNumber,
                dogPosition: 1),
          ),
          onDogRemoved: (teamNumber, rowNumber) =>
              onDogRemoved(teamNumber, rowNumber, 1),
        ),
        IconButton(
          key: Key("Row remover: $teamNumber - $rowNumber"),
          onPressed: () {
            onRowRemoved(teamNumber, rowNumber);
          },
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.redAccent,
            ),
            child: Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

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

  static final BasicLogger logger = BasicLogger();
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
  // Helper to get current value based on widget props
  String? _getCurrentValue() {
    // Ensure indices are valid before accessing
    if (widget.teamNumber < 0 ||
        widget.teamNumber >= widget.teams.length ||
        widget.rowNumber < 0 ||
        widget.rowNumber >= widget.teams[widget.teamNumber].dogPairs.length) {
      // Handle invalid index case, perhaps return null or log an error
      DogSelector.logger.warning(
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
                      TextEditingController
                          fieldController, // Use THIS controller
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    // Return the TextField wired with fieldController
                    return Focus(
                      onFocusChange: (bool isInFocus) =>
                          DogSelector.logger.debug("OPTION: $isInFocus"),
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
                            DogSelector.logger.debug("Text submitted: $value");
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
                    DogSelector.logger
                        .info("Selection completed: ${selectedDog.name}");
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

class AddTeamWidget extends StatelessWidget {
  final int teamNumber;
  final Function(int) onAddTeam;
  const AddTeamWidget(
      {super.key, required this.teamNumber, required this.onAddTeam});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: Key("Add team  - $teamNumber"),
      onPressed: () => onAddTeam(teamNumber + 1),
      child: Text("Add team"),
    );
  }
}

class RemoveTeamWidget extends StatelessWidget {
  final int teamNumber;
  final Function(int) onRemoveTeam;
  final int totalTeams;
  const RemoveTeamWidget(
      {super.key,
      required this.teamNumber,
      required this.onRemoveTeam,
      required this.totalTeams});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        key: Key("Remove team - $teamNumber"),
        onPressed: () {
          if (totalTeams > 1) onRemoveTeam(teamNumber);
        },
        child: Text("Remove team"));
  }
}
