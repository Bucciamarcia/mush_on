import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.freezed.dart';
part 'riverpod.g.dart';

@freezed
abstract class StatsDateRange with _$StatsDateRange {
  const factory StatsDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) = _StatsDateRange;

  factory StatsDateRange.initial() => StatsDateRange(
        endDate: DateTimeUtils.today(),
        startDate: DateTimeUtils.today().subtract(const Duration(days: 30)),
      );

  const StatsDateRange._();
}

@riverpod
class StatsDates extends _$StatsDates {
  @override
  StatsDateRange build() {
    return StatsDateRange.initial();
  }

  void changeStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void changeEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }
}

@riverpod
class FilteredDogs extends _$FilteredDogs {
  @override
  List<Dog> build() {
    return [];
  }

  void changeFilteredDogs(List<Dog> newDogs) {
    state = newDogs;
  }
}
