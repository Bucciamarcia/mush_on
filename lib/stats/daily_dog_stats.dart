/// Holds the aggregate running stats for a single day, for all the dogs.
class DailyDogStats {
  /// The day of the running
  DateTime date;

  /// The list of dogs and how much they ran
  /// Key is the dog name, value is the distance in double
  Map<String, double> distances;
  DailyDogStats({required this.date, required this.distances});
}
