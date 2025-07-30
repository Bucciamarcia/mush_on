import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/customers/customer_groups_card.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/team_builder/main.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';

class CustomersCreateTeam extends StatelessWidget {
  final CustomerGroupWorkspace customerGroupWorkspace;
  final TeamGroupWorkspace teamGroup;
  const CustomersCreateTeam(
      {super.key,
      required this.customerGroupWorkspace,
      required this.teamGroup});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomerGroupsCard(
                customerGroupWorkspace: customerGroupWorkspace),
          ),
          ...teamGroup.teams.map(
            (team) => SingleTeamAssign(team: team),
          ),
        ],
      ),
    );
  }
}

class SingleTeamAssign extends ConsumerWidget {
  final TeamWorkspace team;
  const SingleTeamAssign({super.key, required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            Text("Team: ${team.name}"),
            Text(
                CreateTeamsString(allDogs: allDogs).stringifyTeam(team).trim()),
          ],
        ),
      ),
    );
  }
}
