import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/customers/main.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/team_builder/main.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

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
    var teamGroupAsync =
        ref.watch(createTeamGroupProvider(widget.loadedTeam?.id));
    return teamGroupAsync.when(
        data: (teamGroup) {
          final customerGroupWorkspace =
              ref.watch(customerAssignProvider(teamGroup.id)).value ??
                  CustomerGroupWorkspace();
          bool canPopProvider = ref.watch(canPopTeamGroupProvider);
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
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: "Team builder"),
                      Tab(
                        text: "Customers",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        TeamBuilderWidget(
                          teamGroup: teamGroup,
                          customerGroupWorkspace: customerGroupWorkspace,
                        ),
                        CustomersCreateTeam(teamGroup: teamGroup),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (e, s) {
          BasicLogger()
              .error("Couldn't get teamgroup", error: e, stackTrace: s);
          return Text("Couldn't get teamgroup");
        },
        loading: () => CircularProgressIndicator.adaptive());
  }
}
