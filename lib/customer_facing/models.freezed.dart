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

/// @nodoc
mixin _$DogCustomerFacingInfo {
  String get id;
  String get dogId;
  String get description;

  /// Create a copy of DogCustomerFacingInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogCustomerFacingInfoCopyWith<DogCustomerFacingInfo> get copyWith =>
      _$DogCustomerFacingInfoCopyWithImpl<DogCustomerFacingInfo>(
          this as DogCustomerFacingInfo, _$identity);

  /// Serializes this DogCustomerFacingInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogCustomerFacingInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dogId, description);

  @override
  String toString() {
    return 'DogCustomerFacingInfo(id: $id, dogId: $dogId, description: $description)';
  }
}

/// @nodoc
abstract mixin class $DogCustomerFacingInfoCopyWith<$Res> {
  factory $DogCustomerFacingInfoCopyWith(DogCustomerFacingInfo value,
          $Res Function(DogCustomerFacingInfo) _then) =
      _$DogCustomerFacingInfoCopyWithImpl;
  @useResult
  $Res call({String id, String dogId, String description});
}

/// @nodoc
class _$DogCustomerFacingInfoCopyWithImpl<$Res>
    implements $DogCustomerFacingInfoCopyWith<$Res> {
  _$DogCustomerFacingInfoCopyWithImpl(this._self, this._then);

  final DogCustomerFacingInfo _self;
  final $Res Function(DogCustomerFacingInfo) _then;

  /// Create a copy of DogCustomerFacingInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? description = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DogCustomerFacingInfo implements DogCustomerFacingInfo {
  const _DogCustomerFacingInfo(
      {required this.id, required this.dogId, this.description = ""});
  factory _DogCustomerFacingInfo.fromJson(Map<String, dynamic> json) =>
      _$DogCustomerFacingInfoFromJson(json);

  @override
  final String id;
  @override
  final String dogId;
  @override
  @JsonKey()
  final String description;

  /// Create a copy of DogCustomerFacingInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogCustomerFacingInfoCopyWith<_DogCustomerFacingInfo> get copyWith =>
      __$DogCustomerFacingInfoCopyWithImpl<_DogCustomerFacingInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DogCustomerFacingInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogCustomerFacingInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dogId, description);

  @override
  String toString() {
    return 'DogCustomerFacingInfo(id: $id, dogId: $dogId, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$DogCustomerFacingInfoCopyWith<$Res>
    implements $DogCustomerFacingInfoCopyWith<$Res> {
  factory _$DogCustomerFacingInfoCopyWith(_DogCustomerFacingInfo value,
          $Res Function(_DogCustomerFacingInfo) _then) =
      __$DogCustomerFacingInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String dogId, String description});
}

/// @nodoc
class __$DogCustomerFacingInfoCopyWithImpl<$Res>
    implements _$DogCustomerFacingInfoCopyWith<$Res> {
  __$DogCustomerFacingInfoCopyWithImpl(this._self, this._then);

  final _DogCustomerFacingInfo _self;
  final $Res Function(_DogCustomerFacingInfo) _then;

  /// Create a copy of DogCustomerFacingInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? description = null,
  }) {
    return _then(_DogCustomerFacingInfo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
