import 'package:mush_on/services/models/dog.dart';

enum ConditionSelection {
  name(type: String, allowedOperations: [
    OperationSelection.contains,
  ]),
  age(type: int, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.moreThan,
    OperationSelection.equalsNot,
    OperationSelection.lessThan
  ]),
  position(type: DogPositions, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.equalsNot
  ]),
  tag(type: Tag, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.equalsNot
  ]),
  sex(type: DogSex, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.equalsNot
  ]);

  /// The type of the filter when this condition is used
  final Type type;

  /// The operations supported by this condition
  final List<OperationSelection> allowedOperations;
  const ConditionSelection(
      {required this.type, required this.allowedOperations});
}

enum OperationSelection {
  equals(symbol: "equals"),
  contains(symbol: "contains"),
  equalsNot(symbol: "not equal"),
  moreThan(symbol: "more than"),
  lessThan(symbol: "less than");

  final String symbol;
  const OperationSelection({required this.symbol});
}

enum ConditionType {
  and(symbol: "and"),
  or(symbol: "or");

  final String symbol;
  const ConditionType({required this.symbol});
}
