// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SingleDogNote {
  @TimestampConverter()
  DateTime? get date;
  String get id;
  String get content;

  /// Create a copy of SingleDogNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SingleDogNoteCopyWith<SingleDogNote> get copyWith =>
      _$SingleDogNoteCopyWithImpl<SingleDogNote>(
          this as SingleDogNote, _$identity);

  /// Serializes this SingleDogNote to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SingleDogNote &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, id, content);

  @override
  String toString() {
    return 'SingleDogNote(date: $date, id: $id, content: $content)';
  }
}

/// @nodoc
abstract mixin class $SingleDogNoteCopyWith<$Res> {
  factory $SingleDogNoteCopyWith(
          SingleDogNote value, $Res Function(SingleDogNote) _then) =
      _$SingleDogNoteCopyWithImpl;
  @useResult
  $Res call({@TimestampConverter() DateTime? date, String id, String content});
}

/// @nodoc
class _$SingleDogNoteCopyWithImpl<$Res>
    implements $SingleDogNoteCopyWith<$Res> {
  _$SingleDogNoteCopyWithImpl(this._self, this._then);

  final SingleDogNote _self;
  final $Res Function(SingleDogNote) _then;

  /// Create a copy of SingleDogNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? id = null,
    Object? content = null,
  }) {
    return _then(_self.copyWith(
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [SingleDogNote].
extension SingleDogNotePatterns on SingleDogNote {
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
    TResult Function(_SingleDogNote value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SingleDogNote() when $default != null:
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
    TResult Function(_SingleDogNote value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SingleDogNote():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_SingleDogNote value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SingleDogNote() when $default != null:
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
    TResult Function(
            @TimestampConverter() DateTime? date, String id, String content)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SingleDogNote() when $default != null:
        return $default(_that.date, _that.id, _that.content);
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
    TResult Function(
            @TimestampConverter() DateTime? date, String id, String content)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SingleDogNote():
        return $default(_that.date, _that.id, _that.content);
      case _:
        throw StateError('Unexpected subclass');
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
            @TimestampConverter() DateTime? date, String id, String content)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SingleDogNote() when $default != null:
        return $default(_that.date, _that.id, _that.content);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SingleDogNote implements SingleDogNote {
  const _SingleDogNote(
      {@TimestampConverter() this.date, this.id = "", this.content = ""});
  factory _SingleDogNote.fromJson(Map<String, dynamic> json) =>
      _$SingleDogNoteFromJson(json);

  @override
  @TimestampConverter()
  final DateTime? date;
  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String content;

  /// Create a copy of SingleDogNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SingleDogNoteCopyWith<_SingleDogNote> get copyWith =>
      __$SingleDogNoteCopyWithImpl<_SingleDogNote>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SingleDogNoteToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SingleDogNote &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, id, content);

  @override
  String toString() {
    return 'SingleDogNote(date: $date, id: $id, content: $content)';
  }
}

/// @nodoc
abstract mixin class _$SingleDogNoteCopyWith<$Res>
    implements $SingleDogNoteCopyWith<$Res> {
  factory _$SingleDogNoteCopyWith(
          _SingleDogNote value, $Res Function(_SingleDogNote) _then) =
      __$SingleDogNoteCopyWithImpl;
  @override
  @useResult
  $Res call({@TimestampConverter() DateTime? date, String id, String content});
}

/// @nodoc
class __$SingleDogNoteCopyWithImpl<$Res>
    implements _$SingleDogNoteCopyWith<$Res> {
  __$SingleDogNoteCopyWithImpl(this._self, this._then);

  final _SingleDogNote _self;
  final $Res Function(_SingleDogNote) _then;

  /// Create a copy of SingleDogNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = freezed,
    Object? id = null,
    Object? content = null,
  }) {
    return _then(_SingleDogNote(
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
