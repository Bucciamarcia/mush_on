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
mixin _$ConditionsGroup {
  List<ConditionSelectionElement> get conditions;
  dynamic get conditionType;

  /// Create a copy of ConditionsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConditionsGroupCopyWith<ConditionsGroup> get copyWith =>
      _$ConditionsGroupCopyWithImpl<ConditionsGroup>(
          this as ConditionsGroup, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConditionsGroup &&
            const DeepCollectionEquality()
                .equals(other.conditions, conditions) &&
            const DeepCollectionEquality()
                .equals(other.conditionType, conditionType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(conditions),
      const DeepCollectionEquality().hash(conditionType));

  @override
  String toString() {
    return 'ConditionsGroup(conditions: $conditions, conditionType: $conditionType)';
  }
}

/// @nodoc
abstract mixin class $ConditionsGroupCopyWith<$Res> {
  factory $ConditionsGroupCopyWith(
          ConditionsGroup value, $Res Function(ConditionsGroup) _then) =
      _$ConditionsGroupCopyWithImpl;
  @useResult
  $Res call(
      {List<ConditionSelectionElement> conditions, dynamic conditionType});
}

/// @nodoc
class _$ConditionsGroupCopyWithImpl<$Res>
    implements $ConditionsGroupCopyWith<$Res> {
  _$ConditionsGroupCopyWithImpl(this._self, this._then);

  final ConditionsGroup _self;
  final $Res Function(ConditionsGroup) _then;

  /// Create a copy of ConditionsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conditions = null,
    Object? conditionType = freezed,
  }) {
    return _then(_self.copyWith(
      conditions: null == conditions
          ? _self.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<ConditionSelectionElement>,
      conditionType: freezed == conditionType
          ? _self.conditionType
          : conditionType // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConditionsGroup].
extension ConditionsGroupPatterns on ConditionsGroup {
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
    TResult Function(_ConditionsGroup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConditionsGroup() when $default != null:
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
    TResult Function(_ConditionsGroup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionsGroup():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_ConditionsGroup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionsGroup() when $default != null:
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
    TResult Function(
            List<ConditionSelectionElement> conditions, dynamic conditionType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConditionsGroup() when $default != null:
        return $default(_that.conditions, _that.conditionType);
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
            List<ConditionSelectionElement> conditions, dynamic conditionType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionsGroup():
        return $default(_that.conditions, _that.conditionType);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(
            List<ConditionSelectionElement> conditions, dynamic conditionType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionsGroup() when $default != null:
        return $default(_that.conditions, _that.conditionType);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConditionsGroup implements ConditionsGroup {
  const _ConditionsGroup(
      {final List<ConditionSelectionElement> conditions = const [],
      this.conditionType = ConditionType.and})
      : _conditions = conditions;

  final List<ConditionSelectionElement> _conditions;
  @override
  @JsonKey()
  List<ConditionSelectionElement> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  @override
  @JsonKey()
  final dynamic conditionType;

  /// Create a copy of ConditionsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConditionsGroupCopyWith<_ConditionsGroup> get copyWith =>
      __$ConditionsGroupCopyWithImpl<_ConditionsGroup>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConditionsGroup &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            const DeepCollectionEquality()
                .equals(other.conditionType, conditionType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_conditions),
      const DeepCollectionEquality().hash(conditionType));

  @override
  String toString() {
    return 'ConditionsGroup(conditions: $conditions, conditionType: $conditionType)';
  }
}

/// @nodoc
abstract mixin class _$ConditionsGroupCopyWith<$Res>
    implements $ConditionsGroupCopyWith<$Res> {
  factory _$ConditionsGroupCopyWith(
          _ConditionsGroup value, $Res Function(_ConditionsGroup) _then) =
      __$ConditionsGroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<ConditionSelectionElement> conditions, dynamic conditionType});
}

/// @nodoc
class __$ConditionsGroupCopyWithImpl<$Res>
    implements _$ConditionsGroupCopyWith<$Res> {
  __$ConditionsGroupCopyWithImpl(this._self, this._then);

  final _ConditionsGroup _self;
  final $Res Function(_ConditionsGroup) _then;

  /// Create a copy of ConditionsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? conditions = null,
    Object? conditionType = freezed,
  }) {
    return _then(_ConditionsGroup(
      conditions: null == conditions
          ? _self._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<ConditionSelectionElement>,
      conditionType: freezed == conditionType
          ? _self.conditionType
          : conditionType // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
mixin _$ConditionSelectionElement {
  int get position;
  ConditionSelection? get conditionSelection;
  OperationSelection? get operationSelection;
  dynamic get filterSelection;

  /// Create a copy of ConditionSelectionElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConditionSelectionElementCopyWith<ConditionSelectionElement> get copyWith =>
      _$ConditionSelectionElementCopyWithImpl<ConditionSelectionElement>(
          this as ConditionSelectionElement, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConditionSelectionElement &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.conditionSelection, conditionSelection) ||
                other.conditionSelection == conditionSelection) &&
            (identical(other.operationSelection, operationSelection) ||
                other.operationSelection == operationSelection) &&
            const DeepCollectionEquality()
                .equals(other.filterSelection, filterSelection));
  }

  @override
  int get hashCode => Object.hash(runtimeType, position, conditionSelection,
      operationSelection, const DeepCollectionEquality().hash(filterSelection));

  @override
  String toString() {
    return 'ConditionSelectionElement(position: $position, conditionSelection: $conditionSelection, operationSelection: $operationSelection, filterSelection: $filterSelection)';
  }
}

/// @nodoc
abstract mixin class $ConditionSelectionElementCopyWith<$Res> {
  factory $ConditionSelectionElementCopyWith(ConditionSelectionElement value,
          $Res Function(ConditionSelectionElement) _then) =
      _$ConditionSelectionElementCopyWithImpl;
  @useResult
  $Res call(
      {int position,
      ConditionSelection? conditionSelection,
      OperationSelection? operationSelection,
      dynamic filterSelection});
}

/// @nodoc
class _$ConditionSelectionElementCopyWithImpl<$Res>
    implements $ConditionSelectionElementCopyWith<$Res> {
  _$ConditionSelectionElementCopyWithImpl(this._self, this._then);

  final ConditionSelectionElement _self;
  final $Res Function(ConditionSelectionElement) _then;

  /// Create a copy of ConditionSelectionElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? conditionSelection = freezed,
    Object? operationSelection = freezed,
    Object? filterSelection = freezed,
  }) {
    return _then(_self.copyWith(
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      conditionSelection: freezed == conditionSelection
          ? _self.conditionSelection
          : conditionSelection // ignore: cast_nullable_to_non_nullable
              as ConditionSelection?,
      operationSelection: freezed == operationSelection
          ? _self.operationSelection
          : operationSelection // ignore: cast_nullable_to_non_nullable
              as OperationSelection?,
      filterSelection: freezed == filterSelection
          ? _self.filterSelection
          : filterSelection // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConditionSelectionElement].
extension ConditionSelectionElementPatterns on ConditionSelectionElement {
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
    TResult Function(_ConditionSelectionElement value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConditionSelectionElement() when $default != null:
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
    TResult Function(_ConditionSelectionElement value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionSelectionElement():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_ConditionSelectionElement value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionSelectionElement() when $default != null:
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
    TResult Function(int position, ConditionSelection? conditionSelection,
            OperationSelection? operationSelection, dynamic filterSelection)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConditionSelectionElement() when $default != null:
        return $default(_that.position, _that.conditionSelection,
            _that.operationSelection, _that.filterSelection);
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
    TResult Function(int position, ConditionSelection? conditionSelection,
            OperationSelection? operationSelection, dynamic filterSelection)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionSelectionElement():
        return $default(_that.position, _that.conditionSelection,
            _that.operationSelection, _that.filterSelection);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(int position, ConditionSelection? conditionSelection,
            OperationSelection? operationSelection, dynamic filterSelection)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConditionSelectionElement() when $default != null:
        return $default(_that.position, _that.conditionSelection,
            _that.operationSelection, _that.filterSelection);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConditionSelectionElement implements ConditionSelectionElement {
  const _ConditionSelectionElement(
      {required this.position,
      this.conditionSelection,
      this.operationSelection,
      this.filterSelection});

  @override
  final int position;
  @override
  final ConditionSelection? conditionSelection;
  @override
  final OperationSelection? operationSelection;
  @override
  final dynamic filterSelection;

  /// Create a copy of ConditionSelectionElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConditionSelectionElementCopyWith<_ConditionSelectionElement>
      get copyWith =>
          __$ConditionSelectionElementCopyWithImpl<_ConditionSelectionElement>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConditionSelectionElement &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.conditionSelection, conditionSelection) ||
                other.conditionSelection == conditionSelection) &&
            (identical(other.operationSelection, operationSelection) ||
                other.operationSelection == operationSelection) &&
            const DeepCollectionEquality()
                .equals(other.filterSelection, filterSelection));
  }

  @override
  int get hashCode => Object.hash(runtimeType, position, conditionSelection,
      operationSelection, const DeepCollectionEquality().hash(filterSelection));

  @override
  String toString() {
    return 'ConditionSelectionElement(position: $position, conditionSelection: $conditionSelection, operationSelection: $operationSelection, filterSelection: $filterSelection)';
  }
}

/// @nodoc
abstract mixin class _$ConditionSelectionElementCopyWith<$Res>
    implements $ConditionSelectionElementCopyWith<$Res> {
  factory _$ConditionSelectionElementCopyWith(_ConditionSelectionElement value,
          $Res Function(_ConditionSelectionElement) _then) =
      __$ConditionSelectionElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int position,
      ConditionSelection? conditionSelection,
      OperationSelection? operationSelection,
      dynamic filterSelection});
}

/// @nodoc
class __$ConditionSelectionElementCopyWithImpl<$Res>
    implements _$ConditionSelectionElementCopyWith<$Res> {
  __$ConditionSelectionElementCopyWithImpl(this._self, this._then);

  final _ConditionSelectionElement _self;
  final $Res Function(_ConditionSelectionElement) _then;

  /// Create a copy of ConditionSelectionElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? position = null,
    Object? conditionSelection = freezed,
    Object? operationSelection = freezed,
    Object? filterSelection = freezed,
  }) {
    return _then(_ConditionSelectionElement(
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      conditionSelection: freezed == conditionSelection
          ? _self.conditionSelection
          : conditionSelection // ignore: cast_nullable_to_non_nullable
              as ConditionSelection?,
      operationSelection: freezed == operationSelection
          ? _self.operationSelection
          : operationSelection // ignore: cast_nullable_to_non_nullable
              as OperationSelection?,
      filterSelection: freezed == filterSelection
          ? _self.filterSelection
          : filterSelection // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

// dart format on
