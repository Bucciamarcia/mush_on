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
mixin _$DogNote {
  String get dogId;
  List<DogNoteMessage> get dogNoteMessage;

  /// Create a copy of DogNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogNoteCopyWith<DogNote> get copyWith =>
      _$DogNoteCopyWithImpl<DogNote>(this as DogNote, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogNote &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            const DeepCollectionEquality()
                .equals(other.dogNoteMessage, dogNoteMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, dogId, const DeepCollectionEquality().hash(dogNoteMessage));

  @override
  String toString() {
    return 'DogNote(dogId: $dogId, dogNoteMessage: $dogNoteMessage)';
  }
}

/// @nodoc
abstract mixin class $DogNoteCopyWith<$Res> {
  factory $DogNoteCopyWith(DogNote value, $Res Function(DogNote) _then) =
      _$DogNoteCopyWithImpl;
  @useResult
  $Res call({String dogId, List<DogNoteMessage> dogNoteMessage});
}

/// @nodoc
class _$DogNoteCopyWithImpl<$Res> implements $DogNoteCopyWith<$Res> {
  _$DogNoteCopyWithImpl(this._self, this._then);

  final DogNote _self;
  final $Res Function(DogNote) _then;

  /// Create a copy of DogNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dogId = null,
    Object? dogNoteMessage = null,
  }) {
    return _then(_self.copyWith(
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      dogNoteMessage: null == dogNoteMessage
          ? _self.dogNoteMessage
          : dogNoteMessage // ignore: cast_nullable_to_non_nullable
              as List<DogNoteMessage>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DogNote].
extension DogNotePatterns on DogNote {
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
    TResult Function(_DogNote value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogNote() when $default != null:
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
    TResult Function(_DogNote value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogNote():
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
    TResult? Function(_DogNote value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogNote() when $default != null:
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
    TResult Function(String dogId, List<DogNoteMessage> dogNoteMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogNote() when $default != null:
        return $default(_that.dogId, _that.dogNoteMessage);
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
    TResult Function(String dogId, List<DogNoteMessage> dogNoteMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogNote():
        return $default(_that.dogId, _that.dogNoteMessage);
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
    TResult? Function(String dogId, List<DogNoteMessage> dogNoteMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogNote() when $default != null:
        return $default(_that.dogId, _that.dogNoteMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DogNote implements DogNote {
  const _DogNote(
      {required this.dogId, required final List<DogNoteMessage> dogNoteMessage})
      : _dogNoteMessage = dogNoteMessage;

  @override
  final String dogId;
  final List<DogNoteMessage> _dogNoteMessage;
  @override
  List<DogNoteMessage> get dogNoteMessage {
    if (_dogNoteMessage is EqualUnmodifiableListView) return _dogNoteMessage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dogNoteMessage);
  }

  /// Create a copy of DogNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogNoteCopyWith<_DogNote> get copyWith =>
      __$DogNoteCopyWithImpl<_DogNote>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogNote &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            const DeepCollectionEquality()
                .equals(other._dogNoteMessage, _dogNoteMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, dogId, const DeepCollectionEquality().hash(_dogNoteMessage));

  @override
  String toString() {
    return 'DogNote(dogId: $dogId, dogNoteMessage: $dogNoteMessage)';
  }
}

/// @nodoc
abstract mixin class _$DogNoteCopyWith<$Res> implements $DogNoteCopyWith<$Res> {
  factory _$DogNoteCopyWith(_DogNote value, $Res Function(_DogNote) _then) =
      __$DogNoteCopyWithImpl;
  @override
  @useResult
  $Res call({String dogId, List<DogNoteMessage> dogNoteMessage});
}

/// @nodoc
class __$DogNoteCopyWithImpl<$Res> implements _$DogNoteCopyWith<$Res> {
  __$DogNoteCopyWithImpl(this._self, this._then);

  final _DogNote _self;
  final $Res Function(_DogNote) _then;

  /// Create a copy of DogNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dogId = null,
    Object? dogNoteMessage = null,
  }) {
    return _then(_DogNote(
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      dogNoteMessage: null == dogNoteMessage
          ? _self._dogNoteMessage
          : dogNoteMessage // ignore: cast_nullable_to_non_nullable
              as List<DogNoteMessage>,
    ));
  }
}

// dart format on
