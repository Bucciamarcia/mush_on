// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teamgroup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamReference {
  String get teamGroupId;
  String get teamId;

  /// Create a copy of TeamReference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamReferenceCopyWith<TeamReference> get copyWith =>
      _$TeamReferenceCopyWithImpl<TeamReference>(
          this as TeamReference, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamReference &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, teamGroupId, teamId);

  @override
  String toString() {
    return 'TeamReference(teamGroupId: $teamGroupId, teamId: $teamId)';
  }
}

/// @nodoc
abstract mixin class $TeamReferenceCopyWith<$Res> {
  factory $TeamReferenceCopyWith(
          TeamReference value, $Res Function(TeamReference) _then) =
      _$TeamReferenceCopyWithImpl;
  @useResult
  $Res call({String teamGroupId, String teamId});
}

/// @nodoc
class _$TeamReferenceCopyWithImpl<$Res>
    implements $TeamReferenceCopyWith<$Res> {
  _$TeamReferenceCopyWithImpl(this._self, this._then);

  final TeamReference _self;
  final $Res Function(TeamReference) _then;

  /// Create a copy of TeamReference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamGroupId = null,
    Object? teamId = null,
  }) {
    return _then(_self.copyWith(
      teamGroupId: null == teamGroupId
          ? _self.teamGroupId
          : teamGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _self.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [TeamReference].
extension TeamReferencePatterns on TeamReference {
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
    TResult Function(_TeamReference value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeamReference() when $default != null:
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
    TResult Function(_TeamReference value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamReference():
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
    TResult? Function(_TeamReference value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamReference() when $default != null:
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
    TResult Function(String teamGroupId, String teamId)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeamReference() when $default != null:
        return $default(_that.teamGroupId, _that.teamId);
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
    TResult Function(String teamGroupId, String teamId) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamReference():
        return $default(_that.teamGroupId, _that.teamId);
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
    TResult? Function(String teamGroupId, String teamId)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamReference() when $default != null:
        return $default(_that.teamGroupId, _that.teamId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TeamReference implements TeamReference {
  const _TeamReference({required this.teamGroupId, required this.teamId});

  @override
  final String teamGroupId;
  @override
  final String teamId;

  /// Create a copy of TeamReference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamReferenceCopyWith<_TeamReference> get copyWith =>
      __$TeamReferenceCopyWithImpl<_TeamReference>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamReference &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, teamGroupId, teamId);

  @override
  String toString() {
    return 'TeamReference(teamGroupId: $teamGroupId, teamId: $teamId)';
  }
}

/// @nodoc
abstract mixin class _$TeamReferenceCopyWith<$Res>
    implements $TeamReferenceCopyWith<$Res> {
  factory _$TeamReferenceCopyWith(
          _TeamReference value, $Res Function(_TeamReference) _then) =
      __$TeamReferenceCopyWithImpl;
  @override
  @useResult
  $Res call({String teamGroupId, String teamId});
}

/// @nodoc
class __$TeamReferenceCopyWithImpl<$Res>
    implements _$TeamReferenceCopyWith<$Res> {
  __$TeamReferenceCopyWithImpl(this._self, this._then);

  final _TeamReference _self;
  final $Res Function(_TeamReference) _then;

  /// Create a copy of TeamReference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? teamGroupId = null,
    Object? teamId = null,
  }) {
    return _then(_TeamReference(
      teamGroupId: null == teamGroupId
          ? _self.teamGroupId
          : teamGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _self.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$DogPairsReference {
  String get teamGroupId;
  String get teamId;
  List<DogPair> get dogPairs;

  /// Create a copy of DogPairsReference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogPairsReferenceCopyWith<DogPairsReference> get copyWith =>
      _$DogPairsReferenceCopyWithImpl<DogPairsReference>(
          this as DogPairsReference, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogPairsReference &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            const DeepCollectionEquality().equals(other.dogPairs, dogPairs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, teamGroupId, teamId,
      const DeepCollectionEquality().hash(dogPairs));

  @override
  String toString() {
    return 'DogPairsReference(teamGroupId: $teamGroupId, teamId: $teamId, dogPairs: $dogPairs)';
  }
}

/// @nodoc
abstract mixin class $DogPairsReferenceCopyWith<$Res> {
  factory $DogPairsReferenceCopyWith(
          DogPairsReference value, $Res Function(DogPairsReference) _then) =
      _$DogPairsReferenceCopyWithImpl;
  @useResult
  $Res call({String teamGroupId, String teamId, List<DogPair> dogPairs});
}

/// @nodoc
class _$DogPairsReferenceCopyWithImpl<$Res>
    implements $DogPairsReferenceCopyWith<$Res> {
  _$DogPairsReferenceCopyWithImpl(this._self, this._then);

  final DogPairsReference _self;
  final $Res Function(DogPairsReference) _then;

  /// Create a copy of DogPairsReference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamGroupId = null,
    Object? teamId = null,
    Object? dogPairs = null,
  }) {
    return _then(_self.copyWith(
      teamGroupId: null == teamGroupId
          ? _self.teamGroupId
          : teamGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _self.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      dogPairs: null == dogPairs
          ? _self.dogPairs
          : dogPairs // ignore: cast_nullable_to_non_nullable
              as List<DogPair>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DogPairsReference].
extension DogPairsReferencePatterns on DogPairsReference {
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
    TResult Function(_DogPairsReference value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogPairsReference() when $default != null:
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
    TResult Function(_DogPairsReference value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPairsReference():
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
    TResult? Function(_DogPairsReference value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPairsReference() when $default != null:
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
    TResult Function(String teamGroupId, String teamId, List<DogPair> dogPairs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogPairsReference() when $default != null:
        return $default(_that.teamGroupId, _that.teamId, _that.dogPairs);
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
    TResult Function(String teamGroupId, String teamId, List<DogPair> dogPairs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPairsReference():
        return $default(_that.teamGroupId, _that.teamId, _that.dogPairs);
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
    TResult? Function(
            String teamGroupId, String teamId, List<DogPair> dogPairs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPairsReference() when $default != null:
        return $default(_that.teamGroupId, _that.teamId, _that.dogPairs);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DogPairsReference implements DogPairsReference {
  const _DogPairsReference(
      {required this.teamGroupId,
      required this.teamId,
      required final List<DogPair> dogPairs})
      : _dogPairs = dogPairs;

  @override
  final String teamGroupId;
  @override
  final String teamId;
  final List<DogPair> _dogPairs;
  @override
  List<DogPair> get dogPairs {
    if (_dogPairs is EqualUnmodifiableListView) return _dogPairs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dogPairs);
  }

  /// Create a copy of DogPairsReference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogPairsReferenceCopyWith<_DogPairsReference> get copyWith =>
      __$DogPairsReferenceCopyWithImpl<_DogPairsReference>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogPairsReference &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            const DeepCollectionEquality().equals(other._dogPairs, _dogPairs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, teamGroupId, teamId,
      const DeepCollectionEquality().hash(_dogPairs));

  @override
  String toString() {
    return 'DogPairsReference(teamGroupId: $teamGroupId, teamId: $teamId, dogPairs: $dogPairs)';
  }
}

/// @nodoc
abstract mixin class _$DogPairsReferenceCopyWith<$Res>
    implements $DogPairsReferenceCopyWith<$Res> {
  factory _$DogPairsReferenceCopyWith(
          _DogPairsReference value, $Res Function(_DogPairsReference) _then) =
      __$DogPairsReferenceCopyWithImpl;
  @override
  @useResult
  $Res call({String teamGroupId, String teamId, List<DogPair> dogPairs});
}

/// @nodoc
class __$DogPairsReferenceCopyWithImpl<$Res>
    implements _$DogPairsReferenceCopyWith<$Res> {
  __$DogPairsReferenceCopyWithImpl(this._self, this._then);

  final _DogPairsReference _self;
  final $Res Function(_DogPairsReference) _then;

  /// Create a copy of DogPairsReference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? teamGroupId = null,
    Object? teamId = null,
    Object? dogPairs = null,
  }) {
    return _then(_DogPairsReference(
      teamGroupId: null == teamGroupId
          ? _self.teamGroupId
          : teamGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _self.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      dogPairs: null == dogPairs
          ? _self._dogPairs
          : dogPairs // ignore: cast_nullable_to_non_nullable
              as List<DogPair>,
    ));
  }
}

// dart format on
