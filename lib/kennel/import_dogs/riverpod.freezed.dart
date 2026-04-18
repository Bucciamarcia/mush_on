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
mixin _$DogToImport {

 Dog get dog; bool get import; bool get isNameDuplicate;
/// Create a copy of DogToImport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DogToImportCopyWith<DogToImport> get copyWith => _$DogToImportCopyWithImpl<DogToImport>(this as DogToImport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DogToImport&&(identical(other.dog, dog) || other.dog == dog)&&(identical(other.import, import) || other.import == import)&&(identical(other.isNameDuplicate, isNameDuplicate) || other.isNameDuplicate == isNameDuplicate));
}


@override
int get hashCode => Object.hash(runtimeType,dog,import,isNameDuplicate);

@override
String toString() {
  return 'DogToImport(dog: $dog, import: $import, isNameDuplicate: $isNameDuplicate)';
}


}

/// @nodoc
abstract mixin class $DogToImportCopyWith<$Res>  {
  factory $DogToImportCopyWith(DogToImport value, $Res Function(DogToImport) _then) = _$DogToImportCopyWithImpl;
@useResult
$Res call({
 Dog dog, bool import, bool isNameDuplicate
});


$DogCopyWith<$Res> get dog;

}
/// @nodoc
class _$DogToImportCopyWithImpl<$Res>
    implements $DogToImportCopyWith<$Res> {
  _$DogToImportCopyWithImpl(this._self, this._then);

  final DogToImport _self;
  final $Res Function(DogToImport) _then;

/// Create a copy of DogToImport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dog = null,Object? import = null,Object? isNameDuplicate = null,}) {
  return _then(_self.copyWith(
dog: null == dog ? _self.dog : dog // ignore: cast_nullable_to_non_nullable
as Dog,import: null == import ? _self.import : import // ignore: cast_nullable_to_non_nullable
as bool,isNameDuplicate: null == isNameDuplicate ? _self.isNameDuplicate : isNameDuplicate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DogToImport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DogCopyWith<$Res> get dog {
  
  return $DogCopyWith<$Res>(_self.dog, (value) {
    return _then(_self.copyWith(dog: value));
  });
}
}


/// Adds pattern-matching-related methods to [DogToImport].
extension DogToImportPatterns on DogToImport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DogToImport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DogToImport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DogToImport value)  $default,){
final _that = this;
switch (_that) {
case _DogToImport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DogToImport value)?  $default,){
final _that = this;
switch (_that) {
case _DogToImport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Dog dog,  bool import,  bool isNameDuplicate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DogToImport() when $default != null:
return $default(_that.dog,_that.import,_that.isNameDuplicate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Dog dog,  bool import,  bool isNameDuplicate)  $default,) {final _that = this;
switch (_that) {
case _DogToImport():
return $default(_that.dog,_that.import,_that.isNameDuplicate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Dog dog,  bool import,  bool isNameDuplicate)?  $default,) {final _that = this;
switch (_that) {
case _DogToImport() when $default != null:
return $default(_that.dog,_that.import,_that.isNameDuplicate);case _:
  return null;

}
}

}

/// @nodoc


class _DogToImport implements DogToImport {
  const _DogToImport({required this.dog, required this.import, required this.isNameDuplicate});
  

@override final  Dog dog;
@override final  bool import;
@override final  bool isNameDuplicate;

/// Create a copy of DogToImport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DogToImportCopyWith<_DogToImport> get copyWith => __$DogToImportCopyWithImpl<_DogToImport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DogToImport&&(identical(other.dog, dog) || other.dog == dog)&&(identical(other.import, import) || other.import == import)&&(identical(other.isNameDuplicate, isNameDuplicate) || other.isNameDuplicate == isNameDuplicate));
}


@override
int get hashCode => Object.hash(runtimeType,dog,import,isNameDuplicate);

@override
String toString() {
  return 'DogToImport(dog: $dog, import: $import, isNameDuplicate: $isNameDuplicate)';
}


}

/// @nodoc
abstract mixin class _$DogToImportCopyWith<$Res> implements $DogToImportCopyWith<$Res> {
  factory _$DogToImportCopyWith(_DogToImport value, $Res Function(_DogToImport) _then) = __$DogToImportCopyWithImpl;
@override @useResult
$Res call({
 Dog dog, bool import, bool isNameDuplicate
});


@override $DogCopyWith<$Res> get dog;

}
/// @nodoc
class __$DogToImportCopyWithImpl<$Res>
    implements _$DogToImportCopyWith<$Res> {
  __$DogToImportCopyWithImpl(this._self, this._then);

  final _DogToImport _self;
  final $Res Function(_DogToImport) _then;

/// Create a copy of DogToImport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dog = null,Object? import = null,Object? isNameDuplicate = null,}) {
  return _then(_DogToImport(
dog: null == dog ? _self.dog : dog // ignore: cast_nullable_to_non_nullable
as Dog,import: null == import ? _self.import : import // ignore: cast_nullable_to_non_nullable
as bool,isNameDuplicate: null == isNameDuplicate ? _self.isNameDuplicate : isNameDuplicate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DogToImport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DogCopyWith<$Res> get dog {
  
  return $DogCopyWith<$Res>(_self.dog, (value) {
    return _then(_self.copyWith(dog: value));
  });
}
}

// dart format on
