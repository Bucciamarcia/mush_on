import '../services/models.dart';

class RunningDogs {
  Map<String, double> dogDistances = {};

  /// Returns a list of all the dogs that have run.
  List<String> getDogsList() {
    return dogDistances.keys.toList();
  }

  /// Adds distance to a dog's total.
  void addDistance(Dog? dog, double distance) {
    if (dog != null) {
      String dogName = dog.name;
      dogDistances[dogName] = (dogDistances[dogName] ?? 0) + distance;
    }
  }

  /// Gets the distance of the running dog.
  double getDistance(Dog dog) {
    return dogDistances[dog.name] ?? 0;
  }
}
