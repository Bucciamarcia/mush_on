// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TourType {
  String get id;

  /// Internal name of the tour type.
  String get name;

  /// Name of  the tour to show to the customers.
  String get displayName;

  /// How many km this tour will do.
  double get distance;

  /// Duration of the tour in minutes.
  int get duration;

  /// Internal notes regarding the tour.
  String? get notes;

  /// Description to show to the customer of this tour.
  String? get displayDescription;

  /// Create a copy of TourType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TourTypeCopyWith<TourType> get copyWith =>
      _$TourTypeCopyWithImpl<TourType>(this as TourType, _$identity);

  /// Serializes this TourType to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TourType &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.displayDescription, displayDescription) ||
                other.displayDescription == displayDescription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, displayName, distance,
      duration, notes, displayDescription);

  @override
  String toString() {
    return 'TourType(id: $id, name: $name, displayName: $displayName, distance: $distance, duration: $duration, notes: $notes, displayDescription: $displayDescription)';
  }
}

/// @nodoc
abstract mixin class $TourTypeCopyWith<$Res> {
  factory $TourTypeCopyWith(TourType value, $Res Function(TourType) _then) =
      _$TourTypeCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String displayName,
      double distance,
      int duration,
      String? notes,
      String? displayDescription});
}

/// @nodoc
class _$TourTypeCopyWithImpl<$Res> implements $TourTypeCopyWith<$Res> {
  _$TourTypeCopyWithImpl(this._self, this._then);

  final TourType _self;
  final $Res Function(TourType) _then;

  /// Create a copy of TourType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? distance = null,
    Object? duration = null,
    Object? notes = freezed,
    Object? displayDescription = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      displayDescription: freezed == displayDescription
          ? _self.displayDescription
          : displayDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TourType implements TourType {
  const _TourType(
      {required this.id,
      this.name = "",
      this.displayName = "",
      this.distance = 0,
      required this.duration,
      this.notes,
      this.displayDescription});
  factory _TourType.fromJson(Map<String, dynamic> json) =>
      _$TourTypeFromJson(json);

  @override
  final String id;

  /// Internal name of the tour type.
  @override
  @JsonKey()
  final String name;

  /// Name of  the tour to show to the customers.
  @override
  @JsonKey()
  final String displayName;

  /// How many km this tour will do.
  @override
  @JsonKey()
  final double distance;

  /// Duration of the tour in minutes.
  @override
  final int duration;

  /// Internal notes regarding the tour.
  @override
  final String? notes;

  /// Description to show to the customer of this tour.
  @override
  final String? displayDescription;

  /// Create a copy of TourType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TourTypeCopyWith<_TourType> get copyWith =>
      __$TourTypeCopyWithImpl<_TourType>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TourTypeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TourType &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.displayDescription, displayDescription) ||
                other.displayDescription == displayDescription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, displayName, distance,
      duration, notes, displayDescription);

  @override
  String toString() {
    return 'TourType(id: $id, name: $name, displayName: $displayName, distance: $distance, duration: $duration, notes: $notes, displayDescription: $displayDescription)';
  }
}

/// @nodoc
abstract mixin class _$TourTypeCopyWith<$Res>
    implements $TourTypeCopyWith<$Res> {
  factory _$TourTypeCopyWith(_TourType value, $Res Function(_TourType) _then) =
      __$TourTypeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String displayName,
      double distance,
      int duration,
      String? notes,
      String? displayDescription});
}

/// @nodoc
class __$TourTypeCopyWithImpl<$Res> implements _$TourTypeCopyWith<$Res> {
  __$TourTypeCopyWithImpl(this._self, this._then);

  final _TourType _self;
  final $Res Function(_TourType) _then;

