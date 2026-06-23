// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripeAccount {

 String get accountId; StripeMode get mode; bool get archived;@TimestampConverter() DateTime? get connectedAt;@TimestampConverter() DateTime? get archivedAt;
/// Create a copy of StripeAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StripeAccountCopyWith<StripeAccount> get copyWith => _$StripeAccountCopyWithImpl<StripeAccount>(this as StripeAccount, _$identity);

  /// Serializes this StripeAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StripeAccount&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,mode,archived,connectedAt,archivedAt);

@override
String toString() {
  return 'StripeAccount(accountId: $accountId, mode: $mode, archived: $archived, connectedAt: $connectedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $StripeAccountCopyWith<$Res>  {
  factory $StripeAccountCopyWith(StripeAccount value, $Res Function(StripeAccount) _then) = _$StripeAccountCopyWithImpl;
@useResult
$Res call({
 String accountId, StripeMode mode, bool archived,@TimestampConverter() DateTime? connectedAt,@TimestampConverter() DateTime? archivedAt
});




}
/// @nodoc
class _$StripeAccountCopyWithImpl<$Res>
    implements $StripeAccountCopyWith<$Res> {
  _$StripeAccountCopyWithImpl(this._self, this._then);

  final StripeAccount _self;
  final $Res Function(StripeAccount) _then;

/// Create a copy of StripeAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? mode = null,Object? archived = null,Object? connectedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StripeMode,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StripeAccount].
extension StripeAccountPatterns on StripeAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StripeAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StripeAccount() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StripeAccount value)  $default,){
final _that = this;
switch (_that) {
case _StripeAccount():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StripeAccount value)?  $default,){
final _that = this;
switch (_that) {
case _StripeAccount() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  StripeMode mode,  bool archived, @TimestampConverter()  DateTime? connectedAt, @TimestampConverter()  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StripeAccount() when $default != null:
return $default(_that.accountId,_that.mode,_that.archived,_that.connectedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  StripeMode mode,  bool archived, @TimestampConverter()  DateTime? connectedAt, @TimestampConverter()  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _StripeAccount():
return $default(_that.accountId,_that.mode,_that.archived,_that.connectedAt,_that.archivedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  StripeMode mode,  bool archived, @TimestampConverter()  DateTime? connectedAt, @TimestampConverter()  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _StripeAccount() when $default != null:
return $default(_that.accountId,_that.mode,_that.archived,_that.connectedAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StripeAccount implements StripeAccount {
  const _StripeAccount({required this.accountId, required this.mode, this.archived = false, @TimestampConverter() this.connectedAt, @TimestampConverter() this.archivedAt});
  factory _StripeAccount.fromJson(Map<String, dynamic> json) => _$StripeAccountFromJson(json);

@override final  String accountId;
@override final  StripeMode mode;
@override@JsonKey() final  bool archived;
@override@TimestampConverter() final  DateTime? connectedAt;
@override@TimestampConverter() final  DateTime? archivedAt;

/// Create a copy of StripeAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StripeAccountCopyWith<_StripeAccount> get copyWith => __$StripeAccountCopyWithImpl<_StripeAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StripeAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StripeAccount&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,mode,archived,connectedAt,archivedAt);

@override
String toString() {
  return 'StripeAccount(accountId: $accountId, mode: $mode, archived: $archived, connectedAt: $connectedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$StripeAccountCopyWith<$Res> implements $StripeAccountCopyWith<$Res> {
  factory _$StripeAccountCopyWith(_StripeAccount value, $Res Function(_StripeAccount) _then) = __$StripeAccountCopyWithImpl;
@override @useResult
$Res call({
 String accountId, StripeMode mode, bool archived,@TimestampConverter() DateTime? connectedAt,@TimestampConverter() DateTime? archivedAt
});




}
/// @nodoc
class __$StripeAccountCopyWithImpl<$Res>
    implements _$StripeAccountCopyWith<$Res> {
  __$StripeAccountCopyWithImpl(this._self, this._then);

  final _StripeAccount _self;
  final $Res Function(_StripeAccount) _then;

/// Create a copy of StripeAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? mode = null,Object? archived = null,Object? connectedAt = freezed,Object? archivedAt = freezed,}) {
  return _then(_StripeAccount(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StripeMode,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StripeConnection {

 StripeModeConnection? get live; StripeModeConnection? get test;/// The currently selected payment mode.
 StripeMode get activeMode;
/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StripeConnectionCopyWith<StripeConnection> get copyWith => _$StripeConnectionCopyWithImpl<StripeConnection>(this as StripeConnection, _$identity);

  /// Serializes this StripeConnection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StripeConnection&&(identical(other.live, live) || other.live == live)&&(identical(other.test, test) || other.test == test)&&(identical(other.activeMode, activeMode) || other.activeMode == activeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,live,test,activeMode);

@override
String toString() {
  return 'StripeConnection(live: $live, test: $test, activeMode: $activeMode)';
}


}

/// @nodoc
abstract mixin class $StripeConnectionCopyWith<$Res>  {
  factory $StripeConnectionCopyWith(StripeConnection value, $Res Function(StripeConnection) _then) = _$StripeConnectionCopyWithImpl;
@useResult
$Res call({
 StripeModeConnection? live, StripeModeConnection? test, StripeMode activeMode
});


$StripeModeConnectionCopyWith<$Res>? get live;$StripeModeConnectionCopyWith<$Res>? get test;

}
/// @nodoc
class _$StripeConnectionCopyWithImpl<$Res>
    implements $StripeConnectionCopyWith<$Res> {
  _$StripeConnectionCopyWithImpl(this._self, this._then);

  final StripeConnection _self;
  final $Res Function(StripeConnection) _then;

/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? live = freezed,Object? test = freezed,Object? activeMode = null,}) {
  return _then(_self.copyWith(
live: freezed == live ? _self.live : live // ignore: cast_nullable_to_non_nullable
as StripeModeConnection?,test: freezed == test ? _self.test : test // ignore: cast_nullable_to_non_nullable
as StripeModeConnection?,activeMode: null == activeMode ? _self.activeMode : activeMode // ignore: cast_nullable_to_non_nullable
as StripeMode,
  ));
}
/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StripeModeConnectionCopyWith<$Res>? get live {
    if (_self.live == null) {
    return null;
  }

  return $StripeModeConnectionCopyWith<$Res>(_self.live!, (value) {
    return _then(_self.copyWith(live: value));
  });
}/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StripeModeConnectionCopyWith<$Res>? get test {
    if (_self.test == null) {
    return null;
  }

  return $StripeModeConnectionCopyWith<$Res>(_self.test!, (value) {
    return _then(_self.copyWith(test: value));
  });
}
}


/// Adds pattern-matching-related methods to [StripeConnection].
extension StripeConnectionPatterns on StripeConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StripeConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StripeConnection() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StripeConnection value)  $default,){
final _that = this;
switch (_that) {
case _StripeConnection():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StripeConnection value)?  $default,){
final _that = this;
switch (_that) {
case _StripeConnection() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StripeModeConnection? live,  StripeModeConnection? test,  StripeMode activeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StripeConnection() when $default != null:
return $default(_that.live,_that.test,_that.activeMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StripeModeConnection? live,  StripeModeConnection? test,  StripeMode activeMode)  $default,) {final _that = this;
switch (_that) {
case _StripeConnection():
return $default(_that.live,_that.test,_that.activeMode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StripeModeConnection? live,  StripeModeConnection? test,  StripeMode activeMode)?  $default,) {final _that = this;
switch (_that) {
case _StripeConnection() when $default != null:
return $default(_that.live,_that.test,_that.activeMode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StripeConnection implements StripeConnection {
  const _StripeConnection({this.live, this.test, this.activeMode = StripeMode.test});
  factory _StripeConnection.fromJson(Map<String, dynamic> json) => _$StripeConnectionFromJson(json);

@override final  StripeModeConnection? live;
@override final  StripeModeConnection? test;
/// The currently selected payment mode.
@override@JsonKey() final  StripeMode activeMode;

/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StripeConnectionCopyWith<_StripeConnection> get copyWith => __$StripeConnectionCopyWithImpl<_StripeConnection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StripeConnectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StripeConnection&&(identical(other.live, live) || other.live == live)&&(identical(other.test, test) || other.test == test)&&(identical(other.activeMode, activeMode) || other.activeMode == activeMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,live,test,activeMode);

@override
String toString() {
  return 'StripeConnection(live: $live, test: $test, activeMode: $activeMode)';
}


}

/// @nodoc
abstract mixin class _$StripeConnectionCopyWith<$Res> implements $StripeConnectionCopyWith<$Res> {
  factory _$StripeConnectionCopyWith(_StripeConnection value, $Res Function(_StripeConnection) _then) = __$StripeConnectionCopyWithImpl;
@override @useResult
$Res call({
 StripeModeConnection? live, StripeModeConnection? test, StripeMode activeMode
});


@override $StripeModeConnectionCopyWith<$Res>? get live;@override $StripeModeConnectionCopyWith<$Res>? get test;

}
/// @nodoc
class __$StripeConnectionCopyWithImpl<$Res>
    implements _$StripeConnectionCopyWith<$Res> {
  __$StripeConnectionCopyWithImpl(this._self, this._then);

  final _StripeConnection _self;
  final $Res Function(_StripeConnection) _then;

/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? live = freezed,Object? test = freezed,Object? activeMode = null,}) {
  return _then(_StripeConnection(
live: freezed == live ? _self.live : live // ignore: cast_nullable_to_non_nullable
as StripeModeConnection?,test: freezed == test ? _self.test : test // ignore: cast_nullable_to_non_nullable
as StripeModeConnection?,activeMode: null == activeMode ? _self.activeMode : activeMode // ignore: cast_nullable_to_non_nullable
as StripeMode,
  ));
}

/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StripeModeConnectionCopyWith<$Res>? get live {
    if (_self.live == null) {
    return null;
  }

  return $StripeModeConnectionCopyWith<$Res>(_self.live!, (value) {
    return _then(_self.copyWith(live: value));
  });
}/// Create a copy of StripeConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StripeModeConnectionCopyWith<$Res>? get test {
    if (_self.test == null) {
    return null;
  }

  return $StripeModeConnectionCopyWith<$Res>(_self.test!, (value) {
    return _then(_self.copyWith(test: value));
  });
}
}


/// @nodoc
mixin _$StripeModeConnection {

 String get accountId; bool get isActive;@TimestampConverter() DateTime? get connectedAt;
/// Create a copy of StripeModeConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StripeModeConnectionCopyWith<StripeModeConnection> get copyWith => _$StripeModeConnectionCopyWithImpl<StripeModeConnection>(this as StripeModeConnection, _$identity);

  /// Serializes this StripeModeConnection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StripeModeConnection&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,isActive,connectedAt);

@override
String toString() {
  return 'StripeModeConnection(accountId: $accountId, isActive: $isActive, connectedAt: $connectedAt)';
}


}

/// @nodoc
abstract mixin class $StripeModeConnectionCopyWith<$Res>  {
  factory $StripeModeConnectionCopyWith(StripeModeConnection value, $Res Function(StripeModeConnection) _then) = _$StripeModeConnectionCopyWithImpl;
@useResult
$Res call({
 String accountId, bool isActive,@TimestampConverter() DateTime? connectedAt
});




}
/// @nodoc
class _$StripeModeConnectionCopyWithImpl<$Res>
    implements $StripeModeConnectionCopyWith<$Res> {
  _$StripeModeConnectionCopyWithImpl(this._self, this._then);

  final StripeModeConnection _self;
  final $Res Function(StripeModeConnection) _then;

/// Create a copy of StripeModeConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? isActive = null,Object? connectedAt = freezed,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StripeModeConnection].
extension StripeModeConnectionPatterns on StripeModeConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StripeModeConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StripeModeConnection() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StripeModeConnection value)  $default,){
final _that = this;
switch (_that) {
case _StripeModeConnection():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StripeModeConnection value)?  $default,){
final _that = this;
switch (_that) {
case _StripeModeConnection() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  bool isActive, @TimestampConverter()  DateTime? connectedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StripeModeConnection() when $default != null:
return $default(_that.accountId,_that.isActive,_that.connectedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  bool isActive, @TimestampConverter()  DateTime? connectedAt)  $default,) {final _that = this;
switch (_that) {
case _StripeModeConnection():
return $default(_that.accountId,_that.isActive,_that.connectedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  bool isActive, @TimestampConverter()  DateTime? connectedAt)?  $default,) {final _that = this;
switch (_that) {
case _StripeModeConnection() when $default != null:
return $default(_that.accountId,_that.isActive,_that.connectedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StripeModeConnection implements StripeModeConnection {
  const _StripeModeConnection({required this.accountId, this.isActive = false, @TimestampConverter() this.connectedAt});
  factory _StripeModeConnection.fromJson(Map<String, dynamic> json) => _$StripeModeConnectionFromJson(json);

@override final  String accountId;
@override@JsonKey() final  bool isActive;
@override@TimestampConverter() final  DateTime? connectedAt;

/// Create a copy of StripeModeConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StripeModeConnectionCopyWith<_StripeModeConnection> get copyWith => __$StripeModeConnectionCopyWithImpl<_StripeModeConnection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StripeModeConnectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StripeModeConnection&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.connectedAt, connectedAt) || other.connectedAt == connectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,isActive,connectedAt);

@override
String toString() {
  return 'StripeModeConnection(accountId: $accountId, isActive: $isActive, connectedAt: $connectedAt)';
}


}

/// @nodoc
abstract mixin class _$StripeModeConnectionCopyWith<$Res> implements $StripeModeConnectionCopyWith<$Res> {
  factory _$StripeModeConnectionCopyWith(_StripeModeConnection value, $Res Function(_StripeModeConnection) _then) = __$StripeModeConnectionCopyWithImpl;
@override @useResult
$Res call({
 String accountId, bool isActive,@TimestampConverter() DateTime? connectedAt
});




}
/// @nodoc
class __$StripeModeConnectionCopyWithImpl<$Res>
    implements _$StripeModeConnectionCopyWith<$Res> {
  __$StripeModeConnectionCopyWithImpl(this._self, this._then);

  final _StripeModeConnection _self;
  final $Res Function(_StripeModeConnection) _then;

/// Create a copy of StripeModeConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? isActive = null,Object? connectedAt = freezed,}) {
  return _then(_StripeModeConnection(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,connectedAt: freezed == connectedAt ? _self.connectedAt : connectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CheckoutSession {

 String get checkoutSessionId; StripeMode get stripeMode;/// The name of the account that this payment goes to.
 String get account;/// The ID of the booking
 String get bookingId;/// The Stripe ID of the account.
 String get stripeId;@NonNullableTimestampConverter() DateTime get createdAt; bool get webhookProcessed;
/// Create a copy of CheckoutSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSessionCopyWith<CheckoutSession> get copyWith => _$CheckoutSessionCopyWithImpl<CheckoutSession>(this as CheckoutSession, _$identity);

  /// Serializes this CheckoutSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSession&&(identical(other.checkoutSessionId, checkoutSessionId) || other.checkoutSessionId == checkoutSessionId)&&(identical(other.stripeMode, stripeMode) || other.stripeMode == stripeMode)&&(identical(other.account, account) || other.account == account)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.stripeId, stripeId) || other.stripeId == stripeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.webhookProcessed, webhookProcessed) || other.webhookProcessed == webhookProcessed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkoutSessionId,stripeMode,account,bookingId,stripeId,createdAt,webhookProcessed);

@override
String toString() {
  return 'CheckoutSession(checkoutSessionId: $checkoutSessionId, stripeMode: $stripeMode, account: $account, bookingId: $bookingId, stripeId: $stripeId, createdAt: $createdAt, webhookProcessed: $webhookProcessed)';
}


}

/// @nodoc
abstract mixin class $CheckoutSessionCopyWith<$Res>  {
  factory $CheckoutSessionCopyWith(CheckoutSession value, $Res Function(CheckoutSession) _then) = _$CheckoutSessionCopyWithImpl;
@useResult
$Res call({
 String checkoutSessionId, StripeMode stripeMode, String account, String bookingId, String stripeId,@NonNullableTimestampConverter() DateTime createdAt, bool webhookProcessed
});




}
/// @nodoc
class _$CheckoutSessionCopyWithImpl<$Res>
    implements $CheckoutSessionCopyWith<$Res> {
  _$CheckoutSessionCopyWithImpl(this._self, this._then);

  final CheckoutSession _self;
  final $Res Function(CheckoutSession) _then;

/// Create a copy of CheckoutSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkoutSessionId = null,Object? stripeMode = null,Object? account = null,Object? bookingId = null,Object? stripeId = null,Object? createdAt = null,Object? webhookProcessed = null,}) {
  return _then(_self.copyWith(
checkoutSessionId: null == checkoutSessionId ? _self.checkoutSessionId : checkoutSessionId // ignore: cast_nullable_to_non_nullable
as String,stripeMode: null == stripeMode ? _self.stripeMode : stripeMode // ignore: cast_nullable_to_non_nullable
as StripeMode,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,stripeId: null == stripeId ? _self.stripeId : stripeId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,webhookProcessed: null == webhookProcessed ? _self.webhookProcessed : webhookProcessed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutSession].
extension CheckoutSessionPatterns on CheckoutSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutSession() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutSession value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutSession():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutSession value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutSession() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String checkoutSessionId,  StripeMode stripeMode,  String account,  String bookingId,  String stripeId, @NonNullableTimestampConverter()  DateTime createdAt,  bool webhookProcessed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutSession() when $default != null:
return $default(_that.checkoutSessionId,_that.stripeMode,_that.account,_that.bookingId,_that.stripeId,_that.createdAt,_that.webhookProcessed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String checkoutSessionId,  StripeMode stripeMode,  String account,  String bookingId,  String stripeId, @NonNullableTimestampConverter()  DateTime createdAt,  bool webhookProcessed)  $default,) {final _that = this;
switch (_that) {
case _CheckoutSession():
return $default(_that.checkoutSessionId,_that.stripeMode,_that.account,_that.bookingId,_that.stripeId,_that.createdAt,_that.webhookProcessed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String checkoutSessionId,  StripeMode stripeMode,  String account,  String bookingId,  String stripeId, @NonNullableTimestampConverter()  DateTime createdAt,  bool webhookProcessed)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutSession() when $default != null:
return $default(_that.checkoutSessionId,_that.stripeMode,_that.account,_that.bookingId,_that.stripeId,_that.createdAt,_that.webhookProcessed);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CheckoutSession implements CheckoutSession {
  const _CheckoutSession({required this.checkoutSessionId, this.stripeMode = StripeMode.test, required this.account, required this.bookingId, required this.stripeId, @NonNullableTimestampConverter() required this.createdAt, required this.webhookProcessed});
  factory _CheckoutSession.fromJson(Map<String, dynamic> json) => _$CheckoutSessionFromJson(json);

@override final  String checkoutSessionId;
@override@JsonKey() final  StripeMode stripeMode;
/// The name of the account that this payment goes to.
@override final  String account;
/// The ID of the booking
@override final  String bookingId;
/// The Stripe ID of the account.
@override final  String stripeId;
@override@NonNullableTimestampConverter() final  DateTime createdAt;
@override final  bool webhookProcessed;

/// Create a copy of CheckoutSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutSessionCopyWith<_CheckoutSession> get copyWith => __$CheckoutSessionCopyWithImpl<_CheckoutSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckoutSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutSession&&(identical(other.checkoutSessionId, checkoutSessionId) || other.checkoutSessionId == checkoutSessionId)&&(identical(other.stripeMode, stripeMode) || other.stripeMode == stripeMode)&&(identical(other.account, account) || other.account == account)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.stripeId, stripeId) || other.stripeId == stripeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.webhookProcessed, webhookProcessed) || other.webhookProcessed == webhookProcessed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkoutSessionId,stripeMode,account,bookingId,stripeId,createdAt,webhookProcessed);

@override
String toString() {
  return 'CheckoutSession(checkoutSessionId: $checkoutSessionId, stripeMode: $stripeMode, account: $account, bookingId: $bookingId, stripeId: $stripeId, createdAt: $createdAt, webhookProcessed: $webhookProcessed)';
}


}

/// @nodoc
abstract mixin class _$CheckoutSessionCopyWith<$Res> implements $CheckoutSessionCopyWith<$Res> {
  factory _$CheckoutSessionCopyWith(_CheckoutSession value, $Res Function(_CheckoutSession) _then) = __$CheckoutSessionCopyWithImpl;
@override @useResult
$Res call({
 String checkoutSessionId, StripeMode stripeMode, String account, String bookingId, String stripeId,@NonNullableTimestampConverter() DateTime createdAt, bool webhookProcessed
});




}
/// @nodoc
class __$CheckoutSessionCopyWithImpl<$Res>
    implements _$CheckoutSessionCopyWith<$Res> {
  __$CheckoutSessionCopyWithImpl(this._self, this._then);

  final _CheckoutSession _self;
  final $Res Function(_CheckoutSession) _then;

/// Create a copy of CheckoutSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkoutSessionId = null,Object? stripeMode = null,Object? account = null,Object? bookingId = null,Object? stripeId = null,Object? createdAt = null,Object? webhookProcessed = null,}) {
  return _then(_CheckoutSession(
checkoutSessionId: null == checkoutSessionId ? _self.checkoutSessionId : checkoutSessionId // ignore: cast_nullable_to_non_nullable
as String,stripeMode: null == stripeMode ? _self.stripeMode : stripeMode // ignore: cast_nullable_to_non_nullable
as StripeMode,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,stripeId: null == stripeId ? _self.stripeId : stripeId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,webhookProcessed: null == webhookProcessed ? _self.webhookProcessed : webhookProcessed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StripeConnectionStatus {

 StripeMode get activeMode; bool get hasAccount; bool get isReady; bool get chargesEnabled; bool get payoutsEnabled; bool get detailsSubmitted; String? get disabledReason; String get reason;
/// Create a copy of StripeConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StripeConnectionStatusCopyWith<StripeConnectionStatus> get copyWith => _$StripeConnectionStatusCopyWithImpl<StripeConnectionStatus>(this as StripeConnectionStatus, _$identity);

  /// Serializes this StripeConnectionStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StripeConnectionStatus&&(identical(other.activeMode, activeMode) || other.activeMode == activeMode)&&(identical(other.hasAccount, hasAccount) || other.hasAccount == hasAccount)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.chargesEnabled, chargesEnabled) || other.chargesEnabled == chargesEnabled)&&(identical(other.payoutsEnabled, payoutsEnabled) || other.payoutsEnabled == payoutsEnabled)&&(identical(other.detailsSubmitted, detailsSubmitted) || other.detailsSubmitted == detailsSubmitted)&&(identical(other.disabledReason, disabledReason) || other.disabledReason == disabledReason)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeMode,hasAccount,isReady,chargesEnabled,payoutsEnabled,detailsSubmitted,disabledReason,reason);

@override
String toString() {
  return 'StripeConnectionStatus(activeMode: $activeMode, hasAccount: $hasAccount, isReady: $isReady, chargesEnabled: $chargesEnabled, payoutsEnabled: $payoutsEnabled, detailsSubmitted: $detailsSubmitted, disabledReason: $disabledReason, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $StripeConnectionStatusCopyWith<$Res>  {
  factory $StripeConnectionStatusCopyWith(StripeConnectionStatus value, $Res Function(StripeConnectionStatus) _then) = _$StripeConnectionStatusCopyWithImpl;
@useResult
$Res call({
 StripeMode activeMode, bool hasAccount, bool isReady, bool chargesEnabled, bool payoutsEnabled, bool detailsSubmitted, String? disabledReason, String reason
});




}
/// @nodoc
class _$StripeConnectionStatusCopyWithImpl<$Res>
    implements $StripeConnectionStatusCopyWith<$Res> {
  _$StripeConnectionStatusCopyWithImpl(this._self, this._then);

  final StripeConnectionStatus _self;
  final $Res Function(StripeConnectionStatus) _then;

/// Create a copy of StripeConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeMode = null,Object? hasAccount = null,Object? isReady = null,Object? chargesEnabled = null,Object? payoutsEnabled = null,Object? detailsSubmitted = null,Object? disabledReason = freezed,Object? reason = null,}) {
  return _then(_self.copyWith(
activeMode: null == activeMode ? _self.activeMode : activeMode // ignore: cast_nullable_to_non_nullable
as StripeMode,hasAccount: null == hasAccount ? _self.hasAccount : hasAccount // ignore: cast_nullable_to_non_nullable
as bool,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,chargesEnabled: null == chargesEnabled ? _self.chargesEnabled : chargesEnabled // ignore: cast_nullable_to_non_nullable
as bool,payoutsEnabled: null == payoutsEnabled ? _self.payoutsEnabled : payoutsEnabled // ignore: cast_nullable_to_non_nullable
as bool,detailsSubmitted: null == detailsSubmitted ? _self.detailsSubmitted : detailsSubmitted // ignore: cast_nullable_to_non_nullable
as bool,disabledReason: freezed == disabledReason ? _self.disabledReason : disabledReason // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StripeConnectionStatus].
extension StripeConnectionStatusPatterns on StripeConnectionStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StripeConnectionStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StripeConnectionStatus() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StripeConnectionStatus value)  $default,){
final _that = this;
switch (_that) {
case _StripeConnectionStatus():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StripeConnectionStatus value)?  $default,){
final _that = this;
switch (_that) {
case _StripeConnectionStatus() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StripeMode activeMode,  bool hasAccount,  bool isReady,  bool chargesEnabled,  bool payoutsEnabled,  bool detailsSubmitted,  String? disabledReason,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StripeConnectionStatus() when $default != null:
return $default(_that.activeMode,_that.hasAccount,_that.isReady,_that.chargesEnabled,_that.payoutsEnabled,_that.detailsSubmitted,_that.disabledReason,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StripeMode activeMode,  bool hasAccount,  bool isReady,  bool chargesEnabled,  bool payoutsEnabled,  bool detailsSubmitted,  String? disabledReason,  String reason)  $default,) {final _that = this;
switch (_that) {
case _StripeConnectionStatus():
return $default(_that.activeMode,_that.hasAccount,_that.isReady,_that.chargesEnabled,_that.payoutsEnabled,_that.detailsSubmitted,_that.disabledReason,_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StripeMode activeMode,  bool hasAccount,  bool isReady,  bool chargesEnabled,  bool payoutsEnabled,  bool detailsSubmitted,  String? disabledReason,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _StripeConnectionStatus() when $default != null:
return $default(_that.activeMode,_that.hasAccount,_that.isReady,_that.chargesEnabled,_that.payoutsEnabled,_that.detailsSubmitted,_that.disabledReason,_that.reason);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StripeConnectionStatus implements StripeConnectionStatus {
  const _StripeConnectionStatus({required this.activeMode, required this.hasAccount, required this.isReady, required this.chargesEnabled, required this.payoutsEnabled, required this.detailsSubmitted, required this.disabledReason, required this.reason});
  factory _StripeConnectionStatus.fromJson(Map<String, dynamic> json) => _$StripeConnectionStatusFromJson(json);

@override final  StripeMode activeMode;
@override final  bool hasAccount;
@override final  bool isReady;
@override final  bool chargesEnabled;
@override final  bool payoutsEnabled;
@override final  bool detailsSubmitted;
@override final  String? disabledReason;
@override final  String reason;

/// Create a copy of StripeConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StripeConnectionStatusCopyWith<_StripeConnectionStatus> get copyWith => __$StripeConnectionStatusCopyWithImpl<_StripeConnectionStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StripeConnectionStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StripeConnectionStatus&&(identical(other.activeMode, activeMode) || other.activeMode == activeMode)&&(identical(other.hasAccount, hasAccount) || other.hasAccount == hasAccount)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.chargesEnabled, chargesEnabled) || other.chargesEnabled == chargesEnabled)&&(identical(other.payoutsEnabled, payoutsEnabled) || other.payoutsEnabled == payoutsEnabled)&&(identical(other.detailsSubmitted, detailsSubmitted) || other.detailsSubmitted == detailsSubmitted)&&(identical(other.disabledReason, disabledReason) || other.disabledReason == disabledReason)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeMode,hasAccount,isReady,chargesEnabled,payoutsEnabled,detailsSubmitted,disabledReason,reason);

@override
String toString() {
  return 'StripeConnectionStatus(activeMode: $activeMode, hasAccount: $hasAccount, isReady: $isReady, chargesEnabled: $chargesEnabled, payoutsEnabled: $payoutsEnabled, detailsSubmitted: $detailsSubmitted, disabledReason: $disabledReason, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$StripeConnectionStatusCopyWith<$Res> implements $StripeConnectionStatusCopyWith<$Res> {
  factory _$StripeConnectionStatusCopyWith(_StripeConnectionStatus value, $Res Function(_StripeConnectionStatus) _then) = __$StripeConnectionStatusCopyWithImpl;
@override @useResult
$Res call({
 StripeMode activeMode, bool hasAccount, bool isReady, bool chargesEnabled, bool payoutsEnabled, bool detailsSubmitted, String? disabledReason, String reason
});




}
/// @nodoc
class __$StripeConnectionStatusCopyWithImpl<$Res>
    implements _$StripeConnectionStatusCopyWith<$Res> {
  __$StripeConnectionStatusCopyWithImpl(this._self, this._then);

  final _StripeConnectionStatus _self;
  final $Res Function(_StripeConnectionStatus) _then;

/// Create a copy of StripeConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeMode = null,Object? hasAccount = null,Object? isReady = null,Object? chargesEnabled = null,Object? payoutsEnabled = null,Object? detailsSubmitted = null,Object? disabledReason = freezed,Object? reason = null,}) {
  return _then(_StripeConnectionStatus(
activeMode: null == activeMode ? _self.activeMode : activeMode // ignore: cast_nullable_to_non_nullable
as StripeMode,hasAccount: null == hasAccount ? _self.hasAccount : hasAccount // ignore: cast_nullable_to_non_nullable
as bool,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,chargesEnabled: null == chargesEnabled ? _self.chargesEnabled : chargesEnabled // ignore: cast_nullable_to_non_nullable
as bool,payoutsEnabled: null == payoutsEnabled ? _self.payoutsEnabled : payoutsEnabled // ignore: cast_nullable_to_non_nullable
as bool,detailsSubmitted: null == detailsSubmitted ? _self.detailsSubmitted : detailsSubmitted // ignore: cast_nullable_to_non_nullable
as bool,disabledReason: freezed == disabledReason ? _self.disabledReason : disabledReason // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BookingManagerKennelInfo {

 String get name; String get url; String get email; String get cancellationPolicy; List<CustomerCustomField> get customerCustomFields; List<BookingCustomField> get bookingCustomFields;/// The reminders the customer will receive before the trip.
 List<BookingReminder> get bookingReminders;/// IANA timezone identifier for this kennel's location, used to display
/// booking times correctly in emails (e.g. "Europe/Helsinki").
 String get timezone;/// The vat rate to apply to the platform commission. 0 (reverse charged) unless in Finland, then 0.255.
 double get vatRate;/// The commission rate of the platform on payments. Defaults to 3.5%.
 double get commissionRate;
/// Create a copy of BookingManagerKennelInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingManagerKennelInfoCopyWith<BookingManagerKennelInfo> get copyWith => _$BookingManagerKennelInfoCopyWithImpl<BookingManagerKennelInfo>(this as BookingManagerKennelInfo, _$identity);

  /// Serializes this BookingManagerKennelInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingManagerKennelInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.email, email) || other.email == email)&&(identical(other.cancellationPolicy, cancellationPolicy) || other.cancellationPolicy == cancellationPolicy)&&const DeepCollectionEquality().equals(other.customerCustomFields, customerCustomFields)&&const DeepCollectionEquality().equals(other.bookingCustomFields, bookingCustomFields)&&const DeepCollectionEquality().equals(other.bookingReminders, bookingReminders)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.vatRate, vatRate) || other.vatRate == vatRate)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,email,cancellationPolicy,const DeepCollectionEquality().hash(customerCustomFields),const DeepCollectionEquality().hash(bookingCustomFields),const DeepCollectionEquality().hash(bookingReminders),timezone,vatRate,commissionRate);

@override
String toString() {
  return 'BookingManagerKennelInfo(name: $name, url: $url, email: $email, cancellationPolicy: $cancellationPolicy, customerCustomFields: $customerCustomFields, bookingCustomFields: $bookingCustomFields, bookingReminders: $bookingReminders, timezone: $timezone, vatRate: $vatRate, commissionRate: $commissionRate)';
}


}

/// @nodoc
abstract mixin class $BookingManagerKennelInfoCopyWith<$Res>  {
  factory $BookingManagerKennelInfoCopyWith(BookingManagerKennelInfo value, $Res Function(BookingManagerKennelInfo) _then) = _$BookingManagerKennelInfoCopyWithImpl;
@useResult
$Res call({
 String name, String url, String email, String cancellationPolicy, List<CustomerCustomField> customerCustomFields, List<BookingCustomField> bookingCustomFields, List<BookingReminder> bookingReminders, String timezone, double vatRate, double commissionRate
});




}
/// @nodoc
class _$BookingManagerKennelInfoCopyWithImpl<$Res>
    implements $BookingManagerKennelInfoCopyWith<$Res> {
  _$BookingManagerKennelInfoCopyWithImpl(this._self, this._then);

  final BookingManagerKennelInfo _self;
  final $Res Function(BookingManagerKennelInfo) _then;

/// Create a copy of BookingManagerKennelInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,Object? email = null,Object? cancellationPolicy = null,Object? customerCustomFields = null,Object? bookingCustomFields = null,Object? bookingReminders = null,Object? timezone = null,Object? vatRate = null,Object? commissionRate = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,cancellationPolicy: null == cancellationPolicy ? _self.cancellationPolicy : cancellationPolicy // ignore: cast_nullable_to_non_nullable
as String,customerCustomFields: null == customerCustomFields ? _self.customerCustomFields : customerCustomFields // ignore: cast_nullable_to_non_nullable
as List<CustomerCustomField>,bookingCustomFields: null == bookingCustomFields ? _self.bookingCustomFields : bookingCustomFields // ignore: cast_nullable_to_non_nullable
as List<BookingCustomField>,bookingReminders: null == bookingReminders ? _self.bookingReminders : bookingReminders // ignore: cast_nullable_to_non_nullable
as List<BookingReminder>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,vatRate: null == vatRate ? _self.vatRate : vatRate // ignore: cast_nullable_to_non_nullable
as double,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingManagerKennelInfo].
extension BookingManagerKennelInfoPatterns on BookingManagerKennelInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingManagerKennelInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingManagerKennelInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingManagerKennelInfo value)  $default,){
final _that = this;
switch (_that) {
case _BookingManagerKennelInfo():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingManagerKennelInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BookingManagerKennelInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String url,  String email,  String cancellationPolicy,  List<CustomerCustomField> customerCustomFields,  List<BookingCustomField> bookingCustomFields,  List<BookingReminder> bookingReminders,  String timezone,  double vatRate,  double commissionRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingManagerKennelInfo() when $default != null:
return $default(_that.name,_that.url,_that.email,_that.cancellationPolicy,_that.customerCustomFields,_that.bookingCustomFields,_that.bookingReminders,_that.timezone,_that.vatRate,_that.commissionRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String url,  String email,  String cancellationPolicy,  List<CustomerCustomField> customerCustomFields,  List<BookingCustomField> bookingCustomFields,  List<BookingReminder> bookingReminders,  String timezone,  double vatRate,  double commissionRate)  $default,) {final _that = this;
switch (_that) {
case _BookingManagerKennelInfo():
return $default(_that.name,_that.url,_that.email,_that.cancellationPolicy,_that.customerCustomFields,_that.bookingCustomFields,_that.bookingReminders,_that.timezone,_that.vatRate,_that.commissionRate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String url,  String email,  String cancellationPolicy,  List<CustomerCustomField> customerCustomFields,  List<BookingCustomField> bookingCustomFields,  List<BookingReminder> bookingReminders,  String timezone,  double vatRate,  double commissionRate)?  $default,) {final _that = this;
switch (_that) {
case _BookingManagerKennelInfo() when $default != null:
return $default(_that.name,_that.url,_that.email,_that.cancellationPolicy,_that.customerCustomFields,_that.bookingCustomFields,_that.bookingReminders,_that.timezone,_that.vatRate,_that.commissionRate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BookingManagerKennelInfo implements BookingManagerKennelInfo {
  const _BookingManagerKennelInfo({required this.name, required this.url, required this.email, required this.cancellationPolicy, final  List<CustomerCustomField> customerCustomFields = const [], final  List<BookingCustomField> bookingCustomFields = const [], final  List<BookingReminder> bookingReminders = const [], this.timezone = "Europe/Helsinki", required this.vatRate, this.commissionRate = 0.035}): _customerCustomFields = customerCustomFields,_bookingCustomFields = bookingCustomFields,_bookingReminders = bookingReminders;
  factory _BookingManagerKennelInfo.fromJson(Map<String, dynamic> json) => _$BookingManagerKennelInfoFromJson(json);

@override final  String name;
@override final  String url;
@override final  String email;
@override final  String cancellationPolicy;
 final  List<CustomerCustomField> _customerCustomFields;
@override@JsonKey() List<CustomerCustomField> get customerCustomFields {
  if (_customerCustomFields is EqualUnmodifiableListView) return _customerCustomFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customerCustomFields);
}

 final  List<BookingCustomField> _bookingCustomFields;
@override@JsonKey() List<BookingCustomField> get bookingCustomFields {
  if (_bookingCustomFields is EqualUnmodifiableListView) return _bookingCustomFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookingCustomFields);
}

/// The reminders the customer will receive before the trip.
 final  List<BookingReminder> _bookingReminders;
/// The reminders the customer will receive before the trip.
@override@JsonKey() List<BookingReminder> get bookingReminders {
  if (_bookingReminders is EqualUnmodifiableListView) return _bookingReminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookingReminders);
}

/// IANA timezone identifier for this kennel's location, used to display
/// booking times correctly in emails (e.g. "Europe/Helsinki").
@override@JsonKey() final  String timezone;
/// The vat rate to apply to the platform commission. 0 (reverse charged) unless in Finland, then 0.255.
@override final  double vatRate;
/// The commission rate of the platform on payments. Defaults to 3.5%.
@override@JsonKey() final  double commissionRate;

/// Create a copy of BookingManagerKennelInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingManagerKennelInfoCopyWith<_BookingManagerKennelInfo> get copyWith => __$BookingManagerKennelInfoCopyWithImpl<_BookingManagerKennelInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingManagerKennelInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingManagerKennelInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.email, email) || other.email == email)&&(identical(other.cancellationPolicy, cancellationPolicy) || other.cancellationPolicy == cancellationPolicy)&&const DeepCollectionEquality().equals(other._customerCustomFields, _customerCustomFields)&&const DeepCollectionEquality().equals(other._bookingCustomFields, _bookingCustomFields)&&const DeepCollectionEquality().equals(other._bookingReminders, _bookingReminders)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.vatRate, vatRate) || other.vatRate == vatRate)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,email,cancellationPolicy,const DeepCollectionEquality().hash(_customerCustomFields),const DeepCollectionEquality().hash(_bookingCustomFields),const DeepCollectionEquality().hash(_bookingReminders),timezone,vatRate,commissionRate);

@override
String toString() {
  return 'BookingManagerKennelInfo(name: $name, url: $url, email: $email, cancellationPolicy: $cancellationPolicy, customerCustomFields: $customerCustomFields, bookingCustomFields: $bookingCustomFields, bookingReminders: $bookingReminders, timezone: $timezone, vatRate: $vatRate, commissionRate: $commissionRate)';
}


}

/// @nodoc
abstract mixin class _$BookingManagerKennelInfoCopyWith<$Res> implements $BookingManagerKennelInfoCopyWith<$Res> {
  factory _$BookingManagerKennelInfoCopyWith(_BookingManagerKennelInfo value, $Res Function(_BookingManagerKennelInfo) _then) = __$BookingManagerKennelInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String url, String email, String cancellationPolicy, List<CustomerCustomField> customerCustomFields, List<BookingCustomField> bookingCustomFields, List<BookingReminder> bookingReminders, String timezone, double vatRate, double commissionRate
});




}
/// @nodoc
class __$BookingManagerKennelInfoCopyWithImpl<$Res>
    implements _$BookingManagerKennelInfoCopyWith<$Res> {
  __$BookingManagerKennelInfoCopyWithImpl(this._self, this._then);

  final _BookingManagerKennelInfo _self;
  final $Res Function(_BookingManagerKennelInfo) _then;

/// Create a copy of BookingManagerKennelInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,Object? email = null,Object? cancellationPolicy = null,Object? customerCustomFields = null,Object? bookingCustomFields = null,Object? bookingReminders = null,Object? timezone = null,Object? vatRate = null,Object? commissionRate = null,}) {
  return _then(_BookingManagerKennelInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,cancellationPolicy: null == cancellationPolicy ? _self.cancellationPolicy : cancellationPolicy // ignore: cast_nullable_to_non_nullable
as String,customerCustomFields: null == customerCustomFields ? _self._customerCustomFields : customerCustomFields // ignore: cast_nullable_to_non_nullable
as List<CustomerCustomField>,bookingCustomFields: null == bookingCustomFields ? _self._bookingCustomFields : bookingCustomFields // ignore: cast_nullable_to_non_nullable
as List<BookingCustomField>,bookingReminders: null == bookingReminders ? _self._bookingReminders : bookingReminders // ignore: cast_nullable_to_non_nullable
as List<BookingReminder>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,vatRate: null == vatRate ? _self.vatRate : vatRate // ignore: cast_nullable_to_non_nullable
as double,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$BookingReminder {

/// UID of the reminder.
 String get uid;/// How many days before to send the reminder.
/// 0 is the day of the trip, 1 is 1 day before etc.
 int get daysBefore;
/// Create a copy of BookingReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingReminderCopyWith<BookingReminder> get copyWith => _$BookingReminderCopyWithImpl<BookingReminder>(this as BookingReminder, _$identity);

  /// Serializes this BookingReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingReminder&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.daysBefore, daysBefore) || other.daysBefore == daysBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,daysBefore);

@override
String toString() {
  return 'BookingReminder(uid: $uid, daysBefore: $daysBefore)';
}


}

/// @nodoc
abstract mixin class $BookingReminderCopyWith<$Res>  {
  factory $BookingReminderCopyWith(BookingReminder value, $Res Function(BookingReminder) _then) = _$BookingReminderCopyWithImpl;
@useResult
$Res call({
 String uid, int daysBefore
});




}
/// @nodoc
class _$BookingReminderCopyWithImpl<$Res>
    implements $BookingReminderCopyWith<$Res> {
  _$BookingReminderCopyWithImpl(this._self, this._then);

  final BookingReminder _self;
  final $Res Function(BookingReminder) _then;

/// Create a copy of BookingReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? daysBefore = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,daysBefore: null == daysBefore ? _self.daysBefore : daysBefore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingReminder].
extension BookingReminderPatterns on BookingReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingReminder() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingReminder value)  $default,){
final _that = this;
switch (_that) {
case _BookingReminder():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingReminder value)?  $default,){
final _that = this;
switch (_that) {
case _BookingReminder() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  int daysBefore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingReminder() when $default != null:
return $default(_that.uid,_that.daysBefore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  int daysBefore)  $default,) {final _that = this;
switch (_that) {
case _BookingReminder():
return $default(_that.uid,_that.daysBefore);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  int daysBefore)?  $default,) {final _that = this;
switch (_that) {
case _BookingReminder() when $default != null:
return $default(_that.uid,_that.daysBefore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingReminder implements BookingReminder {
  const _BookingReminder({required this.uid, required this.daysBefore});
  factory _BookingReminder.fromJson(Map<String, dynamic> json) => _$BookingReminderFromJson(json);

/// UID of the reminder.
@override final  String uid;
/// How many days before to send the reminder.
/// 0 is the day of the trip, 1 is 1 day before etc.
@override final  int daysBefore;

/// Create a copy of BookingReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingReminderCopyWith<_BookingReminder> get copyWith => __$BookingReminderCopyWithImpl<_BookingReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingReminderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingReminder&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.daysBefore, daysBefore) || other.daysBefore == daysBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,daysBefore);

@override
String toString() {
  return 'BookingReminder(uid: $uid, daysBefore: $daysBefore)';
}


}

/// @nodoc
abstract mixin class _$BookingReminderCopyWith<$Res> implements $BookingReminderCopyWith<$Res> {
  factory _$BookingReminderCopyWith(_BookingReminder value, $Res Function(_BookingReminder) _then) = __$BookingReminderCopyWithImpl;
@override @useResult
$Res call({
 String uid, int daysBefore
});




}
/// @nodoc
class __$BookingReminderCopyWithImpl<$Res>
    implements _$BookingReminderCopyWith<$Res> {
  __$BookingReminderCopyWithImpl(this._self, this._then);

  final _BookingReminder _self;
  final $Res Function(_BookingReminder) _then;

/// Create a copy of BookingReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? daysBefore = null,}) {
  return _then(_BookingReminder(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,daysBefore: null == daysBefore ? _self.daysBefore : daysBefore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
