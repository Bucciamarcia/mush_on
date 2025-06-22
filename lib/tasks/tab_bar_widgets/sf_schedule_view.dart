import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../task_editor.dart';
import 'calendar/main.dart';
import 'common.dart';

class SfScheduleView extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final TasksInMemory tasks;
  final Function(DateTime) onFetchOlderTasks;
  final Function(Task) onTaskEdited;
  final List<Dog> dogs;
  final DateTime? date;

  /// How many days to display (default 1)
  final int? daysToDisplay;

  /// How many days into the future to start displaying (default 0)
  final int? startDayOffset;
  const SfScheduleView(
      {super.key,
      required this.tasks,
      required this.onFetchOlderTasks,
      required this.dogs,
      required this.date,
      required this.onTaskEdited,
      this.daysToDisplay,
      this.startDayOffset});

  @override
  Widget build(BuildContext context) {
    int daysToDisplayFinal = daysToDisplay ?? 1;
    int startDayOffsetFinal = startDayOffset ?? 0;
    return SingleChildScrollView(
      child: SfCalendar(
        firstDayOfWeek: 1,
        minDate: date?.add(Duration(days: startDayOffsetFinal)),
        maxDate: date
            ?.add(Duration(days: daysToDisplayFinal + startDayOffsetFinal))
            .subtract(Duration(minutes: 1)),
        view: CalendarView.schedule,
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Task task =
              calendarAppointmentDetails.appointments.first as Task;

          return Container(
            decoration: BoxDecoration(
              color: _getTaskColor(task),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Text(
                _getTaskSubject(task),
                style: _getTaskTextStyle(task),
              ),
            ),
          );
        },
        onTap: (element) {
          try {
            _handleTap(element, context);
          } catch (e, s) {
            logger.error("Error in handling tap.", error: e, stackTrace: s);
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(context, "Unknown error."));
          }
        },
        onViewChanged: (details) => fetchNewTasks(
            details: details,
            tasks: tasks,
            onFetchOlderTasks: (date) => onFetchOlderTasks(date)),
        dataSource: TaskDataSource(tasks: tasks.tasks, dogs: dogs, date: date),
      ),
    );
  }

  String _getTaskSubject(Task task) {
    if (task.dogId == null) {
      return task.title;
    } else {
      return "${task.title} 🐶 ${dogs.getNameFromId(task.dogId!) ?? ""}";
    }
  }

  TextStyle _getTaskTextStyle(Task task) {
    if (task.isDone) {
      return TextStyle(
        color: Colors.white,
        decoration: TextDecoration.lineThrough,
        fontStyle: FontStyle.italic,
        fontSize: 14,
      );
    } else if (task.isUrgent) {
      return TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
    } else {
      return TextStyle(
        color: Colors.white,
        fontSize: 14,
      );
    }
  }

  Color _getTaskColor(Task task) {
    if (task.isDone) {
      return Colors.grey;
    } else if (task.isUrgent) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  void _handleTap(CalendarTapDetails element, BuildContext context) async {
    if (element.appointments == null) {
      logger.error("element.appointments is null and shouldn't be");
      throw Exception("element.appointments is null and shouldn't be");
    } else {
      if (element.appointments!.isEmpty) {
        logger.info("Gotta add new task here");
      } else if (element.appointments!.length != 1) {
        return await showDialog(
            context: context,
            builder: (context) => DayTasksDialog(
                  date: element.date,
                  tasks: tasks,
                  dogs: dogs,
                  onFetchOlderTasks: (date) => onFetchOlderTasks(date),
                  onTaskEdited: (t) => onTaskEdited(t),
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

class TaskDataSource extends CalendarDataSource<Task> {
  final List<Task> tasks;
  final List<Dog> dogs;
  final DateTime? date;
  TaskDataSource({required this.tasks, required this.dogs, required this.date});

  @override
  List<Task> get appointments {
    List<Task> tasksEditable = List<Task>.from(tasks);
    tasksEditable.removeWhere((t) => t.expiration == null);
    return tasksEditable;
  }

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