  /// Create a copy of TourType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? distance = null,
    Object? duration = null,
    Object? notes = freezed,
    Object? displayDescription = freezed,
  }) {
    return _then(_TourType(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      displayDescription: freezed == displayDescription
          ? _self.displayDescription
          : displayDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TourTypePricing {
  String get id;

  /// The internal name of this pricing.
  String get name;

  /// Is the price archived? Can't be deleted or edited bc continuity.
  bool get isArchived;

  /// The display name of this pricing, to show to customers.
  String get displayName;

  /// The internal notes of this pricing.
  String? get notes;

  /// The description of this tour to show to customers.
  String? get displayDescription;

  /// The price of this tour.
  int get priceCents;

  /// Create a copy of TourTypePricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TourTypePricingCopyWith<TourTypePricing> get copyWith =>
      _$TourTypePricingCopyWithImpl<TourTypePricing>(
          this as TourTypePricing, _$identity);

  /// Serializes this TourTypePricing to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TourTypePricing &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.displayDescription, displayDescription) ||
                other.displayDescription == displayDescription) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isArchived,
      displayName, notes, displayDescription, priceCents);

  @override
  String toString() {
    return 'TourTypePricing(id: $id, name: $name, isArchived: $isArchived, displayName: $displayName, notes: $notes, displayDescription: $displayDescription, priceCents: $priceCents)';
  }
}

/// @nodoc
abstract mixin class $TourTypePricingCopyWith<$Res> {
  factory $TourTypePricingCopyWith(
          TourTypePricing value, $Res Function(TourTypePricing) _then) =
      _$TourTypePricingCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      bool isArchived,
      String displayName,
      String? notes,
      String? displayDescription,
      int priceCents});
}

/// @nodoc
class _$TourTypePricingCopyWithImpl<$Res>
    implements $TourTypePricingCopyWith<$Res> {
  _$TourTypePricingCopyWithImpl(this._self, this._then);

  final TourTypePricing _self;
  final $Res Function(TourTypePricing) _then;

  /// Create a copy of TourTypePricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isArchived = null,
    Object? displayName = null,
    Object? notes = freezed,
    Object? displayDescription = freezed,
    Object? priceCents = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isArchived: null == isArchived
          ? _self.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      displayDescription: freezed == displayDescription
          ? _self.displayDescription
          : displayDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      priceCents: null == priceCents
          ? _self.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TourTypePricing implements TourTypePricing {
  const _TourTypePricing(
      {required this.id,
      this.name = "",
      this.isArchived = false,
      this.displayName = "",
      this.notes,
      this.displayDescription,
      this.priceCents = 0});
  factory _TourTypePricing.fromJson(Map<String, dynamic> json) =>
      _$TourTypePricingFromJson(json);

  @override
  final String id;

  /// The internal name of this pricing.
  @override
  @JsonKey()
  final String name;

  /// Is the price archived? Can't be deleted or edited bc continuity.
  @override
  @JsonKey()
  final bool isArchived;

  /// The display name of this pricing, to show to customers.
  @override
  @JsonKey()
  final String displayName;

  /// The internal notes of this pricing.
  @override
  final String? notes;

  /// The description of this tour to show to customers.
  @override
  final String? displayDescription;

  /// The price of this tour.
  @override
  @JsonKey()
  final int priceCents;

  /// Create a copy of TourTypePricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TourTypePricingCopyWith<_TourTypePricing> get copyWith =>
      __$TourTypePricingCopyWithImpl<_TourTypePricing>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TourTypePricingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TourTypePricing &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.displayDescription, displayDescription) ||
                other.displayDescription == displayDescription) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isArchived,
      displayName, notes, displayDescription, priceCents);

  @override
  String toString() {
    return 'TourTypePricing(id: $id, name: $name, isArchived: $isArchived, displayName: $displayName, notes: $notes, displayDescription: $displayDescription, priceCents: $priceCents)';
  }
}

/// @nodoc
abstract mixin class _$TourTypePricingCopyWith<$Res>
    implements $TourTypePricingCopyWith<$Res> {
  factory _$TourTypePricingCopyWith(
          _TourTypePricing value, $Res Function(_TourTypePricing) _then) =
      __$TourTypePricingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      bool isArchived,
      String displayName,
      String? notes,
      String? displayDescription,
      int priceCents});
}

/// @nodoc
class __$TourTypePricingCopyWithImpl<$Res>
    implements _$TourTypePricingCopyWith<$Res> {
  __$TourTypePricingCopyWithImpl(this._self, this._then);

  final _TourTypePricing _self;
  final $Res Function(_TourTypePricing) _then;

  /// Create a copy of TourTypePricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isArchived = null,
    Object? displayName = null,
    Object? notes = freezed,
    Object? displayDescription = freezed,
    Object? priceCents = null,
  }) {
    return _then(_TourTypePricing(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isArchived: null == isArchived
          ? _self.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      displayDescription: freezed == displayDescription
          ? _self.displayDescription
          : displayDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      priceCents: null == priceCents
          ? _self.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
