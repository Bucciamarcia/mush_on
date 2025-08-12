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
mixin _$DogPhoto {
  String get fileName;
  Uint8List get data;
  bool get isAvatar;

  /// Create a copy of DogPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogPhotoCopyWith<DogPhoto> get copyWith =>
      _$DogPhotoCopyWithImpl<DogPhoto>(this as DogPhoto, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogPhoto &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.isAvatar, isAvatar) ||
                other.isAvatar == isAvatar));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileName,
      const DeepCollectionEquality().hash(data), isAvatar);

  @override
  String toString() {
    return 'DogPhoto(fileName: $fileName, data: $data, isAvatar: $isAvatar)';
  }
}

/// @nodoc
abstract mixin class $DogPhotoCopyWith<$Res> {
  factory $DogPhotoCopyWith(DogPhoto value, $Res Function(DogPhoto) _then) =
      _$DogPhotoCopyWithImpl;
  @useResult
  $Res call({String fileName, Uint8List data, bool isAvatar});
}

/// @nodoc
class _$DogPhotoCopyWithImpl<$Res> implements $DogPhotoCopyWith<$Res> {
  _$DogPhotoCopyWithImpl(this._self, this._then);

  final DogPhoto _self;
  final $Res Function(DogPhoto) _then;

  /// Create a copy of DogPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? data = null,
    Object? isAvatar = null,
  }) {
    return _then(_self.copyWith(
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      isAvatar: null == isAvatar
          ? _self.isAvatar
          : isAvatar // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _DogPhoto implements DogPhoto {
  const _DogPhoto(
      {required this.fileName, required this.data, required this.isAvatar});

  @override
  final String fileName;
  @override
  final Uint8List data;
  @override
  final bool isAvatar;

  /// Create a copy of DogPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogPhotoCopyWith<_DogPhoto> get copyWith =>
      __$DogPhotoCopyWithImpl<_DogPhoto>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogPhoto &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.isAvatar, isAvatar) ||
                other.isAvatar == isAvatar));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileName,
      const DeepCollectionEquality().hash(data), isAvatar);

  @override
  String toString() {
    return 'DogPhoto(fileName: $fileName, data: $data, isAvatar: $isAvatar)';
  }
}

/// @nodoc
abstract mixin class _$DogPhotoCopyWith<$Res>
    implements $DogPhotoCopyWith<$Res> {
  factory _$DogPhotoCopyWith(_DogPhoto value, $Res Function(_DogPhoto) _then) =
      __$DogPhotoCopyWithImpl;
  @override
  @useResult
  $Res call({String fileName, Uint8List data, bool isAvatar});
}

/// @nodoc
class __$DogPhotoCopyWithImpl<$Res> implements _$DogPhotoCopyWith<$Res> {
  __$DogPhotoCopyWithImpl(this._self, this._then);

  final _DogPhoto _self;
  final $Res Function(_DogPhoto) _then;

  /// Create a copy of DogPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fileName = null,
    Object? data = null,
    Object? isAvatar = null,
  }) {
    return _then(_DogPhoto(
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      isAvatar: null == isAvatar
          ? _self.isAvatar
          : isAvatar // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
