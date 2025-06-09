import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
part 'settings.g.dart';
part 'settings.freezed.dart';

@freezed
abstract class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @Default([]) List<CustomFieldTemplate> customFieldTemplates,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
