import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import '../models.dart';
import '../riverpod.dart';
import 'pair_retriever.dart';

class TeamRetriever extends ConsumerStatefulWidget {
  final int teamNumber;
  final String? teamGroupId;
  final List<Dog> dogs;
  final List<String> runningDogs;
  final List<TeamWorkspace> teams;
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
      required this.teamGroupId,
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
  ConsumerState<TeamRetriever> createState() => _TeamRetrieverState();
}

class _TeamRetrieverState extends ConsumerState<TeamRetriever> {
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
    TeamWorkspace team = widget.teams[widget.teamNumber];
    if (widget.teamNumber >= widget.teams.length) {
      return const Text("Invalid team number");
    }

    var customerGroup =
        ref.watch(customerAssignProvider(widget.teamGroupId)).value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: "Team name"),
              onChanged: (String text) {
                widget.onTeamNameChanged(widget.teamNumber, text);
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Capacity: ${_buildTeamCapacity(customerGroup, team)}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _buildTeamColor(customerGroup, team),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => ref
                        .read(createTeamGroupProvider(widget.teamGroupId)
                            .notifier)
                        .changeTeamCapacity(
                          teamNumber: widget.teamNumber,
                          capacity: team.capacity + 1,
                        ),
                    icon: Icon(Icons.add_box)),
                IconButton(
                    onPressed: () => ref
                        .read(createTeamGroupProvider(widget.teamGroupId)
                            .notifier)
                        .changeTeamCapacity(
                            teamNumber: widget.teamNumber,
                            capacity:
                                team.capacity == 0 ? 0 : team.capacity - 1),
                    icon: Icon(Icons.remove)),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            ...team.dogPairs.asMap().entries.map(
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
                        widget.onDogRemoved(
                            teamNumber, rowNumber, positionNumber),
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
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
    );
  }

  String _buildTeamCapacity(
      CustomerGroupWorkspace? customerGroup, TeamWorkspace team) {
    int assigned =
        customerGroup?.customers.where((c) => c.teamId == team.id).length ?? 0;
    int capacity = team.capacity;
    return "$assigned/$capacity";
  }

  Color _buildTeamColor(
      CustomerGroupWorkspace? customerGroup, TeamWorkspace team) {
    int assigned =
        customerGroup?.customers.where((c) => c.teamId == team.id).length ?? 0;
    int capacity = team.capacity;
    if (assigned == capacity) {
      return Colors.green;
    } else if (assigned > capacity) {
      return Colors.red;
    } else if (assigned < capacity) {
      return Colors.orange;
    }
    return Colors.black;
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
