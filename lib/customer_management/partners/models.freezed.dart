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
mixin _$Partner {

/// ALSO stored as a field in the doc (never rely on doc.id alone).
 String get id;/// Internal display name.
 String get name;/// The value used in `&partner=<code>`.
 String get code;/// ALWAYS the recipient of payment emails.
 String? get email;/// Fraction 0..1 (e.g. 0.1 == 10% off). null == no discount.
 double? get discountRate;/// May this partner defer payment?
 bool get allowDeferred;/// Balance due this many days BEFORE the tour date.
 int get deferredDays;/// Whether bookings from this partner should be invoiced automatically.
 bool get invoiceEnabled;/// Legal billing identity used as the invoice recipient.
 String get invoiceLegalName; String get invoiceAddress; String get invoiceBusinessId;/// Never delete partners — archive for stats/recovery.
 bool get archived;
/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerCopyWith<Partner> get copyWith => _$PartnerCopyWithImpl<Partner>(this as Partner, _$identity);

  /// Serializes this Partner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Partner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.email, email) || other.email == email)&&(identical(other.discountRate, discountRate) || other.discountRate == discountRate)&&(identical(other.allowDeferred, allowDeferred) || other.allowDeferred == allowDeferred)&&(identical(other.deferredDays, deferredDays) || other.deferredDays == deferredDays)&&(identical(other.invoiceEnabled, invoiceEnabled) || other.invoiceEnabled == invoiceEnabled)&&(identical(other.invoiceLegalName, invoiceLegalName) || other.invoiceLegalName == invoiceLegalName)&&(identical(other.invoiceAddress, invoiceAddress) || other.invoiceAddress == invoiceAddress)&&(identical(other.invoiceBusinessId, invoiceBusinessId) || other.invoiceBusinessId == invoiceBusinessId)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,email,discountRate,allowDeferred,deferredDays,invoiceEnabled,invoiceLegalName,invoiceAddress,invoiceBusinessId,archived);

@override
String toString() {
  return 'Partner(id: $id, name: $name, code: $code, email: $email, discountRate: $discountRate, allowDeferred: $allowDeferred, deferredDays: $deferredDays, invoiceEnabled: $invoiceEnabled, invoiceLegalName: $invoiceLegalName, invoiceAddress: $invoiceAddress, invoiceBusinessId: $invoiceBusinessId, archived: $archived)';
}


}

/// @nodoc
abstract mixin class $PartnerCopyWith<$Res>  {
  factory $PartnerCopyWith(Partner value, $Res Function(Partner) _then) = _$PartnerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String code, String? email, double? discountRate, bool allowDeferred, int deferredDays, bool invoiceEnabled, String invoiceLegalName, String invoiceAddress, String invoiceBusinessId, bool archived
});




}
/// @nodoc
class _$PartnerCopyWithImpl<$Res>
    implements $PartnerCopyWith<$Res> {
  _$PartnerCopyWithImpl(this._self, this._then);

  final Partner _self;
  final $Res Function(Partner) _then;

/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = null,Object? email = freezed,Object? discountRate = freezed,Object? allowDeferred = null,Object? deferredDays = null,Object? invoiceEnabled = null,Object? invoiceLegalName = null,Object? invoiceAddress = null,Object? invoiceBusinessId = null,Object? archived = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,discountRate: freezed == discountRate ? _self.discountRate : discountRate // ignore: cast_nullable_to_non_nullable
as double?,allowDeferred: null == allowDeferred ? _self.allowDeferred : allowDeferred // ignore: cast_nullable_to_non_nullable
as bool,deferredDays: null == deferredDays ? _self.deferredDays : deferredDays // ignore: cast_nullable_to_non_nullable
as int,invoiceEnabled: null == invoiceEnabled ? _self.invoiceEnabled : invoiceEnabled // ignore: cast_nullable_to_non_nullable
as bool,invoiceLegalName: null == invoiceLegalName ? _self.invoiceLegalName : invoiceLegalName // ignore: cast_nullable_to_non_nullable
as String,invoiceAddress: null == invoiceAddress ? _self.invoiceAddress : invoiceAddress // ignore: cast_nullable_to_non_nullable
as String,invoiceBusinessId: null == invoiceBusinessId ? _self.invoiceBusinessId : invoiceBusinessId // ignore: cast_nullable_to_non_nullable
as String,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Partner].
extension PartnerPatterns on Partner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Partner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Partner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Partner value)  $default,){
final _that = this;
switch (_that) {
case _Partner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Partner value)?  $default,){
final _that = this;
switch (_that) {
case _Partner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String code,  String? email,  double? discountRate,  bool allowDeferred,  int deferredDays,  bool invoiceEnabled,  String invoiceLegalName,  String invoiceAddress,  String invoiceBusinessId,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Partner() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.email,_that.discountRate,_that.allowDeferred,_that.deferredDays,_that.invoiceEnabled,_that.invoiceLegalName,_that.invoiceAddress,_that.invoiceBusinessId,_that.archived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String code,  String? email,  double? discountRate,  bool allowDeferred,  int deferredDays,  bool invoiceEnabled,  String invoiceLegalName,  String invoiceAddress,  String invoiceBusinessId,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _Partner():
return $default(_that.id,_that.name,_that.code,_that.email,_that.discountRate,_that.allowDeferred,_that.deferredDays,_that.invoiceEnabled,_that.invoiceLegalName,_that.invoiceAddress,_that.invoiceBusinessId,_that.archived);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String code,  String? email,  double? discountRate,  bool allowDeferred,  int deferredDays,  bool invoiceEnabled,  String invoiceLegalName,  String invoiceAddress,  String invoiceBusinessId,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _Partner() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.email,_that.discountRate,_that.allowDeferred,_that.deferredDays,_that.invoiceEnabled,_that.invoiceLegalName,_that.invoiceAddress,_that.invoiceBusinessId,_that.archived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Partner implements Partner {
  const _Partner({required this.id, this.name = "", this.code = "", this.email, this.discountRate, this.allowDeferred = false, this.deferredDays = 0, this.invoiceEnabled = false, this.invoiceLegalName = "", this.invoiceAddress = "", this.invoiceBusinessId = "", this.archived = false});
  factory _Partner.fromJson(Map<String, dynamic> json) => _$PartnerFromJson(json);

/// ALSO stored as a field in the doc (never rely on doc.id alone).
@override final  String id;
/// Internal display name.
@override@JsonKey() final  String name;
/// The value used in `&partner=<code>`.
@override@JsonKey() final  String code;
/// ALWAYS the recipient of payment emails.
@override final  String? email;
/// Fraction 0..1 (e.g. 0.1 == 10% off). null == no discount.
@override final  double? discountRate;
/// May this partner defer payment?
@override@JsonKey() final  bool allowDeferred;
/// Balance due this many days BEFORE the tour date.
@override@JsonKey() final  int deferredDays;
/// Whether bookings from this partner should be invoiced automatically.
@override@JsonKey() final  bool invoiceEnabled;
/// Legal billing identity used as the invoice recipient.
@override@JsonKey() final  String invoiceLegalName;
@override@JsonKey() final  String invoiceAddress;
@override@JsonKey() final  String invoiceBusinessId;
/// Never delete partners — archive for stats/recovery.
@override@JsonKey() final  bool archived;

/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerCopyWith<_Partner> get copyWith => __$PartnerCopyWithImpl<_Partner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartnerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Partner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.email, email) || other.email == email)&&(identical(other.discountRate, discountRate) || other.discountRate == discountRate)&&(identical(other.allowDeferred, allowDeferred) || other.allowDeferred == allowDeferred)&&(identical(other.deferredDays, deferredDays) || other.deferredDays == deferredDays)&&(identical(other.invoiceEnabled, invoiceEnabled) || other.invoiceEnabled == invoiceEnabled)&&(identical(other.invoiceLegalName, invoiceLegalName) || other.invoiceLegalName == invoiceLegalName)&&(identical(other.invoiceAddress, invoiceAddress) || other.invoiceAddress == invoiceAddress)&&(identical(other.invoiceBusinessId, invoiceBusinessId) || other.invoiceBusinessId == invoiceBusinessId)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,email,discountRate,allowDeferred,deferredDays,invoiceEnabled,invoiceLegalName,invoiceAddress,invoiceBusinessId,archived);

