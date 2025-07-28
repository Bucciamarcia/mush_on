import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/home_page/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/services/riverpod/dog_notes.dart';
import 'package:mush_on/shared/dog_list_alert_dialog.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'models.dart';
import 'riverpod.dart';
import 'whiteboard_element.dart';

class HomePageScreenContent extends ConsumerWidget {
  static final logger = BasicLogger();
  const HomePageScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomePageRiverpodResults> riverpodAsync =
        ref.watch(homePageRiverpodProvider);
    return riverpodAsync.when(
      data: (riverpod) {
        String? account = ref.watch(accountProvider).value;
        List<Dog> dogs = riverpod.dogs;
        List<DogNote> dogNotes = ref.watch(dogNotesProvider(latestDate: null));
        TasksInMemory tasks = riverpod.tasks;
        int canRun = dogs.length - dogNotes.typeFatal().length;
        List<WhiteboardElement> whiteboardElements = riverpod.whiteboardElements
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        return ListView(
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Row(
                    children: [
                      Tooltip(
                        showDuration: Duration(seconds: 5),
                        triggerMode: TooltipTriggerMode.tap,
                        message:
                            "A quick whiteboard that refreshes every day. For easy communication.",
                        child: Icon(Icons.question_mark),
                      ),
                      TextTitle("Whiteboard"),
                    ],
                  ),
                  children: [
                    AddWhiteboardElementDisplayWidget(
                      onDeleted: (id) {
                        if (account == null) {
                          logger.warning("Couldn't load account in home page");
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(
                                  context, "Error: couldn't load account"));
                        } else {
                          try {
                            WhiteboardElementRepository(account: account)
                                .deleteElement(id);
                          } catch (e, s) {
                            logger.error("couldn't delete element",
                                error: e, stackTrace: s);
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(
                                    context, "Error: couldn't delete element"));
                          }
                        }
                      },
                      onSaved: (e) {
                        if (account == null) {
                          logger.warning("Couldn't load account in home page");
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(
                                  context, "Error: couldn't load account"));
                        } else {
                          try {
                            WhiteboardElementRepository(account: account)
                                .addElement(e);
                          } catch (e, s) {
                            logger.error("couldn't add element",
                                error: e, stackTrace: s);
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(
                                    context, "Error: couldn't add element"));
                          }
                        }
                      },
                    ),
                    ...whiteboardElements.map((element) => SizedBox(
                          width: double.infinity,
                          child: WhiteboardElementDisplayWidget(
                            element: element,
                            onDeleted: (id) {
                              if (account == null) {
                                logger.warning(
                                    "Couldn't load account in home page");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(context,
                                        "Error: couldn't load account"));
                              } else {
                                try {
                                  WhiteboardElementRepository(account: account)
                                      .deleteElement(id);
                                } catch (e, s) {
                                  logger.error("couldn't delete element",
                                      error: e, stackTrace: s);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBar(context,
                                          "Error: couldn't delete element"));
                                }
                              }
                            },
                            onSaved: (e) {
                              if (account == null) {
                                logger.warning(
                                    "Couldn't load account in home page");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(context,
                                        "Error: couldn't load account"));
                              } else {
                                try {
                                  WhiteboardElementRepository(account: account)
                                      .addElement(e);
                                } catch (e, s) {
                                  logger.error("couldn't add element",
                                      error: e, stackTrace: s);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBar(context,
                                          "Error: couldn't add element"));
                                }
                              }
                            },
                          ),
                        ))
                  ]),
            ),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: ExpansionTile(
                title: TextTitle("Today's tasks"),
                children: [
                  SfScheduleView(
                      tasks: tasks.dueToday,
                      onFetchOlderTasks: (date) {},
                      onTaskDeleted: (tid) async => TaskRepository.delete(
                          tid, await ref.watch(accountProvider.future)),
                      dogs: dogs,
                      date: DateTime.now(),
                      onTaskEdited: (t) async => TaskRepository.addOrUpdate(
                          t, await ref.watch(accountProvider.future)))
                ],
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Column(
                spacing: 15,
                children: [
                  SfCircularChart(
                    series: <CircularSeries>[
                      PieSeries<ReadyDogData, String>(
                        dataSource: <ReadyDogData>[
                          ReadyDogData(
                              "OK",
                              canRun - dogNotes.typeWarning().length,
                              Colors.green),
                          ReadyDogData("Warning", dogNotes.typeWarning().length,
                              Colors.orange),
                          ReadyDogData(
                              "Unavailable", dogs.length - canRun, Colors.red),
                        ],
                        xValueMapper: (ReadyDogData data, _) => data.x,
                        yValueMapper: (ReadyDogData data, _) => data.y,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        pointColorMapper: (ReadyDogData data, _) => data.color,
                      )
                    ],
                    legend: Legend(isVisible: true),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_run),
                    title: Text(
                      "Ready to Run",
                    ),
                    trailing: Text("$canRun/${dogs.length} dogs",
                        style: TextStyle(
                            color: _getTextColor(canRun, dogs.length),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        ActionChip(
                          label:
                              Text("${dogNotes.typeFatal().length} cannot run"),
                          backgroundColor: Colors.red[100],
                          onPressed: () {
                            List<String> dogIds = dogNotes
                                .typeFatal()
                                .map((note) => note.dogId)
                                .toList();
                            List<Dog> fatalDogs = [];
                            for (String dogId in dogIds) {
                              Dog? sDog = dogs.getDogFromId(dogId);
                              if (sDog != null && !fatalDogs.contains(sDog)) {
                                fatalDogs.add(sDog);
                              }
                            }
                            showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                title: "Dogs that can't run",
                                dogs: fatalDogs,
                              ),
                            );
                          },
                        ),
                        ActionChip(
                          label: Text(
                              "${riverpod.healthEvents.active.length} active health events"),
                          backgroundColor: Colors.amber[100],
                          onPressed: () {
                            final events = riverpod.healthEvents.active;
                            var healthEventDogs = <Dog>[];
                            for (var e in events) {
                              var r = dogs.getDogFromId(e.dogId);
                              if (r != null && !healthEventDogs.contains(r)) {
                                healthEventDogs.add(r);
                              }
                            }
                            showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                title: "Dogs with health events",
                                dogs: healthEventDogs,
                              ),
                            );
                          },
                        ),
                        ActionChip(
                          label: Text(
                              "${riverpod.heatCycles.active.length} in heat"),
                          backgroundColor: Colors.purple[100],
                          onPressed: () {
                            final events = riverpod.heatCycles.active;
                            var heatDogs = <Dog>[];
                            for (var e in events) {
                              var r = dogs.getDogFromId(e.dogId);
                              if (r != null && !heatDogs.contains(r)) {
                                heatDogs.add(r);
                              }
                            }
                            showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                title: "Dogs in heat",
                                dogs: heatDogs,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/createteam"),
                    label: Text("Build team"),
                    icon: Icon(Icons.pets),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        );
      },
      error: (e, s) {
        BasicLogger().error("Couldn't load warning dogs async in home page",
            error: e, stackTrace: s);
        return Text("Couldn't load the page!");
      },
      loading: () => Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Color _getTextColor(int canRun, int totalDogs) {
    if (canRun / totalDogs < 0.75) {
      return Colors.red;
    } else if (canRun / totalDogs >= 0.75 && canRun / totalDogs <= 0.9) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

class ReadyDogData {
  ReadyDogData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}
