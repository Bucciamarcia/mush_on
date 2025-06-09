import 'package:freezed_annotation/freezed_annotation.dart';
part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed

/// Class representing the data for a custom field.
abstract class CustomField with _$CustomField {
  const factory CustomField({
    required String id,
    required String name,
    required CustomFieldValue value,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, Object?> json) =>
      _$CustomFieldFromJson(json);
}

@freezed
sealed class CustomFieldValue with _$CustomFieldValue {
  const factory CustomFieldValue.stringValue(String value) = _StringValue;
  const factory CustomFieldValue.intValue(int value) = _IntValue;

  factory CustomFieldValue.fromJson(Map<String, Object?> json) =>
      _$CustomFieldValueFromJson(json);
}

@JsonEnum()
enum CustomFieldType {
  @JsonValue('string')
  typeString(type: String),

  @JsonValue('int')
  typeInt(type: int);

  final Type type;
  const CustomFieldType({required this.type});
}
