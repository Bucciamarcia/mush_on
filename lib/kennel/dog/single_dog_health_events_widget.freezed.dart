// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
