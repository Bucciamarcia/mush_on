// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'single_dog_health_events_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SingleDogHealthEvent {
  Object get event;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SingleDogHealthEvent &&
            const DeepCollectionEquality().equals(other.event, event));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(event));

  @override
  String toString() {
    return 'SingleDogHealthEvent(event: $event)';
  }
}

/// @nodoc
class $SingleDogHealthEventCopyWith<$Res> {
  $SingleDogHealthEventCopyWith(
      SingleDogHealthEvent _, $Res Function(SingleDogHealthEvent) __);
}

/// Adds pattern-matching-related methods to [SingleDogHealthEvent].
extension SingleDogHealthEventPatterns on SingleDogHealthEvent {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthEventWrapper value)? healthEvent,
    TResult Function(VaccinationWrapper value)? vaccination,
    TResult Function(HeatCycleWrapper value)? heat,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HealthEventWrapper() when healthEvent != null:
        return healthEvent(_that);
      case VaccinationWrapper() when vaccination != null:
        return vaccination(_that);
      case HeatCycleWrapper() when heat != null:
        return heat(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(HealthEventWrapper value) healthEvent,
    required TResult Function(VaccinationWrapper value) vaccination,
    required TResult Function(HeatCycleWrapper value) heat,
  }) {
    final _that = this;
    switch (_that) {
      case HealthEventWrapper():
        return healthEvent(_that);
      case VaccinationWrapper():
        return vaccination(_that);
      case HeatCycleWrapper():
        return heat(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthEventWrapper value)? healthEvent,
    TResult? Function(VaccinationWrapper value)? vaccination,
    TResult? Function(HeatCycleWrapper value)? heat,
  }) {
    final _that = this;
    switch (_that) {
      case HealthEventWrapper() when healthEvent != null:
        return healthEvent(_that);
      case VaccinationWrapper() when vaccination != null:
        return vaccination(_that);
      case HeatCycleWrapper() when heat != null:
        return heat(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(HealthEvent event)? healthEvent,
    TResult Function(Vaccination event)? vaccination,
    TResult Function(HeatCycle event)? heat,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HealthEventWrapper() when healthEvent != null:
        return healthEvent(_that.event);
      case VaccinationWrapper() when vaccination != null:
        return vaccination(_that.event);
      case HeatCycleWrapper() when heat != null:
        return heat(_that.event);
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
  TResult when<TResult extends Object?>({
    required TResult Function(HealthEvent event) healthEvent,
    required TResult Function(Vaccination event) vaccination,
    required TResult Function(HeatCycle event) heat,
  }) {
    final _that = this;
    switch (_that) {
      case HealthEventWrapper():
        return healthEvent(_that.event);
      case VaccinationWrapper():
        return vaccination(_that.event);
      case HeatCycleWrapper():
        return heat(_that.event);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(HealthEvent event)? healthEvent,
    TResult? Function(Vaccination event)? vaccination,
    TResult? Function(HeatCycle event)? heat,
  }) {
    final _that = this;
    switch (_that) {
      case HealthEventWrapper() when healthEvent != null:
        return healthEvent(_that.event);
      case VaccinationWrapper() when vaccination != null:
        return vaccination(_that.event);
      case HeatCycleWrapper() when heat != null:
        return heat(_that.event);
      case _:
        return null;
    }
  }
}

/// @nodoc

class HealthEventWrapper implements SingleDogHealthEvent {
  const HealthEventWrapper(this.event);

  @override
  final HealthEvent event;

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HealthEventWrapperCopyWith<HealthEventWrapper> get copyWith =>
      _$HealthEventWrapperCopyWithImpl<HealthEventWrapper>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HealthEventWrapper &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event);

  @override
  String toString() {
    return 'SingleDogHealthEvent.healthEvent(event: $event)';
  }
}

/// @nodoc
abstract mixin class $HealthEventWrapperCopyWith<$Res>
    implements $SingleDogHealthEventCopyWith<$Res> {
  factory $HealthEventWrapperCopyWith(
          HealthEventWrapper value, $Res Function(HealthEventWrapper) _then) =
      _$HealthEventWrapperCopyWithImpl;
  @useResult
  $Res call({HealthEvent event});

  $HealthEventCopyWith<$Res> get event;
}

/// @nodoc
class _$HealthEventWrapperCopyWithImpl<$Res>
    implements $HealthEventWrapperCopyWith<$Res> {
  _$HealthEventWrapperCopyWithImpl(this._self, this._then);

  final HealthEventWrapper _self;
  final $Res Function(HealthEventWrapper) _then;

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? event = null,
  }) {
    return _then(HealthEventWrapper(
      null == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as HealthEvent,
    ));
  }

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthEventCopyWith<$Res> get event {
    return $HealthEventCopyWith<$Res>(_self.event, (value) {
      return _then(_self.copyWith(event: value));
    });
  }
}

