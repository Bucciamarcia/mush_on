import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarTabWidget extends StatelessWidget {
  final List<Task> tasks;
  final List<Dog> dogs;
  static final BasicLogger logger = BasicLogger();
  const CalendarTabWidget({super.key, required this.tasks, required this.dogs});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      showNavigationArrow: true,
      onTap: (element) {
        try {
          _handleTap(element);
        } catch (e, s) {
          logger.error("Error in handling tap.", error: e, stackTrace: s);
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar(context, "Unknown error."));
        }
      },
      showWeekNumber: true,
      firstDayOfWeek: 1,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayCount: 5,
          numberOfWeeksInView: 4,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      dataSource: TaskDataSource(tasks: tasks.haveExpiration, dogs: dogs),
    );
  }

  void _handleTap(CalendarTapDetails element) {
    if (element.appointments == null) {
      throw Exception("Unknown error");
    } else {
      if (element.appointments!.isEmpty) {
        logger.info("Gotta add new task here");
      } else {
        Task task = element.appointments!.first as Task;
      }
    }
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
    if (appointments[index].isUrgent) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
