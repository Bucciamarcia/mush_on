import 'package:flutter/material.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/services/models/dog.dart';

class RunTable extends StatelessWidget {
  final List<Dog> selectedDogs;
  final List<TeamGroupWorkspace> teamGroups;
  const RunTable(
      {super.key, required this.selectedDogs, required this.teamGroups});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
