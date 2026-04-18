import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.freezed.dart';
part 'models.g.dart';

class GeminiSchema {
  static Schema get schema {
    return Schema.object(
      properties: {
        "dogs": Schema.array(
          items: Schema.string(
            title:
                "The name of the dog, always first letter capitalized, eg `Fido`",
          ),
        ),
        "isSuccessful": Schema.boolean(
          title: "Whether the operation is successful",
          description:
              "True if a list of dogs can be extracted. False if it can't be extracted or the document doesn't contain a list of dogs",
        ),
      },
    );
  }
}

@freezed
sealed class ImportDogResult with _$ImportDogResult {
  const factory ImportDogResult({
    required List<String> dogs,
    required bool isSuccessful,
  }) = _ImportDogResult;
  factory ImportDogResult.fromJson(Map<String, dynamic> json) =>
      _$ImportDogResultFromJson(json);
  const ImportDogResult._();
  int get length => dogs.length;

  static ImportDogResult decode(String source) {
    return ImportDogResult.fromJson(jsonDecode(source));
  }
}
