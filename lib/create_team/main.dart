import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/dog_selector.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/riverpod/dog_notes.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:uuid/uuid.dart';
import 'save_teams_button.dart';
import 'select_datetime.dart';

class CreateTeamMain extends ConsumerStatefulWidget {
  final TeamGroup? loadedTeam;
  const CreateTeamMain({super.key, this.loadedTeam});

  @override
  ConsumerState<CreateTeamMain> createState() => _CreateTeamMainState();
}

class _CreateTeamMainState extends ConsumerState<CreateTeamMain> {
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
    var teamGroup = ref.watch(createTeamGroupProvider(widget.loadedTeam));
    var runningDogs = ref.watch(runningDogsProvider(teamGroup));
    var dogNotes = ref.watch(dogNotesProvider);
    bool canPopProvider = ref.watch(canPopTeamGroupProvider);
    var notifier =
        ref.read(createTeamGroupProvider(widget.loadedTeam).notifier);
    List<Dog>? allDogs = ref.watch(dogsProvider).value;
    SettingsModel? settings = ref.watch(settingsProvider).value;

    return PopScope(
      canPop: canPopProvider,
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
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ExpansionTile(
              title: Center(child: Text("Filter")),
              children: [
                DogFilterWidget(
                    dogs: allDogs ?? [],
                    templates: settings?.customFieldTemplates ?? [],
                    onResult: (dogs) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Filter successful",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }),
              ],
            ),
          ),
          DateTimeDistancePicker(
            teamGroup: teamGroup,
            onDateChanged: (newDate) => notifier.changeDate(newDate),
            onDistanceChanged: (newDistance) =>
                notifier.changeDistance(newDistance),
          ),
          TextField(
            controller: TextEditingController(text: teamGroup.name),
            decoration: InputDecoration(labelText: "Group name"),
            onChanged: (String text) {
              notifier.changeName(text);
            },
          ),
          TextField(
            controller: TextEditingController(text: teamGroup.notes),
            decoration: InputDecoration(labelText: "Group notes"),
            onChanged: (String text) {
              notifier.changeNotes(text);
            },
          ),
          ...teamGroup.teams.asMap().entries.map(
            (entry) {
              return TeamRetriever(
                teamNumber: entry.key,
                dogs: allDogs ?? [],
                runningDogs: runningDogs,
                teams: teamGroup.teams,
                notes: dogNotes,
                onDogSelected: (DogSelection newDog) {
                  notifier.changePosition(
                      dogId: newDog.dog.id,
                      teamNumber: newDog.teamNumber,
                      rowNumber: newDog.rowNumber,
                      positionNumber: newDog.dogPosition);
                },
                onTeamNameChanged: (int teamNumber, String newName) => notifier
                    .changeTeamName(teamNumber: teamNumber, newName: newName),
                onRowRemoved: (int teamNumber, int rowNumber) => notifier
                    .removeRow(teamNumber: teamNumber, rowNumber: rowNumber),
                onAddRow: (int teamNumber) =>
                    notifier.addRow(teamNumber: teamNumber),
                onDogRemoved:
                    (int teamNumber, int rowNumber, int dogPosition) =>
                        notifier.changePosition(
                            dogId: "",
                            teamNumber: teamNumber,
                            rowNumber: rowNumber,
                            positionNumber: dogPosition),
                onAddTeam: (teamNumber) =>
                    notifier.addTeam(teamNumber: teamNumber),
                onRemoveTeam: (teamNumber) =>
                    notifier.removeTeam(teamNumber: teamNumber),
              );
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String teamString = createTeamsString(teamGroup);
              await Clipboard.setData(ClipboardData(text: teamString));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    confirmationSnackbar(context, "Teams copied"));
              }
            },
            child: Text("Copy teams"),
          ),
          SaveTeamsButton(teamGroup: teamGroup),
        ],
      ),
    );
  }

  String createTeamsString(TeamGroup group) {
    String stringTeams = "${group.name}\n\n";
    stringTeams = "$stringTeams${group.notes}\n\n";
    for (Team team in group.teams) {
      stringTeams = stringTeams + _stringifyTeam(team);
      stringTeams = "$stringTeams\n";
    }
    stringTeams = stringTeams.substring(0, stringTeams.length - 2);
    return stringTeams;
  }

  String _stringifyTeam(Team team) {
    String streamTeam = team.name;
    String dogPairs = _stringifyDogPairs(team.dogPairs);
    return "$streamTeam$dogPairs\n";
  }

  String _stringifyDogPairs(List<DogPair> teamDogs) {
    List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];
    String dogList = "";
    for (DogPair dogPair in teamDogs) {
      dogList =
          "$dogList\n${allDogs.getAllDogsById()[dogPair.firstDogId]?.name ?? ""} - ${allDogs.getAllDogsById()[dogPair.secondDogId]?.name ?? ""}";
    }
    return dogList;
  }
}

class TeamRetriever extends StatefulWidget {
  final int teamNumber;
  final List<Dog> dogs;
  final List<String> runningDogs;
  final List<Team> teams;
  final List<DogNote> notes;
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
      required this.runningDogs,
      required this.notes,
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
  final List<String> runningDogs;
  final List<DogNote> notes;
  final Function(DogSelection) onDogSelected;
  final Function(int, int) onRowRemoved;
  final Function(int, int, int) onDogRemoved;
  const PairRetriever(
      {super.key,
      required this.teamNumber,
      required this.rowNumber,
      required this.notes,
      required this.teams,
      required this.dogs,
      required this.runningDogs,
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
          dogs: dogs,
          runningDogs: runningDogs,
          notes: notes,
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
          notes: notes,
          positionNumber: 1,
          dogs: dogs,
          runningDogs: runningDogs,
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
              color: Theme.of(context).colorScheme.error,
            ),
            child: Icon(
              Icons.remove,
              color: Theme.of(context).colorScheme.onError,
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
    if (widget.teamNumber < widget.teams.length &&
        widget.teams[widget.teamNumber].name !=
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
                notes: widget.notes,
                onDogSelected: (newDog) => widget.onDogSelected(newDog),
                dogs: widget.dogs,
                runningDogs: widget.runningDogs,
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
        SizedBox(
          height: 10,
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
      child: Text("Remove team"),
    );
  }
}
