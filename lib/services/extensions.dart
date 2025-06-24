extension DateTimeExtension on DateTime {
  DateTime get today {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
