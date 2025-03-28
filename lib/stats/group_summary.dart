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
