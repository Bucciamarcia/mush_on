import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/home_page/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'riverpod.dart';

class HomePageScreenContent extends ConsumerWidget {
  const HomePageScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomePageRiverpodResults> riverpodAsync =
        ref.watch(homePageRiverpodProvider);
    return riverpodAsync.when(
      data: (riverpod) {
        List<Dog> dogs = riverpod.dogs;
        DogsWithWarnings dogsWithWarnings = riverpod.dogsWithWarnings;
        TasksInMemory tasks = riverpod.tasks;
        int canRun = dogs.length - dogsWithWarnings.fatal.length;
        return ListView(
          children: [
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
                              canRun - dogsWithWarnings.warning.length,
                              Colors.green),
                          ReadyDogData("Warning",
                              dogsWithWarnings.warning.length, Colors.orange),
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
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                            label: Text(
                                "${dogsWithWarnings.warning.length} at limit"),
                            backgroundColor: Colors.orange[100]),
                        Chip(
                            label: Text("2 injured"),
                            backgroundColor: Colors.red[100]),
                        Chip(
                            label: Text("1 in heat"),
                            backgroundColor: Colors.purple[100]),
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
