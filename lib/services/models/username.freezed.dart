// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'username.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserName {
  @TimestampConverter()
  DateTime? get lastLogin;
  String? get account;
  String get uid;
  String get email;
  String get name;

  /// Create a copy of UserName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserNameCopyWith<UserName> get copyWith =>
      _$UserNameCopyWithImpl<UserName>(this as UserName, _$identity);

  /// Serializes this UserName to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserName &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, lastLogin, account, uid, email, name);

  @override
  String toString() {
    return 'UserName(lastLogin: $lastLogin, account: $account, uid: $uid, email: $email, name: $name)';
  }
}

/// @nodoc
abstract mixin class $UserNameCopyWith<$Res> {
  factory $UserNameCopyWith(UserName value, $Res Function(UserName) _then) =
      _$UserNameCopyWithImpl;
  @useResult
  $Res call(
      {@TimestampConverter() DateTime? lastLogin,
      String? account,
      String uid,
      String email,
      String name});
}

/// @nodoc
class _$UserNameCopyWithImpl<$Res> implements $UserNameCopyWith<$Res> {
  _$UserNameCopyWithImpl(this._self, this._then);

  final UserName _self;
  final $Res Function(UserName) _then;

  /// Create a copy of UserName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastLogin = freezed,
    Object? account = freezed,
    Object? uid = null,
    Object? email = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      lastLogin: freezed == lastLogin
          ? _self.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      account: freezed == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserName extends UserName {
  const _UserName(
      {@TimestampConverter() this.lastLogin,
      this.account,
      required this.uid,
      required this.email,
      this.name = ""})
      : super._();
  factory _UserName.fromJson(Map<String, dynamic> json) =>
      _$UserNameFromJson(json);

  @override
  @TimestampConverter()
  final DateTime? lastLogin;
  @override
  final String? account;
  @override
  final String uid;
  @override
  final String email;
  @override
  @JsonKey()
  final String name;

  /// Create a copy of UserName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserNameCopyWith<_UserName> get copyWith =>
      __$UserNameCopyWithImpl<_UserName>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserNameToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserName &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, lastLogin, account, uid, email, name);

  @override
  String toString() {
    return 'UserName(lastLogin: $lastLogin, account: $account, uid: $uid, email: $email, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$UserNameCopyWith<$Res>
    implements $UserNameCopyWith<$Res> {
  factory _$UserNameCopyWith(_UserName value, $Res Function(_UserName) _then) =
      __$UserNameCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@TimestampConverter() DateTime? lastLogin,
      String? account,
      String uid,
      String email,
      String name});
}

/// @nodoc
class __$UserNameCopyWithImpl<$Res> implements _$UserNameCopyWith<$Res> {
  __$UserNameCopyWithImpl(this._self, this._then);

  final _UserName _self;
  final $Res Function(_UserName) _then;

  /// Create a copy of UserName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lastLogin = freezed,
    Object? account = freezed,
    Object? uid = null,
    Object? email = null,
    Object? name = null,
  }) {
    return _then(_UserName(
      lastLogin: freezed == lastLogin
          ? _self.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      account: freezed == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
