// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riverpod.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatsDateRange {
  DateTime get startDate;
  DateTime get endDate;

  /// Create a copy of StatsDateRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatsDateRangeCopyWith<StatsDateRange> get copyWith =>
      _$StatsDateRangeCopyWithImpl<StatsDateRange>(
          this as StatsDateRange, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatsDateRange &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  @override
  String toString() {
    return 'StatsDateRange(startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $StatsDateRangeCopyWith<$Res> {
  factory $StatsDateRangeCopyWith(
          StatsDateRange value, $Res Function(StatsDateRange) _then) =
      _$StatsDateRangeCopyWithImpl;
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class _$StatsDateRangeCopyWithImpl<$Res>
    implements $StatsDateRangeCopyWith<$Res> {
  _$StatsDateRangeCopyWithImpl(this._self, this._then);

  final StatsDateRange _self;
  final $Res Function(StatsDateRange) _then;

  /// Create a copy of StatsDateRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_self.copyWith(
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _StatsDateRange extends StatsDateRange {
  const _StatsDateRange({required this.startDate, required this.endDate})
      : super._();

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  /// Create a copy of StatsDateRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatsDateRangeCopyWith<_StatsDateRange> get copyWith =>
      __$StatsDateRangeCopyWithImpl<_StatsDateRange>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatsDateRange &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  @override
  String toString() {
    return 'StatsDateRange(startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$StatsDateRangeCopyWith<$Res>
    implements $StatsDateRangeCopyWith<$Res> {
  factory _$StatsDateRangeCopyWith(
          _StatsDateRange value, $Res Function(_StatsDateRange) _then) =
      __$StatsDateRangeCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class __$StatsDateRangeCopyWithImpl<$Res>
    implements _$StatsDateRangeCopyWith<$Res> {
  __$StatsDateRangeCopyWithImpl(this._self, this._then);

  final _StatsDateRange _self;
  final $Res Function(_StatsDateRange) _then;

  /// Create a copy of StatsDateRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_StatsDateRange(
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
