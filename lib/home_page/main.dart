import 'package:flutter/material.dart';
import 'package:mush_on/home_page/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePageScreenContent extends StatelessWidget {
  const HomePageScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<MainProvider>();
    var homeProvider = context.watch<HomePageProvider>();
    int totalDogs = provider.dogs.length;
    int canRun = totalDogs - homeProvider.dogsWithWarnings.fatal.length;
    return provider.loaded
        ? ListView(
            children: [
              Card(
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: ExpansionTile(
                  title: TextTitle("Today's tasks"),
                  children: [
                    SfScheduleView(
                        tasks: provider.tasks.dueToday,
                        onFetchOlderTasks: (date) {},
                        onTaskDeleted: (tid) => provider.deleteTask(tid),
                        dogs: provider.dogs,
                        date: DateTime.now(),
                        onTaskEdited: (t) => provider.editTask(t))
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
                                canRun -
                                    homeProvider
                                        .dogsWithWarnings.warning.length,
                                Colors.green),
                            ReadyDogData(
                                "Warning",
                                homeProvider.dogsWithWarnings.warning.length,
                                Colors.orange),
                            ReadyDogData(
                                "Unavailable", totalDogs - canRun, Colors.red),
                          ],
                          xValueMapper: (ReadyDogData data, _) => data.x,
                          yValueMapper: (ReadyDogData data, _) => data.y,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          pointColorMapper: (ReadyDogData data, _) =>
                              data.color,
                        )
                      ],
                      legend: Legend(isVisible: true),
                    ),
                    ListTile(
                      leading: Icon(Icons.directions_run),
                      title: Text(
                        "Ready to Run",
                      ),
                      trailing: Text("$canRun/$totalDogs dogs",
                          style: TextStyle(
                              color: _getTextColor(canRun, totalDogs),
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
                                  "${homeProvider.dogsWithWarnings.warning.length} at limit"),
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
          )
        : Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator.adaptive(),
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
