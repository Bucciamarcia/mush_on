import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/provider.dart';
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
  late TextEditingController textController;
  @override
  void initState() {
    super.initState();
    textController =
        TextEditingController(text: widget.teams[widget.teamNumber].name);
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

class DogSelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Map<String, Dog> dogsById = Dog.dogsById(dogs);
    String? currentValue;
    if (positionNumber == 0) {
      currentValue = teams[teamNumber].dogPairs[rowNumber].firstDogId;
    } else {
      currentValue = teams[teamNumber].dogPairs[rowNumber].secondDogId;
    }
    bool isDuplicate;
    if (duplicateDogs.contains(currentValue)) {
      isDuplicate = true;
    } else {
      isDuplicate = false;
    }
    final autoCompleteKey =
        ValueKey('${teamNumber}_${rowNumber}_${positionNumber}_$currentValue');

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Autocomplete<Dog>(
                  displayStringForOption: (Dog dog) => dog.name,
                  key: autoCompleteKey,
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController controller,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return Focus(
                      onFocusChange: (bool isInFocus) =>
                          logger.info("OPTION: $isInFocus"),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          key: Key(
                              "Select Dog - $teamNumber - $rowNumber - $positionNumber"),
                          style: TextStyle(fontSize: 14),
                          controller: controller,
                          focusNode: focusNode,
                          onSubmitted: (String value) {
                            logger.info("Text submitted: $value");
                            onFieldSubmitted();
                          },
                          onTap: () {
                            if (controller.text.isEmpty) {
                              controller.value = TextEditingValue(
                                text:
                                    ' ', // Set a space temporarily to show all options
                                selection: TextSelection.collapsed(offset: 1),
                              );
                              // Restore to empty after options are displayed
                              Future.delayed(Duration(milliseconds: 100), () {
                                controller.value = TextEditingValue(
                                  text: '',
                                  selection: TextSelection.collapsed(offset: 0),
                                );
                              });
                            }
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
                  initialValue: TextEditingValue(
                      text: dogsById[currentValue]?.name ?? ""),
                  optionsBuilder: (textEditingValue) {
                    // Show all options if empty or has just a space (from onTap)
                    if (textEditingValue.text.isEmpty ||
                        textEditingValue.text == " ") {
                      return dogs;
                    } else {
                      return dogs.where((option) => option.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    }
                  },
                  onSelected: (Dog selectedDog) {
                    logger.info("Selection completed: ${selectedDog.name}");
                    onDogSelected(selectedDog);
                  },
                ),
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
                    teamNumber: teamNumber,
                    rowNumber: rowNumber,
                    positionNumber: positionNumber,
                    onDogRemoved: (teamNumber, rowNumber) =>
                        onDogRemoved(teamNumber, rowNumber),
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
