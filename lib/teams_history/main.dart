import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'format_exp_card_content.dart';

class TeamsHistoryMain extends ConsumerWidget {
  const TeamsHistoryMain({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(
          teamGroupsProvider(
            earliestDate: DateTimeUtils.today().subtract(
              Duration(days: 30),
            ),
            finalDate: null,
          ),
        )
        .when(
          data: (groups) {
            groups.sort((a, b) => b.date.compareTo(a.date));
            return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  TeamGroup item = groups[index];
                  return TeamViewer(item: item, key: ValueKey(item.id));
                });
          },
          error: (e, s) {
            BasicLogger()
                .error("Couldn't load teamgroups.", error: e, stackTrace: s);
            return Text("Error: couldn't load team groups.");
          },
          loading: () => Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}

class TeamViewer extends ConsumerWidget {
  final TeamGroup item;
  const TeamViewer({super.key, required this.item});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dogsAsync = ref.watch(dogsProvider);
    return dogsAsync.when(
      data: (dogs) {
        return Card(
          color: Theme.of(context).primaryColorLight,
          margin: const EdgeInsets.all(2),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 3),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      DateFormat("dd-MM-yy || HH:mm").format((item.date)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Name with flexible width that can shrink
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  // Load button and delete icon with fixed space
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, "/createteam",
                            arguments: item),
                        child: Text("Load"),
                      ),
                      IconButton(
                        onPressed: () async {
                          var account = await ref.watch(accountProvider.future);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return buildAlertDialog(context, account);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              tilePadding: const EdgeInsets.all(1),
              dense: true,
              children: [
                // Conditionally build the child here
                FormatObject(
                    item, dogs.getAllDogsById()), // Show content if loaded
              ],
            ),
          ),
        );
      },
      error: (e, s) {
        BasicLogger().error("Couldn't get dogs", error: e, stackTrace: s);
        return Text("Couldn't fetch dogs.");
      },
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  AlertDialog buildAlertDialog(BuildContext context, String account) {
    return AlertDialog.adaptive(
      title: Text("Are you sure?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("This action is irreversible."),
          Text("You will lose all the data related to this group.")
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Go back")),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Theme.of(context).colorScheme.error),
            foregroundColor:
                WidgetStateProperty.all(Theme.of(context).colorScheme.onError),
          ),
          onPressed: () async {
            bool r = await deleteGroup(account);
            if (r == true) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Team deleted"),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error deleting team"),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            }
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(
            "Delete group",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
        )
      ],
    );
  }

  Future<bool> deleteGroup(String account) async {
    try {
      var db = FirebaseFirestore.instance;

      String path = "accounts/$account/data/teams/history";
      var ref = db.collection(path);
      await ref.doc(item.id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
