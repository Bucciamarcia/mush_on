// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserInvitation {
  String get email;
  UserLevel get userLevel;
  String get account;
  String get senderUid;

  /// Create a copy of UserInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserInvitationCopyWith<UserInvitation> get copyWith =>
      _$UserInvitationCopyWithImpl<UserInvitation>(
          this as UserInvitation, _$identity);

  /// Serializes this UserInvitation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserInvitation &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userLevel, userLevel) ||
                other.userLevel == userLevel) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.senderUid, senderUid) ||
                other.senderUid == senderUid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, userLevel, account, senderUid);

  @override
  String toString() {
    return 'UserInvitation(email: $email, userLevel: $userLevel, account: $account, senderUid: $senderUid)';
  }
}

/// @nodoc
abstract mixin class $UserInvitationCopyWith<$Res> {
  factory $UserInvitationCopyWith(
          UserInvitation value, $Res Function(UserInvitation) _then) =
      _$UserInvitationCopyWithImpl;
  @useResult
  $Res call(
      {String email, UserLevel userLevel, String account, String senderUid});
}

/// @nodoc
class _$UserInvitationCopyWithImpl<$Res>
    implements $UserInvitationCopyWith<$Res> {
  _$UserInvitationCopyWithImpl(this._self, this._then);

  final UserInvitation _self;
  final $Res Function(UserInvitation) _then;

  /// Create a copy of UserInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? userLevel = null,
    Object? account = null,
    Object? senderUid = null,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userLevel: null == userLevel
          ? _self.userLevel
          : userLevel // ignore: cast_nullable_to_non_nullable
              as UserLevel,
      account: null == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      senderUid: null == senderUid
          ? _self.senderUid
          : senderUid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserInvitation].
extension UserInvitationPatterns on UserInvitation {
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
    TResult Function(_UserInvitation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserInvitation() when $default != null:
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
    TResult Function(_UserInvitation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserInvitation():
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
    TResult? Function(_UserInvitation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserInvitation() when $default != null:
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
    TResult Function(String email, UserLevel userLevel, String account,
            String senderUid)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserInvitation() when $default != null:
        return $default(
            _that.email, _that.userLevel, _that.account, _that.senderUid);
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
            String email, UserLevel userLevel, String account, String senderUid)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserInvitation():
        return $default(
            _that.email, _that.userLevel, _that.account, _that.senderUid);
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
    TResult? Function(String email, UserLevel userLevel, String account,
            String senderUid)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserInvitation() when $default != null:
        return $default(
            _that.email, _that.userLevel, _that.account, _that.senderUid);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserInvitation implements UserInvitation {
  const _UserInvitation(
      {required this.email,
      required this.userLevel,
      required this.account,
      required this.senderUid});
  factory _UserInvitation.fromJson(Map<String, dynamic> json) =>
      _$UserInvitationFromJson(json);

  @override
  final String email;
  @override
  final UserLevel userLevel;
  @override
  final String account;
  @override
  final String senderUid;

  /// Create a copy of UserInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserInvitationCopyWith<_UserInvitation> get copyWith =>
      __$UserInvitationCopyWithImpl<_UserInvitation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserInvitationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserInvitation &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userLevel, userLevel) ||
                other.userLevel == userLevel) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.senderUid, senderUid) ||
                other.senderUid == senderUid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, userLevel, account, senderUid);

  @override
  String toString() {
    return 'UserInvitation(email: $email, userLevel: $userLevel, account: $account, senderUid: $senderUid)';
  }
}

/// @nodoc
abstract mixin class _$UserInvitationCopyWith<$Res>
    implements $UserInvitationCopyWith<$Res> {
  factory _$UserInvitationCopyWith(
          _UserInvitation value, $Res Function(_UserInvitation) _then) =
      __$UserInvitationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String email, UserLevel userLevel, String account, String senderUid});
}

/// @nodoc
class __$UserInvitationCopyWithImpl<$Res>
    implements _$UserInvitationCopyWith<$Res> {
  __$UserInvitationCopyWithImpl(this._self, this._then);

  final _UserInvitation _self;
  final $Res Function(_UserInvitation) _then;

  /// Create a copy of UserInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? userLevel = null,
    Object? account = null,
    Object? senderUid = null,
  }) {
    return _then(_UserInvitation(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userLevel: null == userLevel
          ? _self.userLevel
          : userLevel // ignore: cast_nullable_to_non_nullable
              as UserLevel,
      account: null == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      senderUid: null == senderUid
          ? _self.senderUid
          : senderUid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
