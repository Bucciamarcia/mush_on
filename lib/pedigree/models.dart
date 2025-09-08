import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models.dart';
part 'models.freezed.dart';

@freezed
sealed class DogLayout with _$DogLayout {
  const factory DogLayout({
    required Dog dog,
    required int rank,
  }) = _DogLayout;
}
