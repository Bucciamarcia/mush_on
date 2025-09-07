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
mixin _$AddDogData {
  Dog get dog;
  File? get file;

  /// Create a copy of AddDogData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddDogDataCopyWith<AddDogData> get copyWith =>
      _$AddDogDataCopyWithImpl<AddDogData>(this as AddDogData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddDogData &&
            (identical(other.dog, dog) || other.dog == dog) &&
            (identical(other.file, file) || other.file == file));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dog, file);

  @override
  String toString() {
    return 'AddDogData(dog: $dog, file: $file)';
  }
}

/// @nodoc
abstract mixin class $AddDogDataCopyWith<$Res> {
  factory $AddDogDataCopyWith(
          AddDogData value, $Res Function(AddDogData) _then) =
      _$AddDogDataCopyWithImpl;
  @useResult
  $Res call({Dog dog, File? file});

  $DogCopyWith<$Res> get dog;
}

/// @nodoc
class _$AddDogDataCopyWithImpl<$Res> implements $AddDogDataCopyWith<$Res> {
  _$AddDogDataCopyWithImpl(this._self, this._then);

  final AddDogData _self;
  final $Res Function(AddDogData) _then;

  /// Create a copy of AddDogData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dog = null,
    Object? file = freezed,
  }) {
    return _then(_self.copyWith(
      dog: null == dog
          ? _self.dog
          : dog // ignore: cast_nullable_to_non_nullable
              as Dog,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }

  /// Create a copy of AddDogData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DogCopyWith<$Res> get dog {
    return $DogCopyWith<$Res>(_self.dog, (value) {
      return _then(_self.copyWith(dog: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AddDogData].
extension AddDogDataPatterns on AddDogData {
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
    TResult Function(_AddDogData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddDogData() when $default != null:
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
    TResult Function(_AddDogData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddDogData():
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
    TResult? Function(_AddDogData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddDogData() when $default != null:
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
    TResult Function(Dog dog, File? file)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddDogData() when $default != null:
        return $default(_that.dog, _that.file);
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
    TResult Function(Dog dog, File? file) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddDogData():
        return $default(_that.dog, _that.file);
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
    TResult? Function(Dog dog, File? file)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddDogData() when $default != null:
        return $default(_that.dog, _that.file);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AddDogData implements AddDogData {
  _AddDogData({this.dog = const Dog(), this.file});

  @override
  @JsonKey()
  final Dog dog;
  @override
  final File? file;

  /// Create a copy of AddDogData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddDogDataCopyWith<_AddDogData> get copyWith =>
      __$AddDogDataCopyWithImpl<_AddDogData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddDogData &&
            (identical(other.dog, dog) || other.dog == dog) &&
            (identical(other.file, file) || other.file == file));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dog, file);

  @override
  String toString() {
    return 'AddDogData(dog: $dog, file: $file)';
  }
}

/// @nodoc
abstract mixin class _$AddDogDataCopyWith<$Res>
    implements $AddDogDataCopyWith<$Res> {
  factory _$AddDogDataCopyWith(
          _AddDogData value, $Res Function(_AddDogData) _then) =
      __$AddDogDataCopyWithImpl;
  @override
  @useResult
  $Res call({Dog dog, File? file});

  @override
  $DogCopyWith<$Res> get dog;
}

/// @nodoc
class __$AddDogDataCopyWithImpl<$Res> implements _$AddDogDataCopyWith<$Res> {
  __$AddDogDataCopyWithImpl(this._self, this._then);

  final _AddDogData _self;
  final $Res Function(_AddDogData) _then;

  /// Create a copy of AddDogData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dog = null,
    Object? file = freezed,
  }) {
    return _then(_AddDogData(
      dog: null == dog
          ? _self.dog
          : dog // ignore: cast_nullable_to_non_nullable
              as Dog,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }

  /// Create a copy of AddDogData
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
