import 'package:json_annotation/json_annotation.dart';
part 'dogpair.g.dart';

@JsonSerializable()

/// A class representing a pair of dogs in a team.
/// A [DogPair] consists of two [Dog] objects.
/// This class is serializable to/from JSON using the json_serializable package.
/// Example:
/// ```dart
/// final pair = DogPair(
/// firstDog: Dog(name: "Buddy"),
/// secondDog: Dog(name: "Rex"),
/// );
/// ```
class DogPair {
  String? firstDogId;
  String? secondDogId;

  DogPair({
    this.firstDogId,
    this.secondDogId,
  });

  bool get isEmpty => firstDogId == null && secondDogId == null;

  factory DogPair.fromJson(Map<String, dynamic> json) =>
      _$DogPairFromJson(json);
  Map<String, dynamic> toJson() => _$DogPairToJson(this);
}
