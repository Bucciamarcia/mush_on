import 'package:freezed_annotation/freezed_annotation.dart';
part "notes.freezed.dart";
part "notes.g.dart";

@freezed

/// A dog note.
abstract class SingleDogNote with _$SingleDogNote {
  const factory SingleDogNote({
    DateTime? date,
    @Default("") String id,
    @Default("") String content,
  }) = _SingleDogNote;

  factory SingleDogNote.fromJson(Map<String, dynamic> json) =>
      _$SingleDogNoteFromJson(json);
}
