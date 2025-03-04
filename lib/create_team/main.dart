import 'package:flutter/material.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

class CreateTeamMain extends StatelessWidget {
  const CreateTeamMain({super.key});

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<Map<String, Object>> teams = teamProvider.teams;

    return ListView(
      children: teams.asMap().entries.map((entry) {
        return TeamRetriever(teamNumber: entry.key);
      }).toList(),
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
        text: teamProvider.teams[widget.teamNumber]["name"] as String);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<Map<String, Object>> teams = teamProvider.teams;

    // Ensure teamNumber is within range
    if (widget.teamNumber >= teams.length) {
      return const Text("Invalid team number");
    }

    return Column(
      children: [
        getTeam(teams[widget.teamNumber], teams, context),
        // Debug: fetch team object from provider
        Text(teams[widget.teamNumber].toString())
      ],
    );
  }

  Widget getTeam(Map<String, Object> team, List<Map<String, Object>> teams,
      BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    if (textController.text != teamProvider.teams[widget.teamNumber]["name"] &&
        !textController.selection.isValid) {
      textController.text =
          teamProvider.teams[widget.teamNumber]["name"] as String;
    }
    List<List<String>> dogPairs = List<List<String>>.from(team["dogs"] as List);

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
        Text("moi")
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
    List<Map<String, Object>> teams = teamProvider.teams;
    return Row(
      children: [
        dropDownButtonConstructor(teams, 0, context),
        Text(" - "),
        dropDownButtonConstructor(teams, 1, context)
      ],
    );
  }

  Widget dropDownButtonConstructor(
      var teams, int positionNumber, BuildContext context) {
    final DogProvider dogProvider = context.watch<DogProvider>();
    final CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<String> duplicateDogs = teamProvider.duplicateDogs;
    String? currentValue =
        (teams[teamNumber]["dogs"] as List)[rowNumber][positionNumber];
    bool isDuplicate;
    if (duplicateDogs.contains(currentValue)) {
      isDuplicate = true;
    } else {
      isDuplicate = false;
    }
    final List<Dog> dogs = dogProvider.dogs;
    final List<String> dogsList = getDogNames(dogs);

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
                    if (textEditingValue.text == "") {
                      return const Iterable<String>.empty();
                    } else {
                      return dogsList.where((option) => option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    }
                  },
                  onSelected: (option) => {
                    Provider.of<CreateTeamProvider>(context, listen: false)
                        .changeDog(
                            newName: option,
                            teamNumber: teamNumber,
                            rowNumber: rowNumber,
                            dogPosition: positionNumber),
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
