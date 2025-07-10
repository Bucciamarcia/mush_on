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
