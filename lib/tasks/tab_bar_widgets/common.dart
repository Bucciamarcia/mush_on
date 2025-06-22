import 'package:mush_on/services/models/tasks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void fetchNewTasks(
    {required ViewChangedDetails details,
    required TasksInMemory tasks,
    required Function(DateTime) onFetchOlderTasks}) {
  if (tasks.oldestFetched == null) {
    return; // If null, it fetched everything.
  }
  DateTime firstDate = details.visibleDates.first;
  if (firstDate.isBefore(tasks.oldestFetched!)) {
    onFetchOlderTasks(firstDate);
  }
}
