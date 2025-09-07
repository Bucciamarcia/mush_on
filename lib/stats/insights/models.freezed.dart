// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// Adds pattern-matching-related methods to [DogDailyStats].
extension DogDailyStatsPatterns on DogDailyStats {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DogDailyStats value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogDailyStats() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DogDailyStats value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDailyStats():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DogDailyStats value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDailyStats() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DateTime date, double distanceRan)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogDailyStats() when $default != null:
        return $default(_that.date, _that.distanceRan);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DateTime date, double distanceRan) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDailyStats():
        return $default(_that.date, _that.distanceRan);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DateTime date, double distanceRan)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDailyStats() when $default != null:
        return $default(_that.date, _that.distanceRan);
      case _:
        return null;
    }
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

/// @nodoc
mixin _$ReliabilityMatrixChartData {
  String get dogId;
  double get x;
  double get y;

  /// Create a copy of ReliabilityMatrixChartData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReliabilityMatrixChartDataCopyWith<ReliabilityMatrixChartData>
      get copyWith =>
          _$ReliabilityMatrixChartDataCopyWithImpl<ReliabilityMatrixChartData>(
              this as ReliabilityMatrixChartData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReliabilityMatrixChartData &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dogId, x, y);

  @override
  String toString() {
    return 'ReliabilityMatrixChartData(dogId: $dogId, x: $x, y: $y)';
  }
}

/// @nodoc
abstract mixin class $ReliabilityMatrixChartDataCopyWith<$Res> {
  factory $ReliabilityMatrixChartDataCopyWith(ReliabilityMatrixChartData value,
          $Res Function(ReliabilityMatrixChartData) _then) =
      _$ReliabilityMatrixChartDataCopyWithImpl;
  @useResult
  $Res call({String dogId, double x, double y});
}

/// @nodoc
class _$ReliabilityMatrixChartDataCopyWithImpl<$Res>
    implements $ReliabilityMatrixChartDataCopyWith<$Res> {
  _$ReliabilityMatrixChartDataCopyWithImpl(this._self, this._then);

  final ReliabilityMatrixChartData _self;
  final $Res Function(ReliabilityMatrixChartData) _then;

  /// Create a copy of ReliabilityMatrixChartData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dogId = null,
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_self.copyWith(
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReliabilityMatrixChartData].
extension ReliabilityMatrixChartDataPatterns on ReliabilityMatrixChartData {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ReliabilityMatrixChartData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReliabilityMatrixChartData() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ReliabilityMatrixChartData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReliabilityMatrixChartData():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ReliabilityMatrixChartData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReliabilityMatrixChartData() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String dogId, double x, double y)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReliabilityMatrixChartData() when $default != null:
        return $default(_that.dogId, _that.x, _that.y);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String dogId, double x, double y) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReliabilityMatrixChartData():
        return $default(_that.dogId, _that.x, _that.y);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String dogId, double x, double y)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReliabilityMatrixChartData() when $default != null:
        return $default(_that.dogId, _that.x, _that.y);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReliabilityMatrixChartData implements ReliabilityMatrixChartData {
  const _ReliabilityMatrixChartData(
      {required this.dogId, required this.x, required this.y});

  @override
  final String dogId;
  @override
  final double x;
  @override
  final double y;

  /// Create a copy of ReliabilityMatrixChartData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReliabilityMatrixChartDataCopyWith<_ReliabilityMatrixChartData>
      get copyWith => __$ReliabilityMatrixChartDataCopyWithImpl<
          _ReliabilityMatrixChartData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReliabilityMatrixChartData &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dogId, x, y);

  @override
  String toString() {
    return 'ReliabilityMatrixChartData(dogId: $dogId, x: $x, y: $y)';
  }
}

/// @nodoc
abstract mixin class _$ReliabilityMatrixChartDataCopyWith<$Res>
    implements $ReliabilityMatrixChartDataCopyWith<$Res> {
  factory _$ReliabilityMatrixChartDataCopyWith(
          _ReliabilityMatrixChartData value,
          $Res Function(_ReliabilityMatrixChartData) _then) =
      __$ReliabilityMatrixChartDataCopyWithImpl;
  @override
  @useResult
  $Res call({String dogId, double x, double y});
}

/// @nodoc
class __$ReliabilityMatrixChartDataCopyWithImpl<$Res>
    implements _$ReliabilityMatrixChartDataCopyWith<$Res> {
  __$ReliabilityMatrixChartDataCopyWithImpl(this._self, this._then);

  final _ReliabilityMatrixChartData _self;
  final $Res Function(_ReliabilityMatrixChartData) _then;

  /// Create a copy of ReliabilityMatrixChartData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dogId = null,
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_ReliabilityMatrixChartData(
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
