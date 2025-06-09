import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
part 'settings.g.dart';
part 'settings.freezed.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    required List<CustomFieldTemplate> customFieldTemplates,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, Object?> json) =>
      _$SettingsModelFromJson(json);
}
