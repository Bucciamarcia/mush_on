// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsModel {
  List<CustomFieldTemplate> get customFieldTemplates;
  List<DistanceWarning> get globalDistanceWarnings;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SettingsModelCopyWith<SettingsModel> get copyWith =>
      _$SettingsModelCopyWithImpl<SettingsModel>(
          this as SettingsModel, _$identity);

  /// Serializes this SettingsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SettingsModel &&
            const DeepCollectionEquality()
                .equals(other.customFieldTemplates, customFieldTemplates) &&
            const DeepCollectionEquality()
                .equals(other.globalDistanceWarnings, globalDistanceWarnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(customFieldTemplates),
      const DeepCollectionEquality().hash(globalDistanceWarnings));

  @override
  String toString() {
    return 'SettingsModel(customFieldTemplates: $customFieldTemplates, globalDistanceWarnings: $globalDistanceWarnings)';
  }
}

/// @nodoc
abstract mixin class $SettingsModelCopyWith<$Res> {
  factory $SettingsModelCopyWith(
          SettingsModel value, $Res Function(SettingsModel) _then) =
      _$SettingsModelCopyWithImpl;
  @useResult
  $Res call(
      {List<CustomFieldTemplate> customFieldTemplates,
      List<DistanceWarning> globalDistanceWarnings});
}

/// @nodoc
class _$SettingsModelCopyWithImpl<$Res>
    implements $SettingsModelCopyWith<$Res> {
  _$SettingsModelCopyWithImpl(this._self, this._then);

  final SettingsModel _self;
  final $Res Function(SettingsModel) _then;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customFieldTemplates = null,
    Object? globalDistanceWarnings = null,
  }) {
    return _then(_self.copyWith(
      customFieldTemplates: null == customFieldTemplates
          ? _self.customFieldTemplates
          : customFieldTemplates // ignore: cast_nullable_to_non_nullable
              as List<CustomFieldTemplate>,
      globalDistanceWarnings: null == globalDistanceWarnings
          ? _self.globalDistanceWarnings
          : globalDistanceWarnings // ignore: cast_nullable_to_non_nullable
              as List<DistanceWarning>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SettingsModel implements SettingsModel {
  const _SettingsModel(
      {final List<CustomFieldTemplate> customFieldTemplates = const [],
      final List<DistanceWarning> globalDistanceWarnings = const []})
      : _customFieldTemplates = customFieldTemplates,
        _globalDistanceWarnings = globalDistanceWarnings;
  factory _SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  final List<CustomFieldTemplate> _customFieldTemplates;
  @override
  @JsonKey()
  List<CustomFieldTemplate> get customFieldTemplates {
    if (_customFieldTemplates is EqualUnmodifiableListView)
      return _customFieldTemplates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customFieldTemplates);
  }

  final List<DistanceWarning> _globalDistanceWarnings;
  @override
  @JsonKey()
  List<DistanceWarning> get globalDistanceWarnings {
    if (_globalDistanceWarnings is EqualUnmodifiableListView)
      return _globalDistanceWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_globalDistanceWarnings);
  }

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SettingsModelCopyWith<_SettingsModel> get copyWith =>
      __$SettingsModelCopyWithImpl<_SettingsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SettingsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SettingsModel &&
            const DeepCollectionEquality()
                .equals(other._customFieldTemplates, _customFieldTemplates) &&
            const DeepCollectionEquality().equals(
                other._globalDistanceWarnings, _globalDistanceWarnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_customFieldTemplates),
      const DeepCollectionEquality().hash(_globalDistanceWarnings));

  @override
  String toString() {
    return 'SettingsModel(customFieldTemplates: $customFieldTemplates, globalDistanceWarnings: $globalDistanceWarnings)';
  }
}

/// @nodoc
abstract mixin class _$SettingsModelCopyWith<$Res>
    implements $SettingsModelCopyWith<$Res> {
  factory _$SettingsModelCopyWith(
          _SettingsModel value, $Res Function(_SettingsModel) _then) =
      __$SettingsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<CustomFieldTemplate> customFieldTemplates,
      List<DistanceWarning> globalDistanceWarnings});
}

/// @nodoc
class __$SettingsModelCopyWithImpl<$Res>
    implements _$SettingsModelCopyWith<$Res> {
  __$SettingsModelCopyWithImpl(this._self, this._then);

  final _SettingsModel _self;
  final $Res Function(_SettingsModel) _then;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? customFieldTemplates = null,
    Object? globalDistanceWarnings = null,
  }) {
    return _then(_SettingsModel(
      customFieldTemplates: null == customFieldTemplates
          ? _self._customFieldTemplates
          : customFieldTemplates // ignore: cast_nullable_to_non_nullable
              as List<CustomFieldTemplate>,
      globalDistanceWarnings: null == globalDistanceWarnings
          ? _self._globalDistanceWarnings
          : globalDistanceWarnings // ignore: cast_nullable_to_non_nullable
              as List<DistanceWarning>,
    ));
  }
}

// dart format on
