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

class TeamRetriever extends StatelessWidget {
  final int teamNumber;
  const TeamRetriever({super.key, required this.teamNumber});

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    List<Map<String, Object>> teams = teamProvider.teams;

    // Ensure teamNumber is within range
    if (teamNumber >= teams.length) {
      return const Text("Invalid team number");
    }

    return getTeam(teams[teamNumber]);
  }

  Widget getTeam(Map<String, Object> team) {
    String teamName = team["name"] as String;
    List<List<String>> dogPairs = List<List<String>>.from(team["dogs"] as List);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...dogPairs.asMap().entries.map(
              (entry) =>
                  PairRetriever(teamNumber: teamNumber, rowNumber: entry.key),
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
    String? currentValue =
        (teams[teamNumber]["dogs"] as List)[rowNumber][positionNumber];
    final List<Dog> dogs = dogProvider.dogs;
    final List<String> dogsList = getDogNames(dogs);

    // Using a key that depends on current value to force rebuild when the value changes
    final autoCompleteKey =
        ValueKey('${teamNumber}_${rowNumber}_${positionNumber}_$currentValue');

    return Expanded(
      child: Row(
        children: [
          Expanded(
            // Add this Expanded widget to constrain the Autocomplete
            child: Autocomplete<String>(
              key: autoCompleteKey,
              fieldViewBuilder: (BuildContext context,
                  TextEditingController controller,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  decoration: InputDecoration(
                    labelText: "no moi!",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.blue,
                  ),
                  style: TextStyle(fontSize: 10),
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
          ),
          currentValue == ""
              ? SizedBox.shrink() // Use SizedBox.shrink() instead of Text("")
              : IconButton(
                  onPressed: () =>
                      {cancelDogPosition(positionNumber, context, teams)},
                  icon: Icon(Icons.delete),
                ),
        ],
      ),
    );
  }

  void cancelDogPosition(int positionNumber, BuildContext context,
      List<Map<String, Object>> teams) {
    Provider.of<CreateTeamProvider>(context, listen: false).changeDog(
        newName: "",
        teamNumber: teamNumber,
        rowNumber: rowNumber,
        dogPosition: positionNumber);
  }
}
