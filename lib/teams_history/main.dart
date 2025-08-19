import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/save_teams_button.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/riverpod/teamgroup.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'format_exp_card_content.dart';

class TeamsHistoryMain extends ConsumerWidget {
  const TeamsHistoryMain({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return ref
        .watch(
          teamGroupsProvider(
            earliestDate: DateTimeUtils.today().subtract(
              const Duration(days: 30),
            ),
            finalDate: null,
          ),
        )
        .when(
          data: (groups) {
            groups.sort((a, b) => b.date.compareTo(a.date));

            if (groups.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "No Team History",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Create and save teams to see them here",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              );
            }

            // Group teams by date
            Map<String, List<TeamGroup>> groupedByDate = {};
            for (var group in groups) {
              String dateKey = DateFormat('yyyy-MM-dd').format(group.date);
              if (!groupedByDate.containsKey(dateKey)) {
                groupedByDate[dateKey] = [];
              }
              groupedByDate[dateKey]!.add(group);
            }

            // Create a flat list with headers and items
            List<Widget> items = [];
            groupedByDate.forEach((dateKey, dayGroups) {
              DateTime date = DateTime.parse(dateKey);

              // Add date header
              items.add(_buildDateHeader(context, date, colorScheme));

              // Add teams for this date
              for (int i = 0; i < dayGroups.length; i++) {
                items.add(TeamViewer(
                    item: dayGroups[i], key: ValueKey(dayGroups[i].id)));
                if (i < dayGroups.length - 1) {
                  items.add(const SizedBox(height: 4));
                }
              }

              // Add spacing after each day section
              items.add(const SizedBox(height: 16));
            });

            return ListView(
              padding: const EdgeInsets.all(12),
              children: items,
            );
          },
          error: (e, s) {
            BasicLogger()
                .error("Couldn't load teamgroups.", error: e, stackTrace: s);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                  const SizedBox(height: 12),
                  Text(
                    "Error loading team groups",
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }

  Widget _buildDateHeader(
      BuildContext context, DateTime date, ColorScheme colorScheme) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    String dateText;
    if (dateOnly == today) {
      dateText = "Today";
    } else if (dateOnly == yesterday) {
      dateText = "Yesterday";
    } else {
      dateText = DateFormat('EEEE, MMMM d, yyyy').format(date);
    }

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 12),
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class TeamViewer extends ConsumerWidget {
  final TeamGroup item;
  const TeamViewer({super.key, required this.item});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    var dogsAsync = ref.watch(dogsProvider);
    return dogsAsync.when(
      data: (dogs) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: colorScheme.surfaceContainerLow,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ExpansionTile(
              backgroundColor:
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              collapsedBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat("HH:mm").format(item.date),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.tonal(
                    onPressed: () => context.pushNamed(
                      "/createteam",
                      queryParameters: {"teamGroupId": item.id},
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text("Load", style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 4),
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
                      Icons.delete_outline,
                      size: 20,
                      color: colorScheme.error,
                    ),
                    tooltip: "Delete team group",
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                  )
                ],
              ),
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                FormatObject(
                  item,
                  dogs.getAllDogsById(),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () async {
                      try {
                        var teamGroupJson = item.toJson();
                        TeamGroupWorkspace newTgs =
                            TeamGroupWorkspace.fromJson(teamGroupJson);
                        List<Team> teams = await ref
                            .watch(teamsInTeamgroupProvider(item.id).future);
                        List<TeamWorkspace> tw = [];
                        for (Team team in teams) {
                          var tjs = team.toJson();
                          tjs.remove("rank");
                          List<DogPairWorkspace> dpw = [];
                          List<DogPair> dps = await ref.watch(
                              dogPairsInTeamProvider(item.id, team.id).future);
                          for (DogPair dp in dps) {
                            var dpjs = dp.toJson();
                            dpjs.remove("rank");
                            dpw.add(DogPairWorkspace.fromJson(dpjs));
                          }
                          var finalTeam = TeamWorkspace.fromJson(tjs);
                          finalTeam = finalTeam.copyWith(dogPairs: dpw);
                          tw.add(finalTeam);
                        }
                        newTgs = newTgs.copyWith(
                            teams: tw,
                            id: const Uuid().v4(),
                            date: DateTimeUtils.today());
                        await saveToDb(newTgs,
                            await ref.watch(accountProvider.future), ref);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text("Team group copied successfully"),
                              backgroundColor: colorScheme.primary,
                            ),
                          );
                        }
                      } catch (e, s) {
                        BasicLogger().error("Couldn't copy team group",
                            error: e, stackTrace: s);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(context,
                                  "Couldn't duplicate the team group"));
                        }
                      }
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text("Duplicate"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, s) {
        BasicLogger().error("Couldn't get dogs", error: e, stackTrace: s);
        return Card(
          child: ListTile(
            leading: Icon(Icons.error_outline, color: colorScheme.error),
            title: const Text("Error loading dogs"),
            subtitle: const Text("Unable to display team information"),
          ),
        );
      },
      loading: () => const Card(
        child: ListTile(
          leading: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
          title: Text("Loading..."),
        ),
      ),
    );
  }

  AlertDialog buildAlertDialog(BuildContext context, String account) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.warning_amber, color: colorScheme.error),
          const SizedBox(width: 12),
          const Text("Delete Team Group"),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This action cannot be undone."),
          SizedBox(height: 8),
          Text("All team data and history will be permanently removed."),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Cancel"),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () async {
            bool r = await deleteGroup(account);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      r ? "Team group deleted" : "Error deleting team group"),
                  backgroundColor: r ? colorScheme.primary : colorScheme.error,
                ),
              );
            }
          },
          icon: const Icon(Icons.delete, size: 16),
          label: const Text("Delete"),
        )
      ],
    );
  }

  Future<bool> deleteGroup(String account) async {
    try {
      var db = FirebaseFirestore.instance;
      var batch = db.batch();

      String path = "accounts/$account/data/teams/history/${item.id}";
      var teamGroupDoc = db.doc(path);
      batch.delete(teamGroupDoc);
      var teamsCollection = teamGroupDoc.collection(("teams"));
      var tcdocs = await teamsCollection.get();
      for (var doc in tcdocs.docs) {
        batch.delete(db.doc("$path/teams/${doc.id}"));
        var dpcollection = teamsCollection.doc(doc.id).collection("dogPairs");
        var dpdocs = await dpcollection.get();
        for (var dpdoc in dpdocs.docs) {
          batch.delete(db.doc("$path/teams/${doc.id}/dogPairs/${dpdoc.id}"));
        }
      }
      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }
}
