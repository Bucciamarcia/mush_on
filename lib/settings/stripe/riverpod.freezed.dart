// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riverpod.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerCustomField implements DiagnosticableTreeMixin {

 String get id; CustomerCustomFieldType get type; String get name; String get description; bool get isRequired;
/// Create a copy of CustomerCustomField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCustomFieldCopyWith<CustomerCustomField> get copyWith => _$CustomerCustomFieldCopyWithImpl<CustomerCustomField>(this as CustomerCustomField, _$identity);

  /// Serializes this CustomerCustomField to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CustomerCustomField'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('isRequired', isRequired));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerCustomField&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,isRequired);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CustomerCustomField(id: $id, type: $type, name: $name, description: $description, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class $CustomerCustomFieldCopyWith<$Res>  {
  factory $CustomerCustomFieldCopyWith(CustomerCustomField value, $Res Function(CustomerCustomField) _then) = _$CustomerCustomFieldCopyWithImpl;
@useResult
$Res call({
 String id, CustomerCustomFieldType type, String name, String description, bool isRequired
});




}
/// @nodoc
class _$CustomerCustomFieldCopyWithImpl<$Res>
    implements $CustomerCustomFieldCopyWith<$Res> {
  _$CustomerCustomFieldCopyWithImpl(this._self, this._then);

  final CustomerCustomField _self;
  final $Res Function(CustomerCustomField) _then;

/// Create a copy of CustomerCustomField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? isRequired = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CustomerCustomFieldType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerCustomField].
extension CustomerCustomFieldPatterns on CustomerCustomField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerCustomField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerCustomField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerCustomField value)  $default,){
final _that = this;
switch (_that) {
case _CustomerCustomField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerCustomField value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerCustomField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CustomerCustomFieldType type,  String name,  String description,  bool isRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerCustomField() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.isRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CustomerCustomFieldType type,  String name,  String description,  bool isRequired)  $default,) {final _that = this;
switch (_that) {
case _CustomerCustomField():
return $default(_that.id,_that.type,_that.name,_that.description,_that.isRequired);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CustomerCustomFieldType type,  String name,  String description,  bool isRequired)?  $default,) {final _that = this;
switch (_that) {
case _CustomerCustomField() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.isRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerCustomField with DiagnosticableTreeMixin implements CustomerCustomField {
  const _CustomerCustomField({required this.id, required this.type, required this.name, required this.description, required this.isRequired});
  factory _CustomerCustomField.fromJson(Map<String, dynamic> json) => _$CustomerCustomFieldFromJson(json);

@override final  String id;
@override final  CustomerCustomFieldType type;
@override final  String name;
@override final  String description;
@override final  bool isRequired;

/// Create a copy of CustomerCustomField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCustomFieldCopyWith<_CustomerCustomField> get copyWith => __$CustomerCustomFieldCopyWithImpl<_CustomerCustomField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerCustomFieldToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CustomerCustomField'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('isRequired', isRequired));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerCustomField&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,isRequired);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CustomerCustomField(id: $id, type: $type, name: $name, description: $description, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class _$CustomerCustomFieldCopyWith<$Res> implements $CustomerCustomFieldCopyWith<$Res> {
  factory _$CustomerCustomFieldCopyWith(_CustomerCustomField value, $Res Function(_CustomerCustomField) _then) = __$CustomerCustomFieldCopyWithImpl;
@override @useResult
$Res call({
 String id, CustomerCustomFieldType type, String name, String description, bool isRequired
});




}
/// @nodoc
class __$CustomerCustomFieldCopyWithImpl<$Res>
    implements _$CustomerCustomFieldCopyWith<$Res> {
  __$CustomerCustomFieldCopyWithImpl(this._self, this._then);

  final _CustomerCustomField _self;
  final $Res Function(_CustomerCustomField) _then;

/// Create a copy of CustomerCustomField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? isRequired = null,}) {
  return _then(_CustomerCustomField(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CustomerCustomFieldType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BookingCustomField implements DiagnosticableTreeMixin {

 String get id; CustomerCustomFieldType get type; String get name; String get description; bool get isRequired;
/// Create a copy of BookingCustomField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCustomFieldCopyWith<BookingCustomField> get copyWith => _$BookingCustomFieldCopyWithImpl<BookingCustomField>(this as BookingCustomField, _$identity);

  /// Serializes this BookingCustomField to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingCustomField'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('isRequired', isRequired));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingCustomField&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,isRequired);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingCustomField(id: $id, type: $type, name: $name, description: $description, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class $BookingCustomFieldCopyWith<$Res>  {
  factory $BookingCustomFieldCopyWith(BookingCustomField value, $Res Function(BookingCustomField) _then) = _$BookingCustomFieldCopyWithImpl;
@useResult
$Res call({
 String id, CustomerCustomFieldType type, String name, String description, bool isRequired
});




}
/// @nodoc
class _$BookingCustomFieldCopyWithImpl<$Res>
    implements $BookingCustomFieldCopyWith<$Res> {
  _$BookingCustomFieldCopyWithImpl(this._self, this._then);

  final BookingCustomField _self;
  final $Res Function(BookingCustomField) _then;

/// Create a copy of BookingCustomField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? isRequired = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CustomerCustomFieldType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingCustomField].
extension BookingCustomFieldPatterns on BookingCustomField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingCustomField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingCustomField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingCustomField value)  $default,){
final _that = this;
switch (_that) {
case _BookingCustomField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingCustomField value)?  $default,){
final _that = this;
switch (_that) {
case _BookingCustomField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CustomerCustomFieldType type,  String name,  String description,  bool isRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingCustomField() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.isRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CustomerCustomFieldType type,  String name,  String description,  bool isRequired)  $default,) {final _that = this;
switch (_that) {
case _BookingCustomField():
return $default(_that.id,_that.type,_that.name,_that.description,_that.isRequired);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CustomerCustomFieldType type,  String name,  String description,  bool isRequired)?  $default,) {final _that = this;
switch (_that) {
case _BookingCustomField() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.isRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingCustomField with DiagnosticableTreeMixin implements BookingCustomField {
  const _BookingCustomField({required this.id, required this.type, required this.name, required this.description, required this.isRequired});
  factory _BookingCustomField.fromJson(Map<String, dynamic> json) => _$BookingCustomFieldFromJson(json);

@override final  String id;
@override final  CustomerCustomFieldType type;
@override final  String name;
@override final  String description;
@override final  bool isRequired;

/// Create a copy of BookingCustomField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCustomFieldCopyWith<_BookingCustomField> get copyWith => __$BookingCustomFieldCopyWithImpl<_BookingCustomField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingCustomFieldToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingCustomField'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('isRequired', isRequired));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingCustomField&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,isRequired);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingCustomField(id: $id, type: $type, name: $name, description: $description, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class _$BookingCustomFieldCopyWith<$Res> implements $BookingCustomFieldCopyWith<$Res> {
  factory _$BookingCustomFieldCopyWith(_BookingCustomField value, $Res Function(_BookingCustomField) _then) = __$BookingCustomFieldCopyWithImpl;
@override @useResult
$Res call({
 String id, CustomerCustomFieldType type, String name, String description, bool isRequired
});




}
/// @nodoc
class __$BookingCustomFieldCopyWithImpl<$Res>
    implements _$BookingCustomFieldCopyWith<$Res> {
  __$BookingCustomFieldCopyWithImpl(this._self, this._then);

  final _BookingCustomField _self;
  final $Res Function(_BookingCustomField) _then;

/// Create a copy of BookingCustomField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? isRequired = null,}) {
  return _then(_BookingCustomField(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CustomerCustomFieldType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
