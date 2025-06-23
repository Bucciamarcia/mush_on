import 'package:freezed_annotation/freezed_annotation.dart';
part 'distance_warning.g.dart';
part 'distance_warning.freezed.dart';

@freezed
abstract class DistanceWarning with _$DistanceWarning {
  @JsonSerializable(explicitToJson: true)
  const factory DistanceWarning({
    @Default(0) int distance,
    @Default(DistanceWarningType.soft) distanceWarningType,
  }) = _DistanceWarning;
  factory DistanceWarning.fromJson(Map<String, dynamic> json) =>
      _$DistanceWarningFromJson(json);
}

@JsonEnum()
enum DistanceWarningType {
  @JsonValue("soft")
  soft,
  @JsonValue("hard")
  hard
}
