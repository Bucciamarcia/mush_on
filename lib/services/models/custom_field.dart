import 'package:freezed_annotation/freezed_annotation.dart';
part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed

/// Class representing the data for a custom field.
abstract class CustomField with _$CustomField {
  const factory CustomField({
    required String id,
    required String name,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, Object?> json) =>
      _$CustomFieldFromJson(json);
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
