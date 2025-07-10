import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed

/// Class representing a single custom field value for a single dog.
/// Must be assigned to a template ID.
///
/// Eg. "Favorite toy -> Stuffed fox"
abstract class CustomField with _$CustomField {
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

    /// ADDED: A list of options for a dropdown.
    /// Must not be empty if type is [CustomFieldType.typeDropdown].
    /// This is ignored for other types.
    List<String>? options,
  }) = _CustomFieldTemplate;

  factory CustomFieldTemplate.fromJson(Map<String, Object?> json) =>
      _$CustomFieldTemplateFromJson(json);
}

@freezed
sealed class CustomFieldValue with _$CustomFieldValue {
  const CustomFieldValue._();
  static BasicLogger logger = BasicLogger();
  const factory CustomFieldValue.stringValue(String value) = StringValue;
  const factory CustomFieldValue.intValue(int value) = IntValue;
  // CHANGED: The value of a dropdown is the single selected string.
  const factory CustomFieldValue.dropdownValue(String value) = DropdownValue;

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
      case CustomFieldType.typeDropdown:
        // CHANGED: This now correctly returns a dropdownValue with a single string.
        // You might want to add validation to ensure the value is in template.options.
        if (template.options?.contains(value) == false) {
          logger.warning(
              "The value '$value' is not a valid option for this dropdown.");
        }
        return CustomFieldValue.dropdownValue(value);
    }
  }

  /// Returns the string representation of this value.
  String getStringValue() {
    return switch (this) {
      StringValue(:final value) => value,
      IntValue(:final value) => value.toString(),
      // CHANGED: This now correctly returns the string from the DropdownValue.
      DropdownValue(:final value) => value,
    };
  }

  /// Returns the int value of this object. Throws an exception if the value is not an int.
  int getIntValue() {
    // FIXED: The switch statement is now exhaustive.
    return switch (this) {
      IntValue(:final value) => value,
      StringValue() ||
      DropdownValue() =>
        throw Exception("The value is not an int! It is a $runtimeType"),
    };
  }

  factory CustomFieldValue.fromJson(Map<String, Object?> json) =>
      _$CustomFieldValueFromJson(json);
}

@JsonEnum()
enum CustomFieldType {
  @JsonValue('string')
  typeString(type: String, showToUser: "Text"),

  @JsonValue('int')
  typeInt(type: int, showToUser: "Number"),

  // CHANGED: The underlying type of a dropdown's *value* is String.
  @JsonValue('dropdown')
  typeDropdown(type: String, showToUser: "Dropdown");

  final Type type;

  /// The name of this type to show to the user in the UI.
  final String showToUser;
  const CustomFieldType({required this.type, required this.showToUser});
}
