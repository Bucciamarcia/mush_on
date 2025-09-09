import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:mush_on/services/riverpod/dog_notes.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'select_datetime.dart';
import 'team_retriever.dart';

class TeamBuilderWidget extends ConsumerStatefulWidget {
  final TeamGroupWorkspace teamGroup;
  final CustomerGroupWorkspace customerGroupWorkspace;
  final String? providerKey;

  const TeamBuilderWidget(
      {super.key,
      required this.teamGroup,
      required this.customerGroupWorkspace,
      required this.providerKey});

  @override
  ConsumerState<TeamBuilderWidget> createState() => _TeamBuilderWidgetState();
}

class _TeamBuilderWidgetState extends ConsumerState<TeamBuilderWidget> {
  late TextEditingController groupNameController;
  late TextEditingController groupNotesController;

  @override
  void initState() {
    super.initState();
    groupNameController = TextEditingController(text: widget.teamGroup.name);
    groupNotesController = TextEditingController(text: widget.teamGroup.notes);
  }

  @override
  void dispose() {
    groupNameController.dispose();
    groupNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var runningDogs = ref.watch(runningDogsProvider(widget.teamGroup));
    var dogNotes =
        ref.watch(dogNotesProvider(latestDate: widget.teamGroup.date));
    var notifier =
        ref.read(createTeamGroupProvider(widget.providerKey).notifier);
    List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];
    SettingsModel? settings = ref.watch(settingsProvider).value;
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ExpansionTile(
              title: const Center(child: Text("Filter dogs")),
              children: [
                DogFilterWidget(
                    dogs: allDogs,
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
            teamGroup: widget.teamGroup,
            onDateChanged: (newDate) => notifier.changeDate(newDate),
            onDistanceChanged: (newDistance) =>
                notifier.changeDistance(newDistance),
          ),
          TextField(
            controller: groupNameController,
            decoration: const InputDecoration(labelText: "Group name"),
            onChanged: (String text) {
              notifier.changeName(text);
            },
          ),
          TextField(
            controller: groupNotesController,
            decoration: const InputDecoration(labelText: "Group notes"),
            onChanged: (String text) {
              notifier.changeNotes(text);
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownMenu<TeamGroupRunType>(
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: widget.teamGroup.runType.backgroundColor
                      .withValues(alpha: 0.4),
                  border: const OutlineInputBorder(),
                ),
                label: const Text("Run type"),
                dropdownMenuEntries: TeamGroupRunType.values
                    .map((v) => DropdownMenuEntry<TeamGroupRunType>(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                v.backgroundColor.withValues(alpha: 0.5))),
                        value: v,
                        label: v.name,
                        labelWidget: Row(
                          spacing: 10,
                          children: [v.icon, Text(v.name)],
                        )))
                    .toList(),
                initialSelection: widget.teamGroup.runType,
                onSelected: (newRunType) {
                  if (newRunType != null) {
                    notifier.changeRunType(newRunType);
                  }
                },
              ),
              Text(
                  "Total capacity: ${widget.teamGroup.teams.fold(0, (sum, e) => sum + e.capacity)}/${widget.customerGroupWorkspace.customers.length}"),
            ],
          ),
          const SizedBox(
            width: double.infinity,
          ),
          ...widget.teamGroup.teams.asMap().entries.map(
            (entry) {
              return Column(
                children: [
                  const Divider(),
                  TeamRetriever(
                    teamNumber: entry.key,
                    teamGroupId: widget.providerKey,
                    dogs: allDogs,
                    runningDogs: runningDogs,
                    teams: widget.teamGroup.teams,
                    notes: dogNotes,
                    onDogSelected: (DogSelection newDog) {
                      notifier.changePosition(
                          dogId: newDog.dog.id,
                          teamNumber: newDog.teamNumber,
                          rowNumber: newDog.rowNumber,
                          positionNumber: newDog.dogPosition);
                    },
                    onTeamNameChanged: (int teamNumber, String newName) =>
                        notifier.changeTeamName(
                            teamNumber: teamNumber, newName: newName),
                    onRowRemoved: (int teamNumber, int rowNumber) =>
                        notifier.removeRow(
                            teamNumber: teamNumber, rowNumber: rowNumber),
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
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String teamString = CreateTeamsString(
                allDogs: allDogs,
              ).teamGroup(widget.teamGroup);
              await Clipboard.setData(ClipboardData(text: teamString));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    confirmationSnackbar(context, "Teams copied"));
              }
            },
            child: const Text("Copy team group"),
          ),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(canPopTeamGroupProvider);
              ref.invalidate(createTeamGroupProvider);
              Navigator.of(context).popAndPushNamed("/createteam");
            },
            child: const Text("Create new team group"),
          ),
        ],
      ),
    );
  }
}

class CreateTeamsString {
  final List<Dog> allDogs;

  CreateTeamsString({required this.allDogs});

  String teamGroup(TeamGroupWorkspace teamGroup) {
    String stringTeams = "${teamGroup.name}\n\n";
    stringTeams = "$stringTeams${teamGroup.notes}\n\n";
    for (TeamWorkspace team in teamGroup.teams) {
      stringTeams = stringTeams + stringifyTeam(team);
      stringTeams = "$stringTeams\n";
    }
    stringTeams = stringTeams.substring(0, stringTeams.length - 2);
    return stringTeams;
  }

  String stringifyTeam(TeamWorkspace team) {
    String streamTeam = team.name;
    String dogPairs = _stringifyDogPairs(team.dogPairs);
    return "$streamTeam$dogPairs\n";
  }

  String _stringifyDogPairs(List<DogPairWorkspace> teamDogs) {
    String dogList = "";
    for (DogPairWorkspace dogPair in teamDogs) {
      dogList =
          "$dogList\n${allDogs.getAllDogsById()[dogPair.firstDogId]?.name ?? ""} - ${allDogs.getAllDogsById()[dogPair.secondDogId]?.name ?? ""}";
    }
    return dogList;
  }
}
