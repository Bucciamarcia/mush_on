import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/models/custom_converters.dart';
part "notes.freezed.dart";
part "notes.g.dart";

@freezed

/// A dog note.
abstract class SingleDogNote with _$SingleDogNote {
  const factory SingleDogNote({
    @TimestampConverter() DateTime? date,
    @Default("") String id,
    @Default("") String content,
  }) = _SingleDogNote;

  factory SingleDogNote.fromJson(Map<String, dynamic> json) =>
      _$SingleDogNoteFromJson(json);
}
