import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed

/// Class representing a single custom field value for a single dog.
/// Must be assigned to a template ID.
///
/// Eg. "Favorite toy -> Stuffed fox"
sealed class CustomField with _$CustomField {
  @JsonSerializable(explicitToJson: true)
  const factory CustomField({
    /// The ID of the template this custom field is assigned to.
    required String templateId,
    required CustomFieldValue value,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, Object?> json) =>
      _$CustomFieldFromJson(json);
}

@freezed

/// Class with all the custom field types created by the user.
///
/// This is the TEMPLATE, the one set in the settings. A CustomField must have a template.
/// Eg. "Favorite toy"
abstract class CustomFieldTemplate with _$CustomFieldTemplate {
  const factory CustomFieldTemplate({
    required CustomFieldType type,
    required String name,
    required String id,
  }) = _CustomFieldTemplate;

  factory CustomFieldTemplate.fromJson(Map<String, Object?> json) =>
      _$CustomFieldTemplateFromJson(json);
}

@freezed
sealed class CustomFieldValue with _$CustomFieldValue {
  static BasicLogger logger = BasicLogger();
  const factory CustomFieldValue.stringValue(String value) = StringValue;
  const factory CustomFieldValue.intValue(int value) = IntValue;
  const factory CustomFieldValue.doubleValue(double value) = DoubleValue;

  /// Will return CustomFieldValue of the appropriate type depending on the template.
  static CustomFieldValue formatCustomFieldValue(
      CustomFieldTemplate template, String value) {
    switch (template.type) {
      case CustomFieldType.typeString:
        return CustomFieldValue.stringValue(value);
      case CustomFieldType.typeInt:
        try {
          return CustomFieldValue.intValue(int.parse(value));
        } catch (e, s) {
          logger.error("Couldn't parse int from string.",
              error: e, stackTrace: s);
          rethrow;
        }
      case CustomFieldType.typeDouble:
        try {
          return CustomFieldValue.doubleValue(double.parse(value));
        } catch (e, s) {
          logger.error("Couldn't parse double from string.",
              error: e, stackTrace: s);
          rethrow;
        }
    }
  }

  factory CustomFieldValue.fromJson(Map<String, Object?> json) =>
      _$CustomFieldValueFromJson(json);
}

@JsonEnum()
enum CustomFieldType {
  @JsonValue('string')
  typeString(type: String, showToUser: "Text"),

  @JsonValue('int')
  typeInt(type: int, showToUser: "Integer"),

  @JsonValue('double')
  typeDouble(type: double, showToUser: "Number");

  final Type type;

  /// The name of this type to show to the user in the UI.
  final String showToUser;
  const CustomFieldType({required this.type, required this.showToUser});
}
