import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/models.dart';
part 'riverpod.freezed.dart';
part 'riverpod.g.dart';

@riverpod

/// The date `start` and `end` date selected to be displayed.
/// Start defaults to 30 days ago at midnight (so slightly over 30 days),
/// end defaults to today at 23:59:59.
class SelectedDateRange extends _$SelectedDateRange {
  @override
  DateRangeSelection build() {
    return DateRangeSelection(
        start: DateTimeUtils.today().subtract(const Duration(days: 2)),
        end: DateTimeUtils.endOfToday());
  }
}

@riverpod
class SelectedDogs extends _$SelectedDogs {
  @override
  List<Dog> build() {
    return [];
  }

  void change(List<Dog> nd) {
    state = nd;
  }
}

@freezed

/// Indicates the `start` and `end` date selected for the range.
/// The start must always be 00:00:00, and the end must always be 23:59:59 of their respective days.
sealed class DateRangeSelection with _$DateRangeSelection {
  const factory DateRangeSelection({
    required DateTime start,
    required DateTime end,
  }) = _DateRangeSelection;
}
