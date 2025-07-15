// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DogDailyStats {
  DateTime get date;
  double get distanceRan;

  /// Create a copy of DogDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogDailyStatsCopyWith<DogDailyStats> get copyWith =>
      _$DogDailyStatsCopyWithImpl<DogDailyStats>(
          this as DogDailyStats, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogDailyStats &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.distanceRan, distanceRan) ||
                other.distanceRan == distanceRan));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, distanceRan);

  @override
  String toString() {
    return 'DogDailyStats(date: $date, distanceRan: $distanceRan)';
  }
}

/// @nodoc
abstract mixin class $DogDailyStatsCopyWith<$Res> {
  factory $DogDailyStatsCopyWith(
          DogDailyStats value, $Res Function(DogDailyStats) _then) =
      _$DogDailyStatsCopyWithImpl;
  @useResult
  $Res call({DateTime date, double distanceRan});
}

/// @nodoc
class _$DogDailyStatsCopyWithImpl<$Res>
    implements $DogDailyStatsCopyWith<$Res> {
  _$DogDailyStatsCopyWithImpl(this._self, this._then);

  final DogDailyStats _self;
  final $Res Function(DogDailyStats) _then;

  /// Create a copy of DogDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? distanceRan = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distanceRan: null == distanceRan
          ? _self.distanceRan
          : distanceRan // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _DogDailyStats implements DogDailyStats {
  const _DogDailyStats({required this.date, required this.distanceRan});

  @override
  final DateTime date;
  @override
  final double distanceRan;

  /// Create a copy of DogDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogDailyStatsCopyWith<_DogDailyStats> get copyWith =>
      __$DogDailyStatsCopyWithImpl<_DogDailyStats>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogDailyStats &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.distanceRan, distanceRan) ||
                other.distanceRan == distanceRan));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, distanceRan);

  @override
  String toString() {
    return 'DogDailyStats(date: $date, distanceRan: $distanceRan)';
  }
}

/// @nodoc
abstract mixin class _$DogDailyStatsCopyWith<$Res>
    implements $DogDailyStatsCopyWith<$Res> {
  factory _$DogDailyStatsCopyWith(
          _DogDailyStats value, $Res Function(_DogDailyStats) _then) =
      __$DogDailyStatsCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, double distanceRan});
}

/// @nodoc
class __$DogDailyStatsCopyWithImpl<$Res>
    implements _$DogDailyStatsCopyWith<$Res> {
  __$DogDailyStatsCopyWithImpl(this._self, this._then);

  final _DogDailyStats _self;
  final $Res Function(_DogDailyStats) _then;

  /// Create a copy of DogDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? distanceRan = null,
  }) {
    return _then(_DogDailyStats(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distanceRan: null == distanceRan
          ? _self.distanceRan
          : distanceRan // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
