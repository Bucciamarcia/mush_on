import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';
import 'package:mush_on/tasks/task_editor.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../common.dart';

class CalendarTabWidget extends StatelessWidget {
  final TasksInMemory tasks;
  final List<Dog> dogs;
  final Function(Task) onTaskEdited;
  final Function(Task) onTaskAdded;
  final Function(DateTime) onFetchOlderTasks;
  static final BasicLogger logger = BasicLogger();
  const CalendarTabWidget(
      {super.key,
      required this.onTaskAdded,
      required this.tasks,
      required this.dogs,
      required this.onTaskEdited,
      required this.onFetchOlderTasks});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      onViewChanged: (details) => fetchNewTasks(
          details: details,
          tasks: tasks,
          onFetchOlderTasks: (date) => onFetchOlderTasks(date)),
      showNavigationArrow: true,
      onTap: (element) {
        try {
          _handleTap(element, context);
        } catch (e, s) {
          logger.error("Error in handling tap.", error: e, stackTrace: s);
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar(context, "Unknown error."));
        }
      },
      showWeekNumber: true,
      firstDayOfWeek: 1,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayCount: 3,
          numberOfWeeksInView: 4,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      dataSource: TaskDataSource(tasks: tasks.tasks.haveExpiration, dogs: dogs),
    );
  }

  void _handleTap(CalendarTapDetails element, BuildContext context) async {
    if (element.appointments == null) {
      logger.error("element.appointments is null and shouldn't be");
      throw Exception("element.appointments is null and shouldn't be");
    } else {
      if (element.appointments!.isEmpty) {
        return await showDialog(
          context: context,
          builder: (context) => TaskEditorDialog(
            task: Task(expiration: element.date),
            dogs: dogs,
            taskEditorType: TaskEditorType.newTask,
            onTaskAdded: (t) => onTaskEdited(t),
          ),
        );
      } else if (element.appointments!.length != 1) {
        return await showDialog(
            context: context,
            builder: (context) => DayTasksDialog(
                  date: element.date,
                  onTaskEdited: (t) => onTaskEdited(t),
                  tasks: tasks,
                  dogs: dogs,
                  onFetchOlderTasks: (date) => onFetchOlderTasks(date),
                ));
      } else {
        Task task = element.appointments!.first as Task;
        return await showDialog(
          context: context,
          builder: (context) => TaskEditorDialog(
            task: task,
            dogs: dogs,
            taskEditorType: TaskEditorType.editTask,
            onTaskAdded: (t) => onTaskEdited(t),
          ),
        );
      }
    }
  }
}

class DayTasksDialog extends StatelessWidget {
  final DateTime? date;
  final TasksInMemory tasks;
  final Function(DateTime) onFetchOlderTasks;
  final Function(Task) onTaskEdited;
  final List<Dog> dogs;
  const DayTasksDialog(
      {super.key,
      this.date,
      required this.tasks,
      required this.onFetchOlderTasks,
      required this.dogs,
      required this.onTaskEdited});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Exit",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ))
      ],
      title: Text(
          "Tasks for: ${DateFormat("yyyy-MM-dd").format(date ?? DateTime.now())}"),
      content: SizedBox(
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.6,
        child: SfScheduleView(
            tasks: tasks,
            onFetchOlderTasks: onFetchOlderTasks,
            onTaskEdited: (t) {
              onTaskEdited(t);
              Navigator.of(context).pop();
            },
            dogs: dogs,
            date: date),
      ),
    );
  }
}

class TaskDataSource extends CalendarDataSource<Task> {
  final List<Task> tasks;
  final List<Dog> dogs;
  TaskDataSource({required this.tasks, required this.dogs});

  @override
  List<Task> get appointments => tasks;

  @override
  bool isAllDay(int index) => appointments[index].isAllDay;

  @override
  DateTime getStartTime(int index) => appointments[index].expiration!;

  @override
  DateTime getEndTime(int index) => appointments[index].expiration!;

  @override
  String getSubject(int index) {
    if (appointments[index].dogId == null) {
      return appointments[index].title;
    } else {
      return "${appointments[index].title} 🐶 ${dogs.getNameFromId(appointments[index].dogId!) ?? ""}";
    }
  }

  @override
  Color getColor(int index) {
    if (appointments[index].isDone) {
      return Colors.grey;
    } else if (appointments[index].isUrgent) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
