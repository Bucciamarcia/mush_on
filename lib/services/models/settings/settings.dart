import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'distance_warning.dart';
part 'settings.g.dart';
part 'settings.freezed.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  @JsonSerializable(explicitToJson: true)
  const factory SettingsModel({
    @Default([]) List<CustomFieldTemplate> customFieldTemplates,
    @Default([]) List<DistanceWarning> globalDistanceWarnings,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
