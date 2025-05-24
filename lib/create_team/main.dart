import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mush_on/create_team/dog_selector.dart';
import 'package:mush_on/create_team/model.dart';
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
                errors: context.watch<CreateTeamProvider>().dogErrors,
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
  final List<DogError> errors;
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
      required this.errors,
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

class PairRetriever extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final int teamNumber;
  final int rowNumber;
  final List<Team> teams;
  final List<Dog> dogs;
  final List<String> duplicateDogs;
  final List<DogError> errors;
  final Function(DogSelection) onDogSelected;
  final Function(int, int) onRowRemoved;
  final Function(int, int, int) onDogRemoved;
  const PairRetriever(
      {super.key,
      required this.teamNumber,
      required this.rowNumber,
      required this.errors,
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
      textController.text = widget.teams[widget.teamNumber].name;
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
                errors: [],
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
