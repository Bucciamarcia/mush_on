import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/custom_converters.dart';
import 'package:mush_on/services/models/tasks.dart';
part 'models.g.dart';
part 'models.freezed.dart';

@freezed

/// Just a class that contains all the riverpod results that Homepage needs
abstract class HomePageRiverpodResults with _$HomePageRiverpodResults {
  const factory HomePageRiverpodResults({
    required List<Dog> dogs,
    required TasksInMemory tasks,
    required List<HeatCycle> heatCycles,
    required List<HealthEvent> healthEvents,
    required List<WhiteboardElement> whiteboardElements,
  }) = _HomePageRiverpodResults;
}

@freezed

/// An element of the whiteboard in the home page.
abstract class WhiteboardElement with _$WhiteboardElement {
  @JsonSerializable(explicitToJson: true)
  const factory WhiteboardElement({
    required String id,
    @Default("") String title,
    @Default("") String description,
    @NonNullableTimestampConverter() required DateTime date,
    @Default(<WhiteboardElementComment>[])
    List<WhiteboardElementComment> comments,
  }) = _WhiteboardElement;

  factory WhiteboardElement.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardElementFromJson(json);
}

@freezed
abstract class WhiteboardElementComment with _$WhiteboardElementComment {
  const factory WhiteboardElementComment({
    @Default("") String comment,
    @NonNullableTimestampConverter() required DateTime date,
  }) = _WhiteboardElementComment;
  factory WhiteboardElementComment.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardElementCommentFromJson(json);
}
