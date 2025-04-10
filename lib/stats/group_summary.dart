/// The class used to generate monthly summaries.
/// The summary includes the month and the total distance for each dog in the group.
class MonthSummary {
  /// The DateTime month for this summary.
  DateTime month;

  /// The list of dogs with their total distances for the month.
  ///
  /// Example:
  /// {
  ///  "[uuid]": 100.0,
  ///  "[uuid]": 200.0,
  ///  }
  Map<String, double> distances;

  MonthSummary({required this.month, required this.distances});
}
