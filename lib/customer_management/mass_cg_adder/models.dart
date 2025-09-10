enum AddCgRuleType {
  weeklyOnDays(description: "repeat every week"),
  monthlyOnDays(description: "repeat every month");

  final String description;
  const AddCgRuleType({required this.description});
}

enum DaysOfWeekSelection {
  monday(letter: "Mo"),
  tuesday(letter: "Tu"),
  wednesday(letter: "We"),
  thursday(letter: "Th"),
  friday(letter: "Fr"),
  saturday(letter: "Sa"),
  sunday(letter: "Su");

  final String letter;
  const DaysOfWeekSelection({required this.letter});
}
