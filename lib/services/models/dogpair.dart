import 'package:freezed_annotation/freezed_annotation.dart';
part 'dogpair.g.dart';
part 'dogpair.freezed.dart';

@freezed

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
sealed class DogPair with _$DogPair {
  const factory DogPair({
    @Default("") String id,
    String? firstDogId,
    String? secondDogId,
  }) = _DogPair;
  const DogPair._();

  bool get isEmpty => firstDogId == null && secondDogId == null;

  factory DogPair.fromJson(Map<String, dynamic> json) =>
      _$DogPairFromJson(json);
}
