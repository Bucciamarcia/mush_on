import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.freezed.dart';

@freezed
sealed class DogDailyStats with _$DogDailyStats {
  const factory DogDailyStats({
    required DateTime date,
    required double distanceRan,
  }) = _DogDailyStats;
}
