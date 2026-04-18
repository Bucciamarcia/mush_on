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
mixin _$ImportDogResult {

 List<String> get dogs; bool get isSuccessful;
/// Create a copy of ImportDogResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportDogResultCopyWith<ImportDogResult> get copyWith => _$ImportDogResultCopyWithImpl<ImportDogResult>(this as ImportDogResult, _$identity);

  /// Serializes this ImportDogResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportDogResult&&const DeepCollectionEquality().equals(other.dogs, dogs)&&(identical(other.isSuccessful, isSuccessful) || other.isSuccessful == isSuccessful));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dogs),isSuccessful);

@override
String toString() {
  return 'ImportDogResult(dogs: $dogs, isSuccessful: $isSuccessful)';
}


}

/// @nodoc
abstract mixin class $ImportDogResultCopyWith<$Res>  {
  factory $ImportDogResultCopyWith(ImportDogResult value, $Res Function(ImportDogResult) _then) = _$ImportDogResultCopyWithImpl;
@useResult
$Res call({
 List<String> dogs, bool isSuccessful
});




}
/// @nodoc
class _$ImportDogResultCopyWithImpl<$Res>
    implements $ImportDogResultCopyWith<$Res> {
  _$ImportDogResultCopyWithImpl(this._self, this._then);

  final ImportDogResult _self;
  final $Res Function(ImportDogResult) _then;

/// Create a copy of ImportDogResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dogs = null,Object? isSuccessful = null,}) {
  return _then(_self.copyWith(
dogs: null == dogs ? _self.dogs : dogs // ignore: cast_nullable_to_non_nullable
as List<String>,isSuccessful: null == isSuccessful ? _self.isSuccessful : isSuccessful // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportDogResult].
extension ImportDogResultPatterns on ImportDogResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportDogResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportDogResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportDogResult value)  $default,){
final _that = this;
switch (_that) {
case _ImportDogResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportDogResult value)?  $default,){
final _that = this;
switch (_that) {
case _ImportDogResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> dogs,  bool isSuccessful)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportDogResult() when $default != null:
return $default(_that.dogs,_that.isSuccessful);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> dogs,  bool isSuccessful)  $default,) {final _that = this;
switch (_that) {
case _ImportDogResult():
return $default(_that.dogs,_that.isSuccessful);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> dogs,  bool isSuccessful)?  $default,) {final _that = this;
switch (_that) {
case _ImportDogResult() when $default != null:
return $default(_that.dogs,_that.isSuccessful);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportDogResult extends ImportDogResult {
  const _ImportDogResult({required final  List<String> dogs, required this.isSuccessful}): _dogs = dogs,super._();
  factory _ImportDogResult.fromJson(Map<String, dynamic> json) => _$ImportDogResultFromJson(json);

 final  List<String> _dogs;
@override List<String> get dogs {
  if (_dogs is EqualUnmodifiableListView) return _dogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dogs);
}

@override final  bool isSuccessful;

/// Create a copy of ImportDogResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportDogResultCopyWith<_ImportDogResult> get copyWith => __$ImportDogResultCopyWithImpl<_ImportDogResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportDogResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportDogResult&&const DeepCollectionEquality().equals(other._dogs, _dogs)&&(identical(other.isSuccessful, isSuccessful) || other.isSuccessful == isSuccessful));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dogs),isSuccessful);

@override
String toString() {
  return 'ImportDogResult(dogs: $dogs, isSuccessful: $isSuccessful)';
}


}

/// @nodoc
abstract mixin class _$ImportDogResultCopyWith<$Res> implements $ImportDogResultCopyWith<$Res> {
  factory _$ImportDogResultCopyWith(_ImportDogResult value, $Res Function(_ImportDogResult) _then) = __$ImportDogResultCopyWithImpl;
@override @useResult
$Res call({
 List<String> dogs, bool isSuccessful
});




}
/// @nodoc
class __$ImportDogResultCopyWithImpl<$Res>
    implements _$ImportDogResultCopyWith<$Res> {
  __$ImportDogResultCopyWithImpl(this._self, this._then);

  final _ImportDogResult _self;
  final $Res Function(_ImportDogResult) _then;

/// Create a copy of ImportDogResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dogs = null,Object? isSuccessful = null,}) {
  return _then(_ImportDogResult(
dogs: null == dogs ? _self._dogs : dogs // ignore: cast_nullable_to_non_nullable
as List<String>,isSuccessful: null == isSuccessful ? _self.isSuccessful : isSuccessful // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
