import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/custom_converters.dart';
part 'models.g.dart';
part 'models.freezed.dart';

@freezed
abstract class HealthEvent with _$HealthEvent {
  @JsonSerializable(explicitToJson: true)
  const factory HealthEvent({
    /// Unique uuid of this event
    required String id,

    /// The dog associated with this event
    required String dogId,

    /// When the event was created initially
    @NonNullableTimestampConverter() required DateTime createdAt,

    /// When the event was last updated.
    @NonNullableTimestampConverter() required DateTime lastUpdated,

    /// The title of the event
    required String title,

    /// The date of this event
    @TimestampConverter() required DateTime date,

    /// When the event was solved. If null, still ongoing.
    /// If == date, it's a one shot event.
    @TimestampConverter() DateTime? resolvedDate,

    /// Does this health event prevent the dog from running?
    @Default(false) bool preventFromRunning,

    /// Other notes for this event
    @Default("") String notes,

    /// The type of this event (enum)
    @Default(HealthEventType.observation) HealthEventType eventType,

    /// Document paths related to this event
    @Default([]) List<String> documentIds,
  }) = _HealthEvent;
  factory HealthEvent.fromJson(Map<String, dynamic> json) =>
      _$HealthEventFromJson(json);
}

extension HealthEventExtension on HealthEvent {
  bool get isOneShot => createdAt == resolvedDate;
  bool get isOngoing => resolvedDate == null;
  bool get isResolved => resolvedDate != null && resolvedDate != date;
  Duration? get duration => resolvedDate?.difference(date);
}

extension HealthEventsExtension on List<HealthEvent> {
  List<HealthEvent> get active => where((e) => e.resolvedDate == null).toList();

  List<HealthEvent> getRecentlySolved({required int days}) {
    return where((e) {
      if (e.resolvedDate == null) return false;
      if (e.isResolved &&
          e.resolvedDate!.isAfter(
            DateTimeUtils.today().subtract(
              Duration(days: days),
            ),
          )) {
        return true;
      }
      return false;
    }).toList();
  }
}

@freezed
abstract class Vaccination with _$Vaccination {
  const factory Vaccination({
    /// The unique uuid of the vaccination
    required String id,

    /// The dog's id associated with this vaccination
    required String dogId,

    /// When the event was created initially
    @NonNullableTimestampConverter() required DateTime createdAt,

    /// When the event was last updated.
    @NonNullableTimestampConverter() required DateTime lastUpdated,

    /// When the vaccination was administered
    @NonNullableTimestampConverter() required DateTime dateAdministered,

    /// When this vaccination expires
    @TimestampConverter() DateTime? expirationDate,

    /// The ids of the documents related to the vaccination
    @Default([]) List<String> documentIds,

    /// The custom title of this vaccination.
    required String title,

    /// Some custom notes for the vaccination.
    @Default("") String notes,

    /// The type of vaccination (eg. "rabies")
    required String vaccinationType,
  }) = _Vaccination;

  factory Vaccination.fromJson(Map<String, dynamic> json) =>
      _$VaccinationFromJson(json);
}

extension VaccinationsExtension on List<Vaccination> {
  List<Vaccination> expiringSoon({required int days}) {
    return where((v) {
      if (v.expirationDate == null) return false;
      if (v.expirationDate!.isAfter(DateTimeUtils.today()) &&
          v.expirationDate!
              .isBefore(DateTimeUtils.today().add(Duration(days: days)))) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  List<Vaccination> get overdue {
    return where((v) {
      if (v.expirationDate == null) return false;
      if (v.expirationDate!.isBefore(DateTimeUtils.today())) return true;
      return false;
    }).toList();
  }
}

@freezed
abstract class HeatCycle with _$HeatCycle {
  const factory HeatCycle({
    /// The unique id of this heat event.
    required String id,

    /// The dog's id associated with this heat event.
    required String dogId,

    /// Notes regarding this heat.
    @Default("") String notes,

    /// Heat started date
    @NonNullableTimestampConverter() required DateTime startDate,

    /// When the event was created initially
    @NonNullableTimestampConverter() required DateTime createdAt,

    /// When the event was last updated.
    @NonNullableTimestampConverter() required DateTime lastUpdated,

    /// This heat prevents the dog from running
    @Default(false) bool preventFromRunning,

    /// When it finished. If null, still ongoing.
    @TimestampConverter() DateTime? endDate,
  }) = _HeatCycle;
  factory HeatCycle.fromJson(Map<String, dynamic> json) =>
      _$HeatCycleFromJson(json);
}

extension HeatCyclesExtension on List<HeatCycle> {
  List<HeatCycle> get active => where((c) => c.endDate == null).toList();
}

@JsonEnum()
enum HealthEventType {
  injury,
  illness,
  vetVisit,
  procedure,
  observation,
  other
}
