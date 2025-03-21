import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<Team> teams = teamProvider.group.teams;

    return ListView(
      children: [
        DateTimePicker(),
        TextField(
          controller: globalNamecontroller,
          decoration: InputDecoration(labelText: "Group name"),
          onChanged: (String text) {
            Provider.of<CreateTeamProvider>(context, listen: false)
                .changeGlobalName(text);
          },
        ),
        TextField(
          controller: notesController,
          decoration: InputDecoration(labelText: "Group notes"),
          onChanged: (String text) {
            Provider.of<CreateTeamProvider>(context, listen: false)
                .changeNotes(text);
          },
        ),
        ...teams.asMap().entries.map(
          (entry) {
            return TeamRetriever(teamNumber: entry.key);
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
    );
  }
}

class TeamRetriever extends StatefulWidget {
  final int teamNumber;
  const TeamRetriever({super.key, required this.teamNumber});

  @override
  State<TeamRetriever> createState() => _TeamRetrieverState();
}

class _TeamRetrieverState extends State<TeamRetriever> {
  late TextEditingController textController;
  @override
  void initState() {
    super.initState();
    CreateTeamProvider teamProvider =
        Provider.of<CreateTeamProvider>(context, listen: false);
    textController = TextEditingController(
        text: teamProvider.group.teams[widget.teamNumber].name);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<Team> teams = teamProvider.group.teams;

    if (widget.teamNumber >= teams.length) {
      return const Text("Invalid team number");
    }

    return Column(
      children: [
        getTeam(teams[widget.teamNumber], teams, context),
      ],
    );
  }

  Widget getTeam(Team team, List<Team> teams, BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    if (textController.text !=
            teamProvider.group.teams[widget.teamNumber].name &&
        !textController.selection.isValid) {
      textController.text = teamProvider.group.teams[widget.teamNumber].name;
    }
    List<DogPair> dogPairs = team.dogPairs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            controller: textController,
            decoration: InputDecoration(labelText: "Team name"),
            onChanged: (String text) {
              Provider.of<CreateTeamProvider>(context, listen: false)
                  .changeTeamName(widget.teamNumber, text);
            }),
        SizedBox(height: 10),
        ...dogPairs.asMap().entries.map(
              (entry) => PairRetriever(
                  teamNumber: widget.teamNumber, rowNumber: entry.key),
            ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<CreateTeamProvider>(context, listen: false).addRow(
              teamNumber: widget.teamNumber,
            );
          },
          child: Text("Add new row"),
        ),
        Row(
          children: [
            AddTeamWidget(teamNumber: widget.teamNumber),
            RemoveTeamWidget(teamNumber: widget.teamNumber),
          ],
        ),
      ],
    );
  }
}

class PairRetriever extends StatelessWidget {
  final int teamNumber;
  final int rowNumber;
  const PairRetriever(
      {super.key, required this.teamNumber, required this.rowNumber});

  @override
  Widget build(BuildContext context) {
    final CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<Team> teams = teamProvider.group.teams;
    return Row(
      children: [
        dropDownButtonConstructor(teams, 0, context),
        Text(" - "),
        dropDownButtonConstructor(teams, 1, context),
        IconButton(
          onPressed: () {
            Provider.of<CreateTeamProvider>(context, listen: false)
                .removeRow(teamNumber: teamNumber, rowNumber: rowNumber);
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

  Widget dropDownButtonConstructor(
      List<Team> teams, int positionNumber, BuildContext context) {
    final DogProvider dogProvider = context.watch<DogProvider>();
    final CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<String> duplicateDogs = teamProvider.duplicateDogs;
    String? currentValue;
    if (positionNumber == 0) {
      currentValue = teams[teamNumber].dogPairs[rowNumber].firstName;
    } else {
      currentValue = teams[teamNumber].dogPairs[rowNumber].secondName;
    }
    bool isDuplicate;
    if (duplicateDogs.contains(currentValue)) {
      isDuplicate = true;
    } else {
      isDuplicate = false;
    }
    final List<Dog> dogs = dogProvider.dogs;
    final List<String> dogsList = Dog().getDogNames(dogs);

    final autoCompleteKey =
        ValueKey('${teamNumber}_${rowNumber}_${positionNumber}_$currentValue');

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Autocomplete<String>(
                  key: autoCompleteKey,
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController controller,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return SizedBox(
                      height: 50,
                      child: TextField(
                        style: TextStyle(fontSize: 14),
                        controller: controller,
                        focusNode: focusNode,
                        onSubmitted: (String value) {
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
                    );
                  },
                  initialValue: TextEditingValue(text: currentValue ?? ""),
                  optionsBuilder: (textEditingValue) {
                    // Show all options if empty or has just a space (from onTap)
                    if (textEditingValue.text.isEmpty ||
                        textEditingValue.text == " ") {
                      return dogsList;
                    } else {
                      return dogsList.where((option) => option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    }
                  },
                  onSelected: (option) {
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .changeDog(
                            newName: option,
                            teamNumber: teamNumber,
                            rowNumber: rowNumber,
                            dogPosition: positionNumber);
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
          currentValue == ""
              ? SizedBox.shrink()
              : Center(
                  child: IconDeleteDog(
                    teamNumber: teamNumber,
                    rowNumber: rowNumber,
                    positionNumber: positionNumber,
                  ),
                ),
        ],
      ),
    );
  }
}

class IconDeleteDog extends StatelessWidget {
  const IconDeleteDog(
      {super.key,
      required this.teamNumber,
      required this.rowNumber,
      required this.positionNumber});

  final int teamNumber;
  final int rowNumber;
  final int positionNumber;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 25,
      child: IconButton(
        onPressed: () => {
          Provider.of<CreateTeamProvider>(context, listen: false).changeDog(
              newName: "",
              teamNumber: teamNumber,
              rowNumber: rowNumber,
              dogPosition: positionNumber),
        },
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
  const AddTeamWidget({super.key, required this.teamNumber});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Provider.of<CreateTeamProvider>(context, listen: false)
          .addTeam(teamNumber: teamNumber + 1),
      child: Text("Add team"),
    );
  }
}

class RemoveTeamWidget extends StatelessWidget {
  final int teamNumber;
  const RemoveTeamWidget({super.key, required this.teamNumber});

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    int teamsNumber = teamProvider.group.teams.length;
    return ElevatedButton(
        onPressed: () {
          if (teamsNumber > 1) {
            Provider.of<CreateTeamProvider>(context, listen: false)
                .removeTeam(teamNumber: teamNumber);
          }
        },
        child: Text("Remove team"));
  }
}