/// @nodoc

class VaccinationWrapper implements SingleDogHealthEvent {
  const VaccinationWrapper(this.event);

  @override
  final Vaccination event;

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VaccinationWrapperCopyWith<VaccinationWrapper> get copyWith =>
      _$VaccinationWrapperCopyWithImpl<VaccinationWrapper>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VaccinationWrapper &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event);

  @override
  String toString() {
    return 'SingleDogHealthEvent.vaccination(event: $event)';
  }
}

/// @nodoc
abstract mixin class $VaccinationWrapperCopyWith<$Res>
    implements $SingleDogHealthEventCopyWith<$Res> {
  factory $VaccinationWrapperCopyWith(
          VaccinationWrapper value, $Res Function(VaccinationWrapper) _then) =
      _$VaccinationWrapperCopyWithImpl;
  @useResult
  $Res call({Vaccination event});

  $VaccinationCopyWith<$Res> get event;
}

/// @nodoc
class _$VaccinationWrapperCopyWithImpl<$Res>
    implements $VaccinationWrapperCopyWith<$Res> {
  _$VaccinationWrapperCopyWithImpl(this._self, this._then);

  final VaccinationWrapper _self;
  final $Res Function(VaccinationWrapper) _then;

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? event = null,
  }) {
    return _then(VaccinationWrapper(
      null == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as Vaccination,
    ));
  }

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VaccinationCopyWith<$Res> get event {
    return $VaccinationCopyWith<$Res>(_self.event, (value) {
      return _then(_self.copyWith(event: value));
    });
  }
}

/// @nodoc

class HeatCycleWrapper implements SingleDogHealthEvent {
  const HeatCycleWrapper(this.event);

  @override
  final HeatCycle event;

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeatCycleWrapperCopyWith<HeatCycleWrapper> get copyWith =>
      _$HeatCycleWrapperCopyWithImpl<HeatCycleWrapper>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeatCycleWrapper &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event);

  @override
  String toString() {
    return 'SingleDogHealthEvent.heat(event: $event)';
  }
}

/// @nodoc
abstract mixin class $HeatCycleWrapperCopyWith<$Res>
    implements $SingleDogHealthEventCopyWith<$Res> {
  factory $HeatCycleWrapperCopyWith(
          HeatCycleWrapper value, $Res Function(HeatCycleWrapper) _then) =
      _$HeatCycleWrapperCopyWithImpl;
  @useResult
  $Res call({HeatCycle event});

  $HeatCycleCopyWith<$Res> get event;
}

/// @nodoc
class _$HeatCycleWrapperCopyWithImpl<$Res>
    implements $HeatCycleWrapperCopyWith<$Res> {
  _$HeatCycleWrapperCopyWithImpl(this._self, this._then);

  final HeatCycleWrapper _self;
  final $Res Function(HeatCycleWrapper) _then;

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? event = null,
  }) {
    return _then(HeatCycleWrapper(
      null == event
          ? _self.event
          : event // ignore: cast_nullable_to_non_nullable
              as HeatCycle,
    ));
  }

  /// Create a copy of SingleDogHealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HeatCycleCopyWith<$Res> get event {
    return $HeatCycleCopyWith<$Res>(_self.event, (value) {
      return _then(_self.copyWith(event: value));
    });
  }
}

// dart format on