@override
String toString() {
  return 'Partner(id: $id, name: $name, code: $code, email: $email, discountRate: $discountRate, allowDeferred: $allowDeferred, deferredDays: $deferredDays, invoiceEnabled: $invoiceEnabled, invoiceLegalName: $invoiceLegalName, invoiceAddress: $invoiceAddress, invoiceBusinessId: $invoiceBusinessId, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$PartnerCopyWith<$Res> implements $PartnerCopyWith<$Res> {
  factory _$PartnerCopyWith(_Partner value, $Res Function(_Partner) _then) = __$PartnerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String code, String? email, double? discountRate, bool allowDeferred, int deferredDays, bool invoiceEnabled, String invoiceLegalName, String invoiceAddress, String invoiceBusinessId, bool archived
});




}
/// @nodoc
class __$PartnerCopyWithImpl<$Res>
    implements _$PartnerCopyWith<$Res> {
  __$PartnerCopyWithImpl(this._self, this._then);

  final _Partner _self;
  final $Res Function(_Partner) _then;

/// Create a copy of Partner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = null,Object? email = freezed,Object? discountRate = freezed,Object? allowDeferred = null,Object? deferredDays = null,Object? invoiceEnabled = null,Object? invoiceLegalName = null,Object? invoiceAddress = null,Object? invoiceBusinessId = null,Object? archived = null,}) {
  return _then(_Partner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,discountRate: freezed == discountRate ? _self.discountRate : discountRate // ignore: cast_nullable_to_non_nullable
as double?,allowDeferred: null == allowDeferred ? _self.allowDeferred : allowDeferred // ignore: cast_nullable_to_non_nullable
as bool,deferredDays: null == deferredDays ? _self.deferredDays : deferredDays // ignore: cast_nullable_to_non_nullable
as int,invoiceEnabled: null == invoiceEnabled ? _self.invoiceEnabled : invoiceEnabled // ignore: cast_nullable_to_non_nullable
as bool,invoiceLegalName: null == invoiceLegalName ? _self.invoiceLegalName : invoiceLegalName // ignore: cast_nullable_to_non_nullable
as String,invoiceAddress: null == invoiceAddress ? _self.invoiceAddress : invoiceAddress // ignore: cast_nullable_to_non_nullable
as String,invoiceBusinessId: null == invoiceBusinessId ? _self.invoiceBusinessId : invoiceBusinessId // ignore: cast_nullable_to_non_nullable
as String,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
