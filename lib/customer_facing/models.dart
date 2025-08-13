import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.freezed.dart';
part 'models.g.dart';

@freezed

/// Simple utility dataclass that holds the dog photo and its filename
sealed class DogPhoto with _$DogPhoto {
  const factory DogPhoto({
    required String fileName,
    required Uint8List data,
    required bool isAvatar,
  }) = _DogPhoto;
}

@freezed

/// Model for the db that contains the dog id and the data
sealed class DogCustomerFacingInfo with _$DogCustomerFacingInfo {
  const factory DogCustomerFacingInfo({
    required String id,
    required String dogId,
    @Default("") String description,
  }) = _DogCustomerFacingInfo;

  factory DogCustomerFacingInfo.fromJson(Map<String, dynamic> json) =>
      _$DogCustomerFacingInfoFromJson(json);
}
