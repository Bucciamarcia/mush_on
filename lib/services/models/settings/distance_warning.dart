import 'package:freezed_annotation/freezed_annotation.dart';
part 'distance_warning.g.dart';
part 'distance_warning.freezed.dart';

@freezed
abstract class DistanceWarning with _$DistanceWarning {
  @JsonSerializable(explicitToJson: true)
  const factory DistanceWarning({
    @Default("") String id,
    @Default(9) int daysInterval,
    @Default(0) int distance,
    @Default(DistanceWarningType.soft) DistanceWarningType distanceWarningType,
  }) = _DistanceWarning;
  factory DistanceWarning.fromJson(Map<String, dynamic> json) =>
      _$DistanceWarningFromJson(json);
}

extension DistanceWarningExtension on List<DistanceWarning> {
  /// Reorders the list with hard limits first.
  List<DistanceWarning> hardFirst() {
    return where((element) =>
            element.distanceWarningType == DistanceWarningType.hard)
        .followedBy(
          where((element) =>
              element.distanceWarningType == DistanceWarningType.soft),
        )
        .toList();
  }

  /// Orders the tasks with the shortest limit distance first.
  List<DistanceWarning> orderByDistanceAscending() {
    var toReturn = List<DistanceWarning>.from(this);
    toReturn.sort((a, b) => a.distance.compareTo(b.distance));
    return toReturn;
  }

  /// Orders the tasks by type and distance.
  List<DistanceWarning> sortByTypeAndDistance() {
    var toReturn = List<DistanceWarning>.from(this);
    toReturn.sort((a, b) {
      // First sort by type (hard before soft)
      if (a.distanceWarningType != b.distanceWarningType) {
        return b.distanceWarningType.index
            .compareTo(a.distanceWarningType.index);
      }
      // Then sort by distance
      return a.distance.compareTo(b.distance);
    });
    return toReturn;
  }
}

@JsonEnum()
enum DistanceWarningType {
  @JsonValue("soft")
  soft,
  @JsonValue("hard")
  hard
}
