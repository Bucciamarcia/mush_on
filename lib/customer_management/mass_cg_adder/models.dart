enum AddCgRuleType {
  weeklyOnDays(description: "repeat every week"),
  onSelectedDays(description: "apply to selected days");

  final String description;
  const AddCgRuleType({required this.description});
}

enum DaysOfWeekSelection {
  monday(letter: "Mo", weekday: 1),
  tuesday(letter: "Tu", weekday: 2),
  wednesday(letter: "We", weekday: 3),
  thursday(letter: "Th", weekday: 4),
  friday(letter: "Fr", weekday: 5),
  saturday(letter: "Sa", weekday: 6),
  sunday(letter: "Su", weekday: 7);

  final String letter;
  final int weekday;
  const DaysOfWeekSelection({required this.letter, required this.weekday});
}
