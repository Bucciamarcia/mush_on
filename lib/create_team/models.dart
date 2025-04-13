import '../services/models.dart';

/// Helper class with the data to pass up the chain in a callback function.
class DogSelection {
  final Dog dog;
  final int teamNumber;
  final int rowNumber;
  final int dogPosition;

  DogSelection(
      {required this.dog,
      required this.teamNumber,
      required this.rowNumber,
      required this.dogPosition});
}
