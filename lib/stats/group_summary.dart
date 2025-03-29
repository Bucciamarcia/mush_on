/// The class used to generate monthly summaries.
/// The summary includes the month and the total distance for each dog in the group.
class GroupSummary {
  /// The DateTime month for this summary.
  DateTime month;

  /// The list of dogs with their total distances for the month.
  ///
  /// Example:
  /// {
  ///  "Fido": 100.0,
  ///  "Rex": 200.0,
  ///  }
  Map<String, double> distances;

  GroupSummary({required this.month, required this.distances});
}
