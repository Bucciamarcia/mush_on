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
mixin _$DogsWithWarnings {
  List<Dog> get warning;
  List<Dog> get fatal;

  /// Create a copy of DogsWithWarnings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogsWithWarningsCopyWith<DogsWithWarnings> get copyWith =>
      _$DogsWithWarningsCopyWithImpl<DogsWithWarnings>(
          this as DogsWithWarnings, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogsWithWarnings &&
            const DeepCollectionEquality().equals(other.warning, warning) &&
            const DeepCollectionEquality().equals(other.fatal, fatal));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(warning),
      const DeepCollectionEquality().hash(fatal));

  @override
  String toString() {
    return 'DogsWithWarnings(warning: $warning, fatal: $fatal)';
  }
}

/// @nodoc
abstract mixin class $DogsWithWarningsCopyWith<$Res> {
  factory $DogsWithWarningsCopyWith(
          DogsWithWarnings value, $Res Function(DogsWithWarnings) _then) =
      _$DogsWithWarningsCopyWithImpl;
  @useResult
  $Res call({List<Dog> warning, List<Dog> fatal});
}

/// @nodoc
class _$DogsWithWarningsCopyWithImpl<$Res>
    implements $DogsWithWarningsCopyWith<$Res> {
  _$DogsWithWarningsCopyWithImpl(this._self, this._then);

  final DogsWithWarnings _self;
  final $Res Function(DogsWithWarnings) _then;

  /// Create a copy of DogsWithWarnings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warning = null,
    Object? fatal = null,
  }) {
    return _then(_self.copyWith(
      warning: null == warning
          ? _self.warning
          : warning // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
      fatal: null == fatal
          ? _self.fatal
          : fatal // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
    ));
  }
}

/// @nodoc

class _DogsWithWarnings implements DogsWithWarnings {
  const _DogsWithWarnings(
      {final List<Dog> warning = const [], final List<Dog> fatal = const []})
      : _warning = warning,
        _fatal = fatal;

  final List<Dog> _warning;
  @override
  @JsonKey()
  List<Dog> get warning {
    if (_warning is EqualUnmodifiableListView) return _warning;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warning);
  }

  final List<Dog> _fatal;
  @override
  @JsonKey()
  List<Dog> get fatal {
    if (_fatal is EqualUnmodifiableListView) return _fatal;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fatal);
  }

  /// Create a copy of DogsWithWarnings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogsWithWarningsCopyWith<_DogsWithWarnings> get copyWith =>
      __$DogsWithWarningsCopyWithImpl<_DogsWithWarnings>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogsWithWarnings &&
            const DeepCollectionEquality().equals(other._warning, _warning) &&
            const DeepCollectionEquality().equals(other._fatal, _fatal));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_warning),
      const DeepCollectionEquality().hash(_fatal));

  @override
  String toString() {
    return 'DogsWithWarnings(warning: $warning, fatal: $fatal)';
  }
}

/// @nodoc
abstract mixin class _$DogsWithWarningsCopyWith<$Res>
    implements $DogsWithWarningsCopyWith<$Res> {
  factory _$DogsWithWarningsCopyWith(
          _DogsWithWarnings value, $Res Function(_DogsWithWarnings) _then) =
      __$DogsWithWarningsCopyWithImpl;
  @override
  @useResult
  $Res call({List<Dog> warning, List<Dog> fatal});
}

/// @nodoc
class __$DogsWithWarningsCopyWithImpl<$Res>
    implements _$DogsWithWarningsCopyWith<$Res> {
  __$DogsWithWarningsCopyWithImpl(this._self, this._then);

  final _DogsWithWarnings _self;
  final $Res Function(_DogsWithWarnings) _then;

  /// Create a copy of DogsWithWarnings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? warning = null,
    Object? fatal = null,
  }) {
    return _then(_DogsWithWarnings(
      warning: null == warning
          ? _self._warning
          : warning // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
      fatal: null == fatal
          ? _self._fatal
          : fatal // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
    ));
  }
}

// dart format on
