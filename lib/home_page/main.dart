import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';
import 'package:provider/provider.dart';

class HomePageScreenContent extends StatelessWidget {
  const HomePageScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<MainProvider>();
    int totalDogs = provider.dogs.length;
    int availableDogs = _calculateAvailableDogs();
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
                    ListTile(
                      leading: Icon(Icons.directions_run),
                      title: Text("Ready to Run"),
                      trailing: Text("$availableDogs/$totalDogs dogs",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Chip(
                              label: Text("6 at limit"),
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
                  ],
                ),
              )
            ],
          )
        : Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator.adaptive(),
          );
  }

  int _calculateAvailableDogs() {
    return 1;
  }
}
